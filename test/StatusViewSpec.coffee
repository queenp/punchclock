assert      = require 'assert'
chai        = require 'chai'
expect      = chai.expect

StatusView = require '../lib/views/StatusView'

describe "StatusView", ->
    it "should have a clock", ->
        expect(new StatusView().clock).to.not.be.null

    it "should throw an error if no statusbar", ->
        new
        expect(new StatusView().attach).to.throw("Error: No Status Bar")
        expect(new StatusView().statusBarTile).to.not.be.null

    it "should have a statusBarTile", ->

    it "should be updateable", ->
        status = "Some Status"
        view = new StatusView()
        view.update(status)
        expect(view.status).to.equal(status)

    it "can be cleared", =>
        view = new StatusView('test')
        view.clear()
        expect(view.status).to.equal("")
