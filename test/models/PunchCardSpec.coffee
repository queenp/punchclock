assert      = require 'assert'
chai        = require 'chai'
sinon       = require 'sinon'
sinonChai       = require 'sinon-chai'
expect      = chai.expect
chai.use sinonChai

Pause = require '../../lib/models/Pause.js'
moment = require 'moment'

PunchCard = require '../../lib/models/PunchCard.js'

mockCardWithPauses = new PunchCard({
    label: "jeje",
    pauses: [
        new Pause(start:moment(1),end:moment(52))
    ],
    autoPauses: [
        new Pause(start:moment(83),end:moment(100))
    ],
    start:0,
    end:150
    })

describe "PunchCard", ->
    before ->
        @card = new PunchCard({label:"MyProject"})

    it "has a duration", ->
        x = @card.duration()
        expect(@card.duration()).to.not.be.null;

    before ->
        @card = mockCardWithPauses
