### IMPORTS ###
# atom
{$} = require "atom"

# timerkeeper
Timer = require "./timer.coffee"

### EXPORTS ###
module.exports =
    ### ATTRIBUTES ###
    timer: null

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
            @initialize()
        catch timerError
            # Throw the error for the benefit of package manager activePackage
            throw timerError

    ### INITIALIZE ###
    initialize: ->
        # Setup the commands
        atom.workspaceView.command "timekeeper:start", => @timer.start()
        atom.workspaceView.command "timekeeper:pause", => @timer.pause()
        atom.workspaceView.command "timekeeper:finish", => @timer.finish()
        atom.workspaceView.command "timekeeper:reset", => @timer.reset()
        atom.workspaceView.command "timekeeper:abort", => @timer.abort()

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

    ### DEACTIVATE ###
    deactivate: ->
        # Destroy the timekeeper object at this point
        @timer = null

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