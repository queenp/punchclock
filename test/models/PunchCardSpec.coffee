assert      = require 'assert'
chai        = require 'chai'
sinon       = require 'sinon'
sinonChai       = require 'sinon-chai'
expect      = chai.expect
chai.use sinonChai

Pause = require '../../lib/models/Pause.js'
moment = require 'moment'

PunchCard = require '../../lib/models/PunchCard.js'

mockCardWithPauses = =>
    return new PunchCard({
    label: "jeje",
    pauses: [
        new Pause(start:moment(1),end:moment(52))
    ],
    autoPauses: [
        new Pause(start:moment(83),end:moment(100))
    ],
    start:0,
    end:150
    });

describe "PunchCard started from defaults", ->
    [editor, statusBar, statusBarService, workspaceElement] = []

    beforeEach ->
        @clock = sinon.useFakeTimers();
        @card = new PunchCard({label:"MyProject"})

    it "has no this.end value to start with", ->
        expect(@card.end).to.not.exist

    it "has a duration", ->
        @clock.tick(40)
        expect(@card.duration()).to.equal(40)

    it "accounts for pauses in duration", ->
        mock = mockCardWithPauses()
        expect(mock.duration()).to.equal(82)

    afterEach ->
        @clock.restore()
