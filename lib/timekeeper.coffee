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

isTimekeeperView = ( object ) ->
    ### REQUIRES ###
    TimekeeperView ?= require "./views/index.coffee"

    # Return back boolean to indicate if given object is a timekeeper view
    return object instanceof TimekeeperView

### EXPORTS ###
module.exports =
    ### CONFIGURATION ###
    configDefaults:
        # Auto Enable Time Tracking - default to false, leave up to user to turn it on if desired
        autoEnableTimeTrackingOnLoad: false

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
        atom.workspaceView.command "timekeeper:dashboard", => @ui( "dashboard" )
        atom.workspaceView.command "timekeeper:project-settings", => @ui( "project-settings/#" + new Buffer( @timer.currentProject, "utf8" ).toString( "base64" ) )

        # Setup event handlers - only if we are not in spec mode
        if atom.mode isnt "spec"
            # Render views
            $( window ).on "ready", =>
                # Attach the timer views
                @timer.renderStatusBarViews()

                # Call autostart to check if we want to autostart time tracking
                @timer.autostart()

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
                {protocol, host, pathname, hash} = url.parse( uriToOpen )
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
            if pathname.replace( /\//g, "" ) not in [ "dashboard", "project", "project-settings" ]
                # We do not recognize the timekeeper path, return
                return

            # Check if we have a timekeeper view we can use
            if @timekeeperView is null
                # Get the timekeeper view now
                @timekeeperView = createTimekeeperView( page: pathname, id: hash )
            else
                # We might have a different ui page requested so override the previous one
                @timekeeperView.setPage( page: pathname, id: hash )
                @timekeeperView.navigate()

            # Return the view
            return @timekeeperView

    ### DEACTIVATE ###
    deactivate: ->
        # Destroy the timekeeper object at this point
        @timer = null

        # Only destroy if we ever created it
        if @timekeeperView?
            # Reset the view & destroy it
            @timekeeperView.detach()

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

    ### UI ###
    ui: ( page ) ->
        # Check if active pane item is a timekeeper view
        if isTimekeeperView( atom.workspace.activePaneItem )
            # Setup the current timekeeper view page uri
            currentPageUri = atom.workspace.activePaneItem.getUri()
            
            # Check if the ui page requested and current one being displayed are
            # the same, in which case close the view altogether 'toggle' function
            if currentPageUri.split( "/" )[3] is page.split( "/" )[0]
                # The current active pane item is a timekeeper view on the same requested page
                # Close out the view altogether
                atom.workspace.destroyActivePaneItem()

                # Get out at this point
                return

        # Check if we have the timekeeper view open in any pane
        timekeeperViewPane = atom.workspace.paneForUri( "timekeeper://ui/#{page}" )

        # Check if we got a valid pane
        if timekeeperViewPane?
            # We have timekeeper view open, let us close out
            timekeeperViewPane.destroyItem( timekeeperViewPane.itemForUri( "timekeeper://ui/#{page}" ) )

            # Get out at this point
            return

        # Open up the dashboard
        atom.workspace.open( "timekeeper://ui/#{page}", split: 'right', searchAllPanes: true )