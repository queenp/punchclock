### IMPORTS ###
{View} = require 'atom-space-pen-views'

### EXPORTS ###
module.exports =
    class StatusView extends View
        ### CONSTRUCTOR ###

        ### CONTENT ###
        @content: ->
            # Setup the container
            @div class: 'punchclock inline-block', =>
                # Inner Container
                @div class: "timer", =>
                    # Status
                    @span outlet: "status", id: "status"

        ### ATTACH ###
        attach: ->
            # Check if we have the status bar
            statusBar = document.querySelector('status-bar')
            if statusBar?
              @statusBarTile = statusBar.addRightTile(item: this, priority:101)
            else
              atom.workspace.addModalPanel(item:this.element, visible: true)

        ### DESTROY ###
        destroy: ->
            # Detach at this point
            @detach()

        ### UPDATE ###
        update: ( value ) ->
            # Update the status with the message
            @status.text( value )

        ### CLEAR ###
        clear: ->
            # Clear any status message
            @status.text( "" )
