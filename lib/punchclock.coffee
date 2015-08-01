### IMPORTS ###
# core
url = require "url"

# atom
{$} = require 'atom-space-pen-views'

# timerkeeper
Timer = require "./timer.coffee"
PunchclockView = null # Defer until use

### VIEW HANDLING ###
createPunchclockView = ( state ) ->
    ### REQUIRES ###
    PunchclockView ?= require "./views/index.coffee"

    # Check if we have a view already
    return new PunchclockView( state )

### EXPORTS ###
module.exports =
    ### CONFIGURATION ###
    config:
        # Auto Enable Time Tracking - default to false, leave up to user to turn it on if desired
        autoEnableTimeTrackingOnLoad:
          type: 'boolean'
          default: false

    ### ATTRIBUTES ###
    timer: null
    punchclockView: null

    ### ACTIVATE ###
    activate: ( state ) ->
        # We only want to activate the package if there is a valid project
        # Not handling atom being loaded without a project at this point - TODO
        # Wrap the below in try catch since we throw an error from the constructor on
        # no valid current project being opened. We still call the Timer since we want to
        # handle any data save from a previous session
        try
            # Setup the Timer object
            @timer = new Timer( state )

            # Call initialize to setup commands & event handlers
            @initialize( state )
        catch timerError
            # Throw the error for the benefit of package manager activePackage
            throw timerError

    ### INITIALIZE ###
    initialize: ( state ) ->
        # Setup the commands
        atom.commands.add 'atom-workspace', "punchclock:start", => @timer.start()
        atom.commands.add 'atom-workspace', "punchclock:pause", => @timer.pause()
        atom.commands.add 'atom-workspace', "punchclock:finish", => @timer.finish()
        atom.commands.add 'atom-workspace', "punchclock:reset", => @timer.reset()
        atom.commands.add 'atom-workspace', "punchclock:abort", => @timer.abort()

        # Setup views & related commands
        atom.commands.add 'atom-workspace', "punchclock:dashboard", => @dashboard()

        # Setup event handlers - only if we are not in spec mode
        if atom.mode isnt "spec"
            # Render views
            $( window ).ready =>
                # Attach the timer views
                @timer.renderStatusBarViews()
                # Call autostart to check if we want to autostart time tracking
                @timer.autostart()

            ## Below is severely deprecated, must fix
            # Track focus to set auto-pauses
            # Start/End autopause based on window focus
            $( window ).blur =>
                # Just call the autopause method of the timer object
                @timer.autopause()
            $( window ).focus =>
                # Just call the autopause method of the timer object
                @timer.autopause()

            #register callback for loading/unloading project folders.
            atom.project.onDidChangePaths =>
                @timer.didChangePaths()

        # Watch for theme changes/reloads to reload our view
        atom.themes.onDidChangeActiveThemes =>
            # Reset the view
            @punchclockView = null

        # Register the opener for punchclock
        atom.workspace.addOpener ( uriToOpen ) =>
            # See if we can use the uri provided
            try
                # Split up the uri in to parts
                {protocol, host, pathname} = url.parse( uriToOpen )
            catch error
                # There seems to have been an error, just quietly return
                return

            # Check if we have a protocol we want, and it is punchclock, return otherwise
            return unless protocol is 'punchclock:'

            # Try and verify the view/page we want to open
            try
                # Decode the path, and see if it is among valid ones
                pathname = decodeURI( pathname ) if pathname
            catch error
                # The path to open could not be validated and errored out
                return

            # Check if we have the path in our list
            if pathname not in [ "/dashboard" ]
                # We do not recognize the punchclock path, return
                return

            # Check if we have a punchclock view we can use
            if @punchclockView is null
                # Get the punchclock view now
                @punchclockView = createPunchclockView( page: pathname )

            # Return the view
            return @punchclockView

    ### DEACTIVATE ###
    deactivate: ->
        # Destroy the punchclock object at this point
        @timer.destroy()
        @timer = null

        # Only destroy if we ever created it
        if @punchclockView?
            # Reset the view & destroy it
            @punchclockView.detach()

            # Reset view
            @punchclockView = null

    ### SERIALIZE ###
    serialize: ->
        # We want to capture the current time tracker object values
        # to be able to save this data if we are going down without a manual
        # save of the time tracking information
        #
        # Let us return data back only if there was time tracking used
        # @start should not be null if we are tracking, else null
        # if no time tracking or manual save was already done
        if @timer.startTimestamp
            # Return back the data at this point
            return {
                "timerObject": {
                    "project": @timer.currentProject
                    "start": @timer.startTimestamp
                    "end": @timer.endTimestamp
                    "duration": @timer.clock
                    "pauses": @timer.pauses
                    "autoPauses": @timer.autoPauses
                }
            }
        else
            # Doesn't look like we need to restore any data, so return null
            return { "timerObject": null }

    ### DASHBOARD ###
    dashboard: ->
        # Open up the dashboard
        atom.workspace.open( "punchclock://ui/dashboard", split: 'right', searchAllPanes: true )
