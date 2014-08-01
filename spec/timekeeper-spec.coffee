### IMPORTS ###
# core
path = require "path"
fs = require "fs"

# atom
{$, Workspace, WorkspaceView} = require "atom"

# timekeeper
Timer = require "../lib/timer.coffee"

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Timekeeper", ->
    ### ATTRIBUTES ###
    activationPromise = null
    timer = null

    ### SETUP ###
    beforeEach ->
        # Create the workspace to be used
        atom.workspaceView = new WorkspaceView

        # Setup the activation for the package
        activationPromise = atom.packages.activatePackage( "timekeeper" )

        # Setup the current datetime object
        currentDate = new Date()

        # Setup the file path that will save time data for this spec run
        saveFilePath = path.join(
                            "#{atom.getConfigDirPath()}/.timekeeper",
                            new Buffer( atom.project.getPath(), "utf8" ).toString( "base64" ),
                            currentDate.getFullYear().toString(),
                            ( currentDate.getMonth() + 1 ).toString(),
                            currentDate.getDate() + ".json"
                        )

        # Check if we have a file from any previous runs, if yes, let us remove it
        if fs.existsSync( saveFilePath )
            # Remove the file, we don't want old data
            fs.unlinkSync( saveFilePath )

        # Create the notepads object
        @timer = new Timer()

        # Attach to status bar
        @timer.renderStatusBarViews()

    ### TEARDOWN ###
    afterEach ->
        # Reset everything after each test
        @timer.resetClocks()

    ### TIMEKEEPER DEFAULTS ###
    describe "Timekeeper Load Defaults", ->
        ### TEST ###
        # On loading, we should have all time keeper values to defaults
        it "has defaults on initial load", ->
            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Verify timekeeper defaults
            runs =>
                # Start, Pause, End Timestamps should be null
                expect( @timer.startTimestamp ).toBeNull()
                expect( @timer.pauseTimestamp ).toBeNull()
                expect( @timer.endTimestamp ).toBeNull()

                # Clock & Break timers should be 0
                expect( @timer.clock ).toEqual( 0 )
                expect( @timer.break ).toEqual( 0 )

                # Pauses data should be empty
                expect( @timer.pauses.length ).toEqual( 0 )

    ### TIMEKEEPER START ###
    describe "Timekeeper Start", ->
        ### TEST ###
        # Test that timerkeeper tracks time spent on calling start
        it "starts tracking time on issuing start", ->
            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Verify that timekeeper tracks time on issuing start
            runs =>
                # Start & Clock should be default
                expect( @timer.startTimestamp ).toBeNull()
                expect( @timer.clock ).toEqual( 0 )

                # Issue the start command to timekeeper
                waitsFor =>
                    # Call timer start
                    @timer.start()

                # Wait for the time to pass
                waits( 2000 )

                # Verify the time tracking
                runs =>
                    # Start & Clock should have increased
                    expect( @timer.startTimestamp ).not.toBeNull()
                    expect( @timer.clock ).toBeGreaterThan( 0 )

                    # Timer clock view should not be zero anymore
                    expect( atom.workspaceView.find( "#clock" ).html() ).not.toEqual( "00:00:00" )

    ### TIMEKEEPER PAUSE ###
    describe "Timekeeper Pause", ->
        ### TEST ###
        # Test that timerkeeper pauses time tracking on calling start
        it "pauses tracking time on issuing pause", ->
            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Verify that timekeeper tracks time on issuing start
            runs =>
                # Issue the start to start time tracking
                waitsFor =>
                    # Call timer start
                    @timer.start()

                # Wait for the time to pass
                waits( 2000 )

                # Verify the time tracking
                runs =>
                    # Start & Clock should have increased
                    expect( @timer.startTimestamp ).not.toBeNull()
                    expect( @timer.clock ).toBeGreaterThan( 0 )

                    # Now let us issue a pause
                    waitsFor =>
                        # Call timer pause
                        @timer.pause()

                    # Wait a bit so that break clock increments
                    waits( 2000 )

                    # Check that the time tracking has paused
                    runs =>
                        # Pause time stamp should not be null anymore
                        expect( @timer.pauseTimestamp ).not.toBeNull()

                        # Clock should still be at 2 seconds
                        expect( @timer.clock ).toEqual( 2 )

                        # Timer clock view should also show 2 seconds
                        expect( atom.workspaceView.find( "#clock" ).html() ).toEqual( "00:00:02" )

                        # Break should not be 0 anymore
                        expect( @timer.break ).toBeGreaterThan( 0 )

                        # Timer status view should have pause message
                        expect( atom.workspaceView.find( "#status" ).html() ).toEqual( "Time tracking paused!" )

    ### TIMEKEEPER PAUSE - START ###
    describe "Timekeeper Pause - Start", ->
        ### TEST ###
        # Test timerkeeper restarts from where it left off when start is called from paused mode
        it "restarts time tracking when start() is called while in paused mode", ->
            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Start time tracking at this point
            runs =>
                # Issue the start to start time tracking
                waitsFor =>
                    # Call timer start
                    @timer.start()

                # Wait for the time to pass
                waits( 2000 )

                # Verify that time tracking is running
                runs =>
                    # Get the current values
                    @timer.previousStartTimestamp = @timer.startTimestamp

                    # Now let us issue a pause
                    waitsFor =>
                        # Call timer pause
                        @timer.pause()

                    # Wait a bit so that break clock increments
                    waits( 2000 )

                    # We are in paused mode now, so we should be able to continue by issuing a start
                    runs =>
                        # Restart time tracking by issuing start
                        waitsFor =>
                            # Call timer start
                            @timer.start()

                        # Wait for a bit to time pass
                        waits( 3000 )

                        # Verify that time tracking is continuing
                        runs =>
                            # Pause time stamp should have gone back to being null
                            expect( @timer.pauseTimestamp ).toBeNull()
                            expect( @timer.break ).toEqual( 0 )

                            # We should have a paused data object in pauses
                            expect( @timer.pauses.length ).toEqual( 1 )

                            # Clock should be more than the 2 seconds it was
                            expect( @timer.clock ).toBeGreaterThan( 2 )

                            # The start timestamp should be the same as it was before
                            expect( @timer.startTimestamp ).toEqual( @timer.previousStartTimestamp )

                            # Timer status view should have nothing anymore, status clears after 3s
                            expect( atom.workspaceView.find( "#status" ).html() ).toEqual( "" )

    ### TIMEKEEPER PAUSE - PAUSE ###
    describe "Timekeeper Pause - Pause", ->
        ### TEST ###
        # Test timerkeeper restarts from where it left off when pause is called from paused mode
        it "restarts time tracking when pause() is called while in paused mode", ->
            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Start time tracking at this point
            runs =>
                # Issue the start to start time tracking
                waitsFor =>
                    # Call timer start
                    @timer.start()

                # Wait for the time to pass
                waits( 2000 )

                # Verify that time tracking is running
                runs =>
                    # Get the current values
                    @timer.previousStartTimestamp = @timer.startTimestamp

                    # Now let us issue a pause
                    waitsFor =>
                        # Call timer pause
                        @timer.pause()

                    # Wait a bit so that break clock increments
                    waits( 2000 )

                    # We are in paused mode now, so we should be able to continue by issuing pause
                    runs =>
                        # Restart time tracking by issuing pause
                        waitsFor =>
                            # Call timer pause
                            @timer.pause()

                        # Wait for a bit to time pass
                        waits( 3000 )

                        # Verify that time tracking is continuing
                        runs =>
                            # Pause time stamp should have gone back to being null
                            expect( @timer.pauseTimestamp ).toBeNull()
                            expect( @timer.break ).toEqual( 0 )

                            # We should have a paused data object in pauses
                            expect( @timer.pauses.length ).toEqual( 1 )

                            # Clock should be more than the 2 seconds it was
                            expect( @timer.clock ).toBeGreaterThan( 2 )

                            # The start timestamp should be the same as it was before
                            expect( @timer.startTimestamp ).toEqual( @timer.previousStartTimestamp )

                            # Timer status view should have nothing anymore, status clears after 3s
                            expect( atom.workspaceView.find( "#status" ).html() ).toEqual( "" )

    ### TIMEKEEPER RESET ###
    describe "Timekeeper Reset", ->
        ### TEST ###
        # Test timerkeeper resets & starts fresh on calling reset()
        it "resets time tracking data and starts fresh on calling reset()", ->
            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Start time tracking at this point
            runs =>
                # Issue the start to start time tracking
                waitsFor =>
                    # Call timer start
                    @timer.start()

                # Wait for the time to pass
                waits( 5000 )

                # Verify that time tracking is running
                runs =>
                    # Get the current values
                    @timer.previousStartTimestamp = @timer.startTimestamp
                    @timer.previousClock = @timer.clock

                    # Now let us issue a reset
                    waitsFor =>
                        # Call timer reset
                        @timer.reset()

                    # Wait a bit so that restarts and has further time increment
                    waits( 1000 )

                    # We have started fresh again now, so values should be less than previous
                    runs =>
                        # Clock should be less than it was before
                        expect( @timer.clock ).toBeLessThan( @timer.previousClock )

                        # The start timestamp should be greater since we restarted later in time
                        expect( @timer.startTimestamp ).toBeGreaterThan( @timer.previousStartTimestamp )

    ### TIMEKEEPER ABORT ###
    describe "Timekeeper Abort", ->
        ### TEST ###
        # Test timerkeeper abort & resets everything on calling abort()
        it "discards all time tracking data on calling abort() & stops tracking time", ->
            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Start time tracking at this point
            runs =>
                # Issue the start to start time tracking
                waitsFor =>
                    # Call timer start
                    @timer.start()

                # Wait for the time to pass
                waits( 4000 )

                # Verify that time tracking is running
                runs =>
                    # Start timestamp and click should not be defaults
                    expect( @timer.startTimestamp ).not.toBeNull()
                    expect( @timer.clock ).toBeGreaterThan( 2 )

                    # Now let us issue an abort
                    #waitsFor =>
                    # Call timer abort
                    @timer.abort()

                    # We have effectively stopped time tracking so nothing should be going on now
                    runs =>
                        # Clock should be back to 0 & start timestamp should be null
                        expect( @timer.startTimestamp ).toBeNull()
                        expect( @timer.clock ).toEqual( 0 )

                        # Timer clock view should also be back to default
                        expect( atom.workspaceView.find( "#clock" ).html() ).toEqual( "00:00:00" )

    ### TIMEKEEPER FINISH ###
    describe "Timekeeper Finish", ->
        ### TEST ###
        # Test timerkeeper saves time tracking data on calling start
        it "saves tracked time data on calling finish()", ->
            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Start time tracking at this point
            runs =>
                # Issue the start to start time tracking
                waitsFor =>
                    # Call timer start
                    @timer.start()

                # Wait for the time to pass
                waits( 1000 )

                # Verify that time tracking is running
                runs =>
                    # Get the timer data to compare with saved data
                    @timer.previousStartTimestamp = @timer.startTimestamp

                    # Now let us finish up
                    #waitsFor =>
                    # Call timer finish
                    @timer.finish()

                    # We have effectively stopped time tracking so nothing should be going on now
                    runs =>
                        # Saved date object
                        savedDateObject = new Date( @timer.previousStartTimestamp )

                        # Setup the file path for us to read in the saved data
                        savedFilePath = path.join(
                                            @timer.getStoragePath(),
                                            new Buffer( @timer.currentProject, "utf8" ).toString( "base64" ),
                                            savedDateObject.getFullYear().toString(),
                                            ( savedDateObject.getMonth() + 1 ).toString(),
                                            savedDateObject.getDate() + ".json"
                                        )

                        # Load up data from the saved time tracking file
                        savedData = fs.readFileSync savedFilePath, { encoding: "utf8" }

                        # Parse in to time tracking object
                        savedJson = JSON.parse( savedData )

                        # We expect data to match what should have been saved from the above
                        expect( savedJson[0].start ).toEqual( @timer.previousStartTimestamp )
                        expect( savedJson[0].end ).not.toBeNull()
                        expect( savedJson[0].end ).toBeGreaterThan( @timer.previousStartTimestamp )

                        # Clock should be back to 0 & start timestamp should be null
                        expect( @timer.startTimestamp ).toBeNull()
                        expect( @timer.endTimestamp ).toBeNull()