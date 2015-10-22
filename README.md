Punchclock
==========

Punchclock allows you to track time spent on projects, and provides (or rather will provide) ways to view the data in different ways as well as the ability to export and integrate this data with external endpoints.

##### Default Status Bar View

![Punchclock](https://github.com/queenp/punchclock/raw/master/docs/assets/images/timekeeper-status-bar-view.png)

##### Active & Tracking Time

![Punchclock Active](https://github.com/queenp/punchclock/raw/master/docs/assets/images/timekeeper-status-bar-view-active.png)

##### Paused State

![Punchclock Paused](https://github.com/queenp/punchclock/raw/master/docs/assets/images/timekeeper-status-bar-view-paused.png)

As of 0.6.1, Punchclock  has basic support for loading/unloading projects from Atom. The project is defined by the FIRST project path given (for lack of a clearer definition of what a project is in Atom for now).

> *Although every effort is made to keep things as stable as possible, please do note that the package is under constant development so there might be occasional bugs. If you run across any issues, please [add an issue](https://github.com/queenp/punchclock/issues/new) with the details.*

Installation
------------

### Command Line

```bash
apm install punchclock
```

### Atom

```
Command Palette ➔ Settings View: Install Packages ➔ Punchclock
```

Features
--------

Punchclock currently supports the core basic functionality of being able to track time spent on projects, and persists this data to its internal data store, as well as basic reporting.

Reposting, external services integration & other features are currently in development and will be released gradually.

### Current Features

-	[x] Displays timer in the status bar with the time being tracked, with occasional status messages
-	[x] Saves tracked time data (to be used with features currently under development)
-	[x] Automatically handle saving of time tracking data from previous session, even if the `Finish` command was not issued manually before exiting from Atom
-	[x] Tracks when Atom is out of focus and collects that data, so that it can be factored in for better reporting
-	[x] Configuration setting to auto enable time tracking on all projects on load (Per-project configuration coming soon!!). **Defaults to FALSE/DISABLED**, enable it in your settings to activate the feature
-	[x] Preliminary & basic Dashboard UI available now (not very useful, but it is a start :smile:)

Commands
--------

***Start***

```
ctrl-cmd-s
```

> Starts tracking time on this project
>
> *Issuing this command when time tracking is paused, will continue from where it left off*

***Pause***

```
ctrl-cmd-p
```

> Pause time tracking temporarily without loosing already tracked time
>
> *Issuing this command when time tracking is paused, will continue from where it left off*

***Finish***

```
ctrl-cmd-f
```

> Stops tracking time, and saves the tracked time data

***Reset***

```
ctrl-cmd-r
```

> Discards current tracked time data (not saved), and starts fresh again

***Abort***

```
ctrl-cmd-a
```

> Stop tracking time, and discard the tracked time up to this point
>
> **Action is permanent and tracked time data will be lost forever prior to save!**

***Dashboard***

```
ctrl-cmd-d
```

> Displays the Punchclock UI interfaces - only the Dashboard (basic version) available at this point

Feedback & Issues
-----------------

Any feedback is appreciated!

There are a number of features that are under development, but if there are specific features you would like to see added, please [add an issue](https://github.com/queenp/punchclock/issues/new) and tag it as "feature".

If you encounter any bugs or cannot get something working, please check the current [open issues](https://github.com/queenp/punchclock/issues) to see if it has already been raised, before adding a new issue with the problem you are facing.

I work on this project in my spare time so unfortunately I can make absolutely no guarantees about fixes.
