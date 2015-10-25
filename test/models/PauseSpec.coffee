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
            expect(@pause.start).to.be.undefined
            expect(@pause.duration.asSeconds()).to.equal(0)
            @pause.start = Date.now()
            expect(@pause.start.unix).to.equal(moment().unix)
            expect(moment.isMoment(@pause.start)).to.be.true;

        it "counts its duration", ->
            @pause.start = Date.now()
            @clock.tick(500)
            expect(@pause.duration.asSeconds()).to.equal(0.5)

        it "cannot be written to after ended", ->
            @pause.start = Date.now()
            @clock.tick(5000)
            @pause.end = Date.now()
            @clock.tick(5000)
            @pause.end = Date.now()
            expect(@pause.duration.asSeconds()).to.equal(5)

        it "can produce an object representation", ->
            @pause.start = Date.now()
            some_random_time = 5000 * Math.random()
            @clock.tick(some_random_time)
            @pause.end = Date.now()
            obj = @pause.object
            expect(obj).to.exist
            expect(obj.start).to.equal(0)
            expect(obj.end).to.equal(Math.floor(some_random_time))

        it "can be initialised with start/end values", ->
            mock = new Pause({start:1000, end:25432});
            expect(mock.start.unix()).to.equal(1)
            expect(mock.duration.asMilliseconds()).to.equal(+mock.end - mock.start)  # abusing casting by valueOf
