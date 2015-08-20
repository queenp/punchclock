### IMPORTS ###
# atom
{$, ScrollView} = require 'atom-space-pen-views'

# punchclock
HeaderView = require "./header.coffee"
DashboardView = require "./dashboard.coffee"

### EXPORTS ###
module.exports =
    class PunchclockView extends ScrollView
        ### ATTRIBUTES ###
        page: null
        controller: null

        ### CONTENT ###
        @content: ->
            # Setup the pane wrapper
            @div class: "punchclock pane-item", tabindex: -1, =>
                # Setup the container
                @div class: "ui-page", =>
                    # Header
                    @subview outlet: "header", new HeaderView()

                    # Content
                    @div outlet: "content", class: "content"

        ### CONSTRUCTOR ###

        ### INITIALIZE ###
        initialize: ({@page}) ->
            # Let us check what kind of view we want to generate
            super
            if @page?
                # Get the uri path without the forward slash
                @controller = @page.substring( 1 ).split( "/" )[0]
                        # Let us check what kind of view we want to generate
            if @controller?
                # We have a valid controller, so let us create the view
                # based off that
                switch @controller
                    # Handle Dashboard
                    when "dashboard"
                        # Create the dashboard view
                        viewToDisplay = new DashboardView()
                    else
                        # Default to Dashboard if we cannot handle the page requested
                        viewToDisplay = new DashboardView()

                # Now render the view in the main view
                @content.append( viewToDisplay )
            @on 'click', '.project', (e) =>
                # Open up project data
                console.log($(e.target.closest('.item.project')))

        ### INTERNAL METHODS ###
        ### GET TITLE ###
        getTitle: ->
            # Return back the title for the view
            return "Punchclock"


        ### GET ICON NAME ###
        getIconName: ->
            # Return the icon for the view
            return "clock"

        ### GET URI ###
        getURI: ->
            # Return the uri for the view
            return @uri
