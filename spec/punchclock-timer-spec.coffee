describe "Punchclock Timer", ->
  run_command = (cmdstring) ->
    # Helper to dispatch atomistic commands to test framework
    workspaceView = atom.views.getView(atom.workspace)
    return atom.commands.dispatch(workspaceView, "punchclock:" + cmdstring);

  it "has a timer", ->
    expect(timer).toExist()

  it "is stopped unless autostart is enabled", ->
    expect(false).toBe(true)

  it "starts counting if autostart is enabled", ->
    expect(false).toBe(true)

  describe "When the timer has been started", ->

    it "counts the seconds since it was started", ->
      expect().toBe(true)

    it "can be paused", ->
      pausable = run_command("punchclock:pause")
      expect(pausable).toBe(true)

    describe "When the timer is paused", ->

      it "stops counting", ->
        expect(paused).toBe(true)

      it "can be paused again to resume counting", ->
        resumed = run_command("pause")
        expect(resumed).toBe(true)

      it "can be reset", ->
        reset = run_command("reset")
        expect(reset).toBe(true)

      it "can be finished", ->
        finished = run_command("finish")
        expect(finished).toBe(true)

    it "can be saved", ->
      saved = run_command("save")
      expect(saved).toBe(true)

    it "tracks open files", ->
      expect(openfiles).toBeTracked()

    it "tracks new files", ->
      expect(openfiles).toBeTracked()

    it "saves logs for saved files when it finishes", ->
      expect(savedfiles).toBeLogged()
