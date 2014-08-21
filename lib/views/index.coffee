### IMPORTS ###
# atom
{$, ScrollView} = require 'atom'

# timekeeper
HeaderView = require "./header.coffee"
DashboardView = null # Defer until required
ProjectSettingsView = null # Defer until required

### EXPORTS ###
module.exports =
    class TimekeeperView extends ScrollView
        ### ATTRIBUTES ###
        page: null
        id: null
        controller: null

        ### CONTENT ###
        @content: ->
            # Setup the pane wrapper
            @div class: "timekeeper pane-item", tabindex: -1, =>
                # Setup the container
                @div class: "ui-page", =>
                    # Header
                    @subview outlet: "header", new HeaderView()

                    # Content
                    @div outlet: "content", class: "content"

        ### CONSTRUCTOR ###
        constructor: ( { @page, @id } ) ->
            # Check if we have a valid requested page
            if @page?
                # Get the uri path without the forward slash
                @controller = @page.substring( 1 ).split( "/" )[0]

            # Call the super
            super

        ### INITIALIZE ###
        initialize: ->
            # Get the view we want to display
            displayView = @getView()

            # Make sure we have a valid view to display
            if displayView?
                # Discard the current view being displayed
                @content.empty()

                # Now render the view in the main view
                @content.append( displayView )

            # Call the super
            super

        ### NAVIGATE ###
        navigate: ( path ) ->
            # Get the view we want to display
            displayView = @getView()

            # Make sure we have a valid view to display
            if displayView?
                # Discard the current view being displayed
                @content.empty()

                # Now render the view in the main view
                @content.append( displayView )

        ### SET PAGE ###
        setPage: ( { @page, @id } ) ->
            # Check if we have a valid requested page
            if @page?
                # Get the uri path without the forward slash
                @controller = @page.substring( 1 ).split( "/" )[0]

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
            # Check if we have a valid id to put in the uri
            if @id?
                # Return the uri with the id
                return "timekeeper://ui#{@page}#{@id}"
            else
                # Return the uri for the view
                return "timekeeper://ui#{@page}"

        ### GET VIEW ###
        getView: ->
            # Setup the default view to display
            viewToDisplay = null

            # Let us check what kind of view we want to generate
            if @controller?
                # We have a valid controller, so let us create the view
                # based off that
                switch @controller
                    # Handle Dashboard
                    when "dashboard"
                        ### REQUIRES ###
                        DashboardView ?= require "./dashboard.coffee"

                        # Create the dashboard view
                        viewToDisplay = new DashboardView()
                    # Handle Project Settings
                    when "project-settings"
                        ### REQUIRES ###
                        ProjectSettingsView ?= require "./project-settings.coffee"

                        # Create the Project Settings view
                        viewToDisplay = new ProjectSettingsView()
                    else
                        ### REQUIRES ###
                        DashboardView ?= require "./dashboard.coffee"

                        # Default to Dashboard if we cannot handle the page requested
                        viewToDisplay = new DashboardView()

            # Return the view
            return viewToDisplay