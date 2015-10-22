### IMPORTS ###

# timekeeper
Timer = require "../lib/timer.coffee"

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Punchclock Views", ->
    ### ATTRIBUTES ###
    activationPromise = null
    timer = null
    workspaceElement = null

    ### SETUP ###
    beforeEach ->
        # Create the workspace to be used
        workspaceElement = atom.views.getView(atom.workspace)

        # Setup the activation for the package
        activationPromise = atom.packages.activatePackage( "punchclock" )

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

        waitsForPromise ->
          activationPromise

    ### TEARDOWN ###
    afterEach ->
        # Reset everything after each test
        @timer.resetClocks()

    ### PUNCHCLOCK CLOCK ###
    describe "Status Bar Punchclock Clock", ->
        ### TEST ###
        # On loading, we should have a punchclock clock in the status bar
        it "renders a clock in the status bar on load", ->
            # Wait for package to be activated and functional
            # waitsForPromise =>
            #     # Waits for the activation
            #     activationPromise

            # Verify that there is one new editor that opened the notepad
            runs =>
                # We should have the timer container element somewhere in the workspace view
                expect( workspaceElement.querySelector( ".punchclock .timer" ) ).toExist()

                # Timer view should have been rendered with 0 on the clock
                expect( workspaceElement.querySelector( ".punchclock .timer #clock" ).innerHTML ).toEqual( "00:00:00" )

    ### PUNCHCLOCK STATUS ###
    describe "Status Bar Punchclock Status", ->
        ### TEST ###
        # On loading, we should have a punchclock status in the status bar
        it "renders a status in the status bar on load", ->
            # Wait for package to be activated and functional
            # waitsForPromise =>
            #     # Waits for the activation
            #     activationPromise

            # Verify that there is one new editor that opened the notepad
            runs =>
                # We should have the timer container element somewhere in the workspace view
                expect( workspaceElement.querySelector( ".punchclock .timer" ) ).toExist()

                # Timer view should have been rendered with nothing in status
                expect( workspaceElement.querySelector( ".punchclock .timer #status" ).innerHTML ).toEqual( "" )

    ### DASHBOARD ###
    describe "Punchclock Dashboard", ->
        ### TEST ###
        # Triggering punchclock dashboard should open new pane with punchclock dashboard ui
        it "displays punchclock dashboard UI in a new pane", ->
            # There should be only one pane at this point
            expect( atom.workspace.getPanes().length ).toEqual( 1 )

            # Wait for package to be activated and functional
            # waitsForPromise =>
            #     # Waits for the activation
            #     activationPromise

            # Verify that a new pane with the punchclock dashboard opened
            runs =>
                # Trigger and wait for the punchclock view to be rendered
                waitsFor =>
                    # Open the punchclock dashboard now
                    atom.commands.dispatch workspaceElement, "punchclock:dashboard"

                # Wait a bit for the view to be rendered
                waits( 2000 )

                # Verify that we are all good now
                runs =>
                    # There should be two panes at this point
                    expect( atom.workspace.getPanes().length ).toEqual( 2 )

                    # We should have the ui-page container in the new pane
                    expect( workspaceElement.querySelector( ".punchclock .ui-page #dashboard" ) ).toExist()
