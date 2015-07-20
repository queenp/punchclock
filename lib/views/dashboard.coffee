### IMPORTS ###
# atom
{$, View} = require 'atom-space-pen-views'

# punchclock
Reporter = require "../reporter.coffee"

### EXPORTS ###
module.exports =
    class DashboardView extends View
        ### ATTRIBUTES ###
        reporter: null

        ### CONTENT ###
        @content: ->
            # Setup the container
            @div id: "dashboard", class: "wrapper", =>
                # Message
                @div outlet: "message", class: "message", ""

        ### CONSTRUCTOR ###
        constructor: ->
            # Setup a reporter object that we can use
            @reporter = new Reporter()

            # Call the super
            super

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
                # Display Recent Projects
                @recentProjects( currentProjects )

        ### BLOCKS ###
        ### RECENT PROJECTS ###
        recentProjects: ( currentProjects ) ->
            # We have some project so create the recent project container
            recentProjectsContainer = $( "<div></div>", { class: "recent-projects" } )

            # Setup the header
            recentProjectsHeader = $( "<div></div>", { class: "header" } )
            headerTitle = $( "<h4>Recent Projects</h4>" )

            # Append the header to the container
            recentProjectsHeader.append( headerTitle )
            recentProjectsContainer.append( recentProjectsHeader )

            # Create the collection container
            recentProjectsList = $( "<div></div>", { class: "collection" } )

            # Loop through the current projects
            for currentProject in currentProjects
                # Create a new list element for the project
                projectElement = $( "<div></div>", { class: "item project" } )

                # Create the elements for the data pieces
                # Label
                projectLabel = $( "<h6></h6>", { class: "title", text: currentProject.label } )

                # Path
                projectPath = $( "<span></span>", { class: "subtitle", text: currentProject.path } )

                # Duration
                projectDuration = $( "<div></div>" , { text: currentProject.duration } )

                # Append the data we need
                projectElement.append( projectLabel )
                projectElement.append( projectPath )
                projectElement.append( projectDuration )

                # Add to the summary projects list
                recentProjectsList.append( projectElement )

            # Append the collection to the container
            recentProjectsContainer.append( recentProjectsList )

            # Append to the dashboard
            this.append( recentProjectsContainer )
