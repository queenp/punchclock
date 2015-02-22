### IMPORTS ###
# core
fs = require "fs"
recursive = require "recursive-readdir"
path = require "path"

# moment
moment = null

# twix
twix = null

### EXPORTS ###
module.exports =
    class Reporter
        ### ATTRIBUTES ###
        storagePath: null

        ### CONSTRUCTOR ###
        constructor: ->
            # Setup the storage path
            @setStoragePath()

        ### ACTIONS ###

        ### DATA ###
        ### GET CURRENT PROJECTS ###
        getProjects: ->
            # Setup the return projects list object
            currentProjects = []

            # Get the current projects we are tracking time for
            projectFolders = fs.readdirSync( @storagePath )

            recursiveReaddir = (path) ->
              stat = fs.lstatSync(path);
              if stat.isFile()
                return [path]
              if !stat.isDirectory()
                return [];
              [].concat.apply [], fs.readdirSync(path).map((fname) ->
                recursiveReaddir path + '/' + fname
              )

            # Loop through the projects, and reformat some data for easy usage
            for projectFolder in projectFolders
                # Setup the project data object
                projectData = {}

                # Decode the project path string
                projectPath = new Buffer( projectFolder, "base64" ).toString( "utf8" )
                # Set the label & path for the project
                projectData["label"] = path.basename( projectPath )
                projectData["path"] = projectPath
                duration = 0
                files = recursiveReaddir path.join(@storagePath, projectFolder)
                for file in files
                  jsondata = JSON.parse(fs.readFileSync(file))
                  for obj in jsondata
                    duration += obj.duration
                timestring = "#{Math.floor duration/3600}:" + "0#{(Math.floor(duration/60))%60}".slice(-2) + ":" + "0#{(duration%60)}".slice(-2)
                projectData["duration"] = timestring
                # Add the to current projects list
                currentProjects.push projectData

            # Return the current projects
            return currentProjects

        ### PATHS ###
        ### GET STORAGE PATH ###
        getStoragePath: ->
            # Return the current time data storage path
            return @storagePath

        ### SET STORAGE PATH ###
        setStoragePath: ->
            # No path was provided, so let us build the default
            @storagePath = "#{atom.getConfigDirPath()}/.timekeeper"

        ### FORMATTING ###
        ### FORMAT ###
        format: ->
            # Check if we have only seconds at this point
            if @clock <= 59
                # Return back the formatted value with just seconds
                formattedValue = "00:00:#{@zeropad( @clock )}"
            else
                # Set the clock value
                clockValue = @clock

                # Get the seconds
                seconds = Math.floor( clockValue % 60 )

                # Re-calculate the clockValue
                clockValue = ( clockValue / 60 )

                # Get the minutes
                minutes = Math.floor( clockValue % 60 )

                # Re-calculate the timerValue
                clockValue = ( clockValue / 60 )

                # Get the hours
                hours = Math.floor( clockValue % 24 )

                # Return the formatted timer value
                formattedValue = "#{@zeropad( hours )}:#{@zeropad( minutes )}:#{@zeropad( seconds )}"

            # Return
            return formattedValue

        ### ZEROPAD ###
        zeropad: ( value ) ->
            # Setup the zero padded string value
            paddedValue = ( "0" + value ).slice( -2 )

            # Return the zero padded value
            return paddedValue

        ### VIEWS ###
