### IMPORTS ###
# core
url = require "url"

# atom
{$} = require "atom"

# timerkeeper
Timer = require "./timer.coffee"
TimekeeperView = null # Defer until use

### VIEW HANDLING ###
createTimekeeperView = ( state ) ->
    ### REQUIRES ###
    TimekeeperView ?= require "./views/index.coffee"

    # Check if we have a view already
    return new TimekeeperView( state )

### EXPORTS ###
module.exports =
    ### ATTRIBUTES ###
    timer: null
    timekeeperView: null

    ### DEACTIVATE ###
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
        atom.workspaceView.command "timekeeper:start", => @timer.start()
        atom.workspaceView.command "timekeeper:pause", => @timer.pause()
        atom.workspaceView.command "timekeeper:finish", => @timer.finish()
        atom.workspaceView.command "timekeeper:reset", => @timer.reset()
        atom.workspaceView.command "timekeeper:abort", => @timer.abort()

        # Setup views & related commands
        atom.workspaceView.command "timekeeper:dashboard", => @dashboard()

        # Setup event handlers
        # Render views
        $( window ).on "ready", =>
            # Attach the timer views
            @timer.renderStatusBarViews()

        # Track focus to set auto-pauses
        # Start/End autopause based on window focus
        $( window ).on "blur", =>
            # Just call the autopause method of the timer object
            @timer.autopause()
        $( window ).on "focus", =>
            # Just call the autopause method of the timer object
            @timer.autopause()

        # Watch for theme changes/reloads to reload our view
        atom.themes.on "reloaded", =>
            # Reset the view
            @timekeeperView = null

        # Register the opener for timekeeper
        atom.workspace.registerOpener ( uriToOpen ) =>
            # See if we can use the uri provided
            try
                # Split up the uri in to parts
                {protocol, host, pathname} = url.parse( uriToOpen )
            catch error
                # There seems to have been an error, just quietly return
                return

            # Check if we have a protocol we want, and it is timekeeper, return otherwise
            return unless protocol is 'timekeeper:'

            # Try and verify the view/page we want to open
            try
                # Decode the path, and see if it is among valid ones
                pathname = decodeURI( pathname ) if pathname
            catch error
                # The path to open could not be validated and errored out
                return

            # Check if we have the path in our list
            if pathname not in [ "/dashboard" ]
                # We do not recognize the timekeeper path, return
                return

            # Check if we have a timekeeper view we can use
            if @timekeeperView is null
                # Get the timekeeper view now
                @timekeeperView = createTimekeeperView( page: pathname )

            # Return the view
            return @timekeeperView

    ### DEACTIVATE ###
    deactivate: ->
        # Destroy the timekeeper object at this point
        @timer = null

        # Reset the view & destroy it
        @timekeeperView.destroy()

        # Reset view
        @timekeeperView = null

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
        atom.workspace.open( "timekeeper://ui/dashboard", split: 'right', searchAllPanes: true )