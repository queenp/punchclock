### IMPORTS ###
{View} = require 'atom-space-pen-views'

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
            statusBar = document.querySelector("status-bar")
            if statusBar?
              @statusBarTile = statusBar.addRightTile(item: this, priority: 100)
            else
              atom.workspace.addModalPanel(item:this.element, visible: true)

        ### DESTROY ###
        destroy: ->
            # Detach at this point
            @detach()

        ### UPDATE ###
        update: ( value ) ->
            # Update the clock with the current timer value
            @clock.text( value )
