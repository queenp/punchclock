### IMPORTS ###
# atom
{$, Workspace, WorkspaceView} = require "atom"

# timekeeper
Timer = require "../lib/timer.coffee"

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Timekeeper Views", ->
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

        # # Setup the file path that will save time data for this spec run
        # saveFilePath = path.join(
        #                     "#{atom.getConfigDirPath()}/.timekeeper",
        #                     new Buffer( atom.project.getPath(), "utf8" ).toString( "base64" ),
        #                     currentDate.getFullYear().toString(),
        #                     ( currentDate.getMonth() + 1 ).toString(),
        #                     currentDate.getDate() + ".json"
        #                 )
        #
        # # Check if we have a file from any previous runs, if yes, let us remove it
        # if fs.existsSync( saveFilePath )
        #     # Remove the file, we don't want old data
        #     fs.unlinkSync( saveFilePath )

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
                expect( atom.workspaceView.find( ".timekeeper .timer" ) ).toExist()

                # Timer view should have been rendered with 0 on the clock
                expect( atom.workspaceView.find( ".timekeeper .timer #clock" ).html() ).toEqual( "00:00:00" )

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
                expect( atom.workspaceView.find( ".timekeeper .timer" ) ).toExist()

                # Timer view should have been rendered with nothing in status
                expect( atom.workspaceView.find( ".timekeeper .timer #status" ).html() ).toEqual( "" )

    ### DASHBOARD ###
    describe "Timekeeper Dashboard", ->
        ### TEST ###
        # Triggering timekeeper dashboard should open new pane with timekeeper dashboard ui
        it "displays timekeeper dashboard UI in a new pane", ->
            # There should be only one pane at this point
            expect( atom.workspace.getPanes().length ).toEqual( 1 )

            # Wait for package to be activated and functional
            waitsForPromise =>
                # Waits for the activation
                activationPromise

            # Verify that a new pane with the timekeeper dashboard opened
            runs =>
                # Trigger and wait for the timekeeper view to be rendered
                waitsFor =>
                    # Open the timekeeper dashboard now
                    atom.workspaceView.trigger "timekeeper:dashboard"

                # Wait a bit for the view to be rendered
                waits( 2000 )

                # Verify that we are all good now
                runs =>
                    # There should be two panes at this point
                    expect( atom.workspace.getPanes().length ).toEqual( 2 )

                    # We should have the ui-page container in the new pane
                    expect( atom.workspaceView.find( ".timekeeper .ui-page #dashboard" ) ).toExist()