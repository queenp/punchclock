### IMPORTS ###
{View} = require 'atom'

### EXPORTS ###
module.exports =
    class ClockView extends View
        ### CONSTRUCTOR ###

        ### CONTENT ###
        @content: ->
            # Setup the container
            @div class: 'timekeeper inline-block', =>
                # Inner Container
                @div class: "timer", =>
                    # Timer
                    @span class: "icon icon-clock"
                    @span outlet: "clock", id: "clock", "00:00:00"

        ### ATTACH ###
        attach: ->
            # Check if we have the status bar
            if atom.workspaceView.statusBar
                # Attach the timekeeper clock view to the status bar if available
                atom.workspaceView.statusBar.prependRight( this )
            else
                # Attach it directly to the workspace view
                # TODO - Fix this (this is a work around for testing)
                atom.workspaceView.appendToTop( this )

        ### DESTROY ###
        destroy: ->
            # Detach at this point
            @detach()

        ### UPDATE ###
        update: ( value ) ->
            # Update the clock with the current timer value
            @clock.text( value )