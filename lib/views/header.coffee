### IMPORTS ###
# atom
{View} = require 'atom'

### EXPORTS ###
module.exports =
    class HeaderView extends View
        ### CONTENT ###
        @content: ->
            # Setup the Container
            @div class: "header", =>
                # Title
                @h2 "Timekeeper"