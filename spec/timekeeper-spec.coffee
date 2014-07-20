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

        # Create the notepads object
        @timer = new Timer()

        # Attach to status bar
        @timer.renderStatusBarViews()

    ### TEARDOWN ###
    afterEach ->
        # Reset everything after each test
        @timer.resetClocks()

    ### TIMEKEEPER CLOCK ###
    describe "Status Bar Timekeeper Clock", ->
        ### TEST ###
        # On loading, we should have a timekeeper clock in the status bar
        it "renders a clock in the status bar on load", ->
            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Verify that there is one new editor that opened the notepad
            runs =>
                # We should have the timer container element somewhere in the workspace view
                expect( atom.workspaceView.find( ".timekeeper.timer" ) ).toExist()

                # Timer view should have been rendered with 0 on the clock
                expect( atom.workspaceView.find( "#clock" ).html() ).toEqual( "00:00:00" )

    ### TIMEKEEPER STATUS ###
    describe "Status Bar Timekeeper Status", ->
        ### TEST ###
        # On loading, we should have a timekeeper status in the status bar
        it "renders a status in the status bar on load", ->
            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Verify that there is one new editor that opened the notepad
            runs =>
                # We should have the timer container element somewhere in the workspace view
                expect( atom.workspaceView.find( ".timekeeper.timer" ) ).toExist()

                # Timer view should have been rendered with nothing in status
                expect( atom.workspaceView.find( "#status" ).html() ).toEqual( "" )

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

                    # Get the current values
                    currentClock = @timer.clock

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