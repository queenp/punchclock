### IMPORTS ###

# punchclock
Timer = require '../lib/timer.coffee'

describe "Punchclock Status Bar", ->
  describe "When punchclock is loaded", ->
    it "shows a clock in the status bar", ->
      pending()
    describe "When timer is started", ->
      it "shows an updated clock", ->
        pending()

describe "Punchclock Dashboard Views", ->
    describe "When Dashboard is opened", ->
      it "shows a data summary", ->
        pending()
        expect(dashboardSummary).toBeVisible()
      it "displays a list of recent projects", ->
        pending()
        expect(recentProjects).toBeVisible()
