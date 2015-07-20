### IMPORTS ###
# atom
{View} = require 'atom-space-pen-views'

### EXPORTS ###
module.exports =
    class HeaderView extends View
        ### CONTENT ###
        @content: ->
            # Setup the Container
            @div class: "header", =>
                # Title
                @h2 "Punchclock"
