### IMPORTS ###
# core
fs = null
path = require "path"

# moment
moment = null

# twix
twix = null

# mkdirp
mkdirp = null

# timekeeper
ClockView = null
StatusView = null

### EXPORTS ###
module.exports =
    class Timer
        ### ATTRIBUTES ###
        storagePath: null
        projectTimekeeperPath: null
        currentProject: null
        clockView: null
        statusView: null

        ### CONSTRUCTOR ###
        constructor: ( state, timeDataPath ) ->
            # Setup the current project
            @currentProject = atom.project.getPath()

            # Setup some paths
            @storagePath = timeDataPath || null

            # Call the setStoragePath
            @setStoragePath()

            # Check if we have a state being passed through
            if state
                # Check if we have any time tracking data from the previous state
                if state.timerObject and state.timerObject.start
                    # We have something from previous state, let us save it
                    @save( state.timerObject )

            # We only want to activate the package if there is a valid project
            # Not handling atom being loaded without a project at this point - TODO
            if @currentProject
                # Call the setProjectTimekeeperPath
                @setProjectTimekeeperPath()

                # Keep track of start, pause, & end timestamps (in milliseconds)
                @startTimestamp = null
                @pauseTimestamp = null
                @endTimestamp = null

                # Actual timer
                @clock = 0
                @break = 0

                # Holder for all pauses/breaks
                @pauses = []
            else
                # Throw an error for the benefit of package manager activePackage
                throw { stack: "- Timekeeper is active & functional only with a valid project open" }

        ### ACTIONS ###
        ### START ###
        start: ->
            # Check if we are coming out of a pause
            if @pauseTimestamp is null
                # Start the time tracking at this point only if we aren't already tracking
                if @startTimestamp is null
                    # Setup the start date time only if we are not in paused state
                    # otherwise start date time will keep changing which is wrong
                    @startTimestamp = Date.now()

                    # Initialize the time incrementer
                    @incrementer = setInterval ( => @step() ), 1000

                    # Display status
                    @statusView.update( "Started time tracking ..." )
                else
                    # We are already tracking time, nothing to do here
                    @statusView.update( "Already tracking time ..." )
            else
                # Display continuing status
                @statusView.update( "Continuing time tracking ..." )

                # Add the pause/break data to our holder
                @pauses.push { start: @pauseTimestamp, duration: @break }

                # Reset the pause stuff now
                @pauseTimestamp = null
                @break = 0

                # Remove the class from the clock view
                @clockView.removeClass( "paused" )

            # Update the clock view
            @clockView.update( @format() )

            # Clearer for the status message
            @statusClearer = setInterval ( => @clearStatus() ), 3000

        ### PAUSE ###
        pause: ->
            # Check if we are already in paused state, in which case un-pause
            if @pauseTimestamp isnt null
                # Just call the start method and it will handle stuff
                @start()
            else
                # Set the pause so that we don't increment clock at this point
                @pauseTimestamp = Date.now()

                # Setup the status
                @statusView.update( "Time tracking paused!" )

                # Add a paused class to the clock for visual changes
                @clockView.addClass( "paused" )

        ### FINISH ###
        finish: ->
            # Setup the end timestamp (in milliseconds)
            @endTimestamp = Date.now()

            # Clear the clock incrementer
            clearTimeout @incrementer

            # Check if we are in pause when we finish
            if @pauseTimestamp isnt null
                # We need to add the pause to the pauses data object
                @pauses.push { start: @pauseTimestamp, duration: @break }

                # Remove the class from the clock view
                @clockView.removeClass( "paused" )

            # Save the time tracking data at this point
            @save()

            # Setup the status
            @statusView.update( "Saved timekeeper data!" )

            # Clearer for the status message
            @statusClearer = setInterval ( => @clearStatus() ), 3000

            # Reset the timers
            @resetClocks()

            # Update the clock now
            @clockView.update( @format() )

        ### RESET ###
        reset: ->
            # Clear the clock counter
            clearTimeout @incrementer

            # Check if we are in pause
            if @pauseTimestamp isnt null
                # Remove the paused class
                @clockView.removeClass( "paused" )

            # Reset the clocks
            @resetClocks()

            # Start over again
            @start()

        ### ABORT ###
        abort: ->
            # Clear the clock incrementer
            clearTimeout @incrementer

            # Check if we are in pause
            if @pauseTimestamp isnt null
                # Remove the paused class
                @clockView.removeClass( "paused" )

            # Reset internal stuff
            @resetClocks()

            # Update the clock view
            @clockView.update( @format() )

            # Setup the final status
            @statusView.update( "Discarded current timekeeper data!" )

            # Clearer for the status message
            @statusClearer = setInterval ( => @clearStatus() ), 3000

        ### INTERNAL ACTIONS ###
        ### STEP ###
        step: ->
            # Check if we are in pause mode, only increment clock if we are not in pause
            if @pauseTimestamp is null
                # Increment the clock value
                @clock = @clock + 1

                # Update the clock view
                @clockView.update( @format() )
            else
                # Just increment the break clock
                @break = @break + 1

        ### RESET CLOCKS ###
        resetClocks: ->
            # Reset start, pause & end timestamps
            @startTimestamp = null
            @pauseTimestamp = null
            @endTimestamp = null

            # Reset the actual clocks
            @clock = 0
            @break = 0

            # Reset the pauses data structure to empty list
            @pauses = []

        ### PERSIST ###
        ### SAVE ###
        save: ( timerObject ) ->
            ### REQUIRE ###
            # Require modules only if absolutely needed
            # core
            fs ?= require "fs"

            # mkdir
            mkdirp ?= require "mkdirp"

            # Let us save the time tracking data at this point
            # Check if we have a timerObject passed to use for the save
            if timerObject
                # Set the project from the timer object passed
                timerProject = timerObject.project

                # Set the values from the timer data object in this case
                startValue = timerObject.start
                endValue = timerObject.end
                clockValue = timerObject.duration
                pausesValue = timerObject.pauses
            else
                # Set the project as the current project in this case
                timerProject = @currentProject

                # Set the values from current instance values
                startValue = @startTimestamp
                endValue = @endTimestamp
                clockValue = @clock
                pausesValue = @pauses

            # Create the time data to be stored
            dataToSave = {
                "start": startValue
                "end": endValue
                "duration": clockValue
                "pauses": pausesValue
            }

            # Get the file save paths where this data needs to be saved
            saveFilePaths = @getPath( timerProject, startValue, endValue, clockValue, pausesValue )

            # Make sure we have some file path returned, should be always at least one
            if saveFilePaths.length > 0
                # Loop through each of the file paths we have
                for saveFilePath in saveFilePaths
                    # Check if the specific file already exists
                    saveFileExists = fs.existsSync saveFilePath

                    # If it exists, we want to get the data object in it
                    if saveFileExists
                        # We already have some data, so let us try load that up first
                        existingContent = fs.readFileSync saveFilePath, { encoding: "utf8" }

                        # Parse in to time tracking object
                        finalDataToSave = JSON.parse( existingContent )
                    else
                        # We don't have the file, so maybe we need to create the path to it first?
                        # Check if the file directory exists, if not create it
                        saveFileDirectoryPath = path.dirname( saveFilePath )

                        # Check if it exists
                        saveFileDirectoryExists = fs.existsSync saveFileDirectoryPath

                        # If it doesn't exist, create it using mkdirp
                        if not saveFileDirectoryExists
                            # Create the directory tree at this point
                            mkdirp.sync( saveFileDirectoryPath )

                        # We have no data from before, so create a new data object
                        finalDataToSave = []

                    # Append the current data to the time tracking data
                    finalDataToSave.push dataToSave

                    # Create the final time tracking data to write back to file
                    updatedContent = JSON.stringify( finalDataToSave, null, 4 )

                    # Write to the file
                    fs.writeFileSync saveFilePath, updatedContent, { encoding: "utf8" }

        ### PATHS ###
        ### GET PATH ###
        getPath: ( project, start, end, duration, pauses ) ->
            ### REQUIRE ###
            moment ?= require "moment"
            twix ?= require "twix"

            # Setup the file path array
            dataFilePaths = []

            # Check if we have a valid end, since storing from state will not have it
            if end is null
                # We need to set it up based on the durations we have in the data
                # First add the duration to start and set it as end
                end = start + ( duration * 1000 )

                # Check if we have any pauses
                if pauses.length > 0
                    # Loop through all the pauses and add them to the end timestamp
                    for pause in pauses
                        # Add the duration of the pause to the end value
                        end = end + ( pause.duration * 1000 )

            # Setup the date objects to determine file path(s)
            startDateObject = moment( start )
            endDateObject = moment( end )

            # Dates/days in between start and end
            dateRange = startDateObject.twix( endDateObject, { allDay: true } )
            dateRangeIterator = dateRange.iterate( "days" )

            # Check if we have only the same date, in which case there will be no range
            if dateRange.count( "days" ) <= 1
                # Create the path to the timekeep file for this date
                dateFilePath = path.join(
                                @getStoragePath(),
                                new Buffer( project, "utf8" ).toString( "base64" ),
                                endDateObject.year().toString(),
                                ( endDateObject.month() + 1 ).toString(),
                                endDateObject.date().toString() + ".json"
                )

                # Append the date to the file paths array
                dataFilePaths.push dateFilePath
            else
                # Loop over the date range and build the array of file paths
                while dateRangeIterator.hasNext()
                    # Setup the date in range
                    dateInRange = dateRangeIterator.next()

                    # Create the path to the timekeep file for this date
                    dateFilePath = path.join(
                                    @getStoragePath(),
                                    new Buffer( project, "utf8" ).toString( "base64" ),
                                    dateInRange.year().toString(),
                                    ( dateInRange.month() + 1 ).toString(),
                                    dateInRange.date().toString() + ".json"
                    )

                    # Append the date to the file paths array
                    dataFilePaths.push dateFilePath

            # Return the path array
            return dataFilePaths

        ### SET PATH ###

        ### GET PROJECT TIMEKEEPER PATH ###
        getProjectTimekeeperPath: ->
            # Return the current project timekeeper path
            return @projectTimekeeperPath

        ### SET PROJECT TIMEKEEPER PATH ###
        setProjectTimekeeperPath: ->
            # Create the full path to the project timekeeper folder
            @projectTimekeeperPath = path.join(
                                        @getStoragePath(),
                                        new Buffer( @currentProject, "utf8" ).toString( "base64" )
            )

        ### GET STORAGE PATH ###
        getStoragePath: ->
            # Return the current time data storage path
            return @storagePath

        ### SET STORAGE PATH ###
        setStoragePath: ->
            # Check if we have a valid path provided
            if not @storagePath
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
        ### STATUS BAR VIEWS ###
        renderStatusBarViews: ->
            ### REQUIRE ###
            # timekeeper
            ClockView ?= require "./views/clock.coffee"
            StatusView ?= require "./views/status.coffee"

            # Create the status bar views
            @clockView ?= new ClockView()
            @statusView ?= new StatusView()

            # Attach the clock first
            @clockView.attach()

            # Attach the status
            @statusView.attach()

        ### CLEAR STATUS ###
        clearStatus: ->
            # Remove the status clearer as well now
            clearTimeout @statusClearer

            # Only clear the status if we are not in pause mode
            if @pauseTimestamp is null
                # Clear the status
                @statusView.clear()