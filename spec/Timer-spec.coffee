assert      = require 'assert'
chai        = require 'chai'
sinon       = require 'sinon'
sinonChai   = require 'sinon-chai'
expect      = chai.expect

chai.use sinonChai

Timer = require '../lib/Timer'

describe "Timer", ->
    beforeEach ->
        @clock = sinon.useFakeTimers()
        @timer = new Timer()
