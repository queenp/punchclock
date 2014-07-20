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
        # Setup the Timer object
        @timer = new Timer( state )

        # Call initialize to setup commands & event handlers
        @initialize()

    ### INITIALIZE ###
    initialize: ->
        # Setup the commands
        atom.workspaceView.command "timekeeper:start", => @timer.start()
        atom.workspaceView.command "timekeeper:pause", => @timer.pause()
        atom.workspaceView.command "timekeeper:finish", => @timer.finish()
        atom.workspaceView.command "timekeeper:reset", => @timer.reset()
        atom.workspaceView.command "timekeeper:abort", => @timer.abort()

        # Setup event handlers
        $( window ).on "ready", =>
            # Attach the timer views
            @timer.renderStatusBarViews()

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
                }
            }
        else
            # Doesn't look like we need to restore any data, so return null
            return { "timerObject": null }