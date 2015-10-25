StatusView = require '../lib/views/StatusView'

describe "StatusView", ->
    [editor, statusBar, statusBarService, workspaceElement] = []

    beforeEach ->
        workspaceElement = atom.views.getView(atom.workspace)

        waitsForPromise ->
            atom.packages.activatePackage('status-bar').then (pack) ->
                statusBar = workspaceElement.querySelector("status-bar")
                statusBarService = pack.mainModule.provideStatusBar()

    it "should have a clock", ->
        expect(new StatusView().clock).not.toBe.null

    it "should throw an error if no statusbar", ->
        expect(new StatusView().attach).toThrow("Error: No Status Bar")

    it "should have a statusBarTile", ->
        statusView = new StatusView()
        statusView.attach(statusBar)
        expect(statusView.statusBarTile).toBeDefined()

    it "should be updateable", ->
        status = "Some Status"
        view = new StatusView()
        view.update(status)
        expect(view.status).toEqual(status)

    it "can be cleared", =>
        view = new StatusView('test')
        view.clear()
        expect(view.status).toEqual("")
