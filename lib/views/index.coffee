### IMPORTS ###
# atom
{$, ScrollView} = require 'atom'

# timekeeper
ColorUtils = require "../utilities/colors.coffee"
HeaderView = require "./header.coffee"
NavigationView = require "./navigation.coffee"
FooterView = require "./footer.coffee"
DashboardView = require "./dashboard.coffee"

### EXPORTS ###
module.exports =
    class TimekeeperView extends ScrollView
        ### CONTENT ###
        @content: ->
            # Setup the pane wrapper
            @div class: "timekeeper pane-item", tabindex: -1, =>
                # Setup the container
                @div class: "ui-page", =>
                    # Header
                    @subview outlet: "header", new HeaderView()

                    # Content
                    @div class: "content", =>
                        # Navigation
                        #@subview outlet: "navigation", new NavigationView()

                        # Content
                        @subview outlet: "content", new DashboardView()

        ### CONSTRUCTOR ###
        constructor: ( { @page } ) ->
            # Call the super
            super

            # Check if we have a valid requested page
            if @page?
                # Get the uri path without the forward slash
                controller = @page.substring( 1 ).split( "/" )[0]

                # Strip the forward slash at the page uri

        ### SERIALIZE ###
        serialize: ->

        ### DESTROY ###
        destroy: ->

        ### INTERNAL METHODS ###
        ### GET TITLE ###
        getTitle: ->
            # Return back the title for the view
            return "Timekeeper"


        ### GET ICON NAME ###
        getIconName: ->
            # Return the icon for the view
            return "clock"

        ### GET URI ###
        getUri: ->
            # Return the uri for the view
            return @uri