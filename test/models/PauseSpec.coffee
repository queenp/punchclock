assert      = require 'assert'
chai        = require 'chai'
sinon       = require 'sinon'
sinonChai       = require 'sinon-chai'
expect      = chai.expect
chai.use sinonChai

Pause = require '../../lib/models/Pause.js'
moment = require 'moment'

describe "Pause", ->

    beforeEach ->
        @clock = sinon.useFakeTimers();
        @pause = new Pause();

    afterEach ->
        @clock.restore()

    describe "Object lifecycle", ->
        it "starts by default at current time", ->
            expect(@pause.start.unix).to.equal(moment().unix)
            expect(moment.isMoment(@pause.start)).to.be.true;

        it "counts its duration", ->
            @clock.tick(500)
            expect(@pause.duration().asSeconds()).to.equal(0.5)

        it "can be finished", ->
            @clock.tick(5000)
            @pause.finish()
            @clock.tick(5000)
            expect(@pause.duration().asSeconds()).to.equal(5)

        it "can produce an object", ->
            @clock.tick(5000)
            @pause.finish()
            obj = @pause.to_object()
            expect(obj).to.exist
            expect(obj.start).to.equal(0)
            expect(obj.end).to.equal(5)
