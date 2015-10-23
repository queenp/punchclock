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
            expect(@pause.start.unix()).to.equal(moment().unix())
            expect(moment.isMoment(@pause.start)).to.be.true;

        it "has a duration", ->
            @clock.tick(40)
            expect(@pause.elapsed()).to.equal(40)

        it "can be finished", ->
            @clock.tick(5000)
            @pause.finish()
            @clock.tick(5000)
            expect(@pause.elapsed()).to.equal(5000)
