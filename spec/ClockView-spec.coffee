ClockView = require '../lib/views/ClockView.js'

describe "ClockView", ->

    it 'Should default to zeros', =>
        clock = new ClockView()
        expect(clock.time).toEqual('00:00:00')

    it 'Should update when called to', =>
        clock = new ClockView()
        timestring = '18:21:32'
        Promise.resolve(clock.update(timestring))
        expect(clock.time).toEqual(timestring)

    # it 'Should detach when destroyed', =>
    #     @clock.detach = => return true
    #     expect(@clock.destroy()).to.be.true
