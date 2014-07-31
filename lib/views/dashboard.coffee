### IMPORTS ###
# atom
{$, View} = require 'atom'

# timekeeper
Reporter = require "../reporter.coffee"

### EXPORTS ###
module.exports =
    class DashboardView extends View
        ### ATTRIBUTES ###
        reporter: null

        ### CONTENT ###
        @content: ->
            # Setup the container
            @div class: "content", =>
                # Message
                @div outlet: "message", class: "message", ""

                # Summary
                @div class: "summary", =>
                    # List
                    @ul outlet: "summaryProjectsList"

        ### CONSTRUCTOR ###
        constructor: ->
            # Setup a reporter object that we can use
            @reporter = new Reporter()

            # Call the super
            super()

        ### INITIALIZE ###
        initialize: ->
            # Get the projects from the reporter
            currentProjects = @reporter.getProjects()

            # Check if we have any projects to put in the message area
            if currentProjects.length is 0
                # Set the content to no time tracking
                @message.text( "You are currently not tracking time for any projects! :(" )
            else
                # We have some projects, show the message
                @message.text( "You are currently tracking time for #{currentProjects.length} projects" )

            # Add the available projects to the summary list
            if currentProjects.length > 0
                # Loop through the current projects
                for currentProject in currentProjects
                    # Create a new list element for the project
                    projectElement = $( "<li></li>", { class: "project" } )

                    # Create the elements for the data pieces
                    projectLabel = $( "<span>#{currentProject.label}<br />#{currentProject.path}</span>" )

                    # Append the data we need
                    projectElement.append( projectLabel )

                    # Add to the summary projects list
                    @summaryProjectsList.append( projectElement )

        ### SERIALIZE ###
        serialize: ->

        ### DESTROY ###
        destroy: ->