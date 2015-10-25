sinon       = require 'sinon'
Pause = require '../../lib/models/Pause.js'
moment = require 'moment'

describe "Pause", ->

    beforeEach ->
        @pause = new Pause();
        @clock = sinon.useFakeTimers();
        timerCallback = jasmine.createSpy "timerCallback"

    afterEach ->
        @clock.restore()

    describe "Object lifecycle", ->
        it "starts by default at current time", ->
            expect(@pause.start).toBe.undefined
            expect(@pause.duration.asSeconds()).toEqual(0)
            @pause.start = Date.now()
            expect(moment.isMoment(@pause.start)).toBe.true;

        it "counts its duration", ->
            @pause.start = Date.now()
            @clock.tick(1000)
            expect(@pause.duration.asSeconds()).toEqual(1)

        it "cannot be written to after ended", ->
            @pause.start = Date.now()
            @clock.tick(5000)
            @pause.end = Date.now()
            @clock.tick(5000)
            @pause.end = Date.now()
            expect(@pause.duration.asSeconds()).toEqual(5)

        it "can produce an object representation", ->
            @pause.start = Date.now()
            some_random_time = 5000 * Math.random()
            @clock.tick(some_random_time)
            @pause.end = Date.now()
            obj = @pause.object
            expect(obj).toBeDefined()
            expect(obj.start).toEqual(0)
            expect(obj.end).toEqual(Math.floor(some_random_time))

        it "can be initialised with start/end values", ->
            mock = new Pause({start:1000, end:25432});
            expect(mock.start.unix()).toEqual(1)
            expect(mock.duration.asMilliseconds()).toEqual(+mock.end - mock.start)  # abusing casting by valueOf
