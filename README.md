# Timekeeper

Timekeeper allows you to track time spent on projects, and provides (or rather will provide) ways to view the data in different ways as well as the ability to export and integrate this data with external endpoints.

##### Default Status Bar View

![Timekeeper](https://github.com/skulled/timekeeper/raw/master/docs/assets/images/timekeeper-status-bar-view.png)

##### Active & Tracking Time

![Timekeeper Active](https://github.com/skulled/timekeeper/raw/master/docs/assets/images/timekeeper-status-bar-view-active.png)

##### Paused State

![Timekeeper Paused](https://github.com/skulled/timekeeper/raw/master/docs/assets/images/timekeeper-status-bar-view-paused.png)

As of `v0.3.0`, it provides a preliminary dashboard to view time tracking data, which is very incomplete and pretty useless. Further reporting & dashboard functionality coming soon!!

> _Although every effort is made to keep things as stable as possible, please do note that the package is under constant development so there might be occasional bugs. If you run across any issues, please [add an issue](https://github.com/skulled/timekeeper/issues/new) with the details._

## Installation

### Command Line

```bash
apm install timekeeper
```

### Atom

```
Command Palette ➔ Settings View: Install Packages ➔ Timekeeper
```

## Features

Timekeeper currently supports the core basic functionality of being able to track time spent on projects, and persists this data to its internal data store.

Reposting, external services integration & other features are currently in development and will be released gradually.

### Current Features

- [x] Displays timer in the status bar with the time being tracked, with occasional status messages
- [x] Saves tracked time data (to be used with features currently under development)
- [x] Automatically handle saving of time tracking data from previous session, even if the `Finish` command was not issued manually before exiting from Atom
- [x] Tracks when Atom is out of focus and collects that data, so that it can be factored in for better reporting
- [x] Configuration setting to auto enable time tracking on all projects on load (Per-project configuration coming soon!!). **Defaults to FALSE/DISABLED**, enable it in your settings to activate the feature
- [x] Preliminary & basic Dashboard UI available now (not very useful, but it is a start :smile:)

## Commands

**_Start_**

```
ctrl-alt-s
```

> Starts tracking time on this project
>
> _Issuing this command when time tracking is paused, will continue from where it left off_

**_Pause_**

```
ctrl-alt-p
```

> Pause time tracking temporarily without loosing already tracked time
>
> _Issuing this command when time tracking is paused, will continue from where it left off_

**_Finish_**

```
ctrl-alt-f
```

> Stops tracking time, and saves the tracked time data

**_Reset_**

```
ctrl-alt-r
```

> Discards current tracked time data (not saved), and starts fresh again

**_Abort_**

```
ctrl-alt-a
```

> Stop tracking time, and discard the tracked time up to this point
>
> **Action is permanent and tracked time data will be lost forever prior to save!**

**_Dashboard_**

```
ctrl-alt-d
```

> Displays the Timekeeper UI interfaces - only the Dashboard (basic version) available at this point

## Feedback & Issues

Any feedback is appreciated!

There are a number of features that are under development, but if there are specific features you would like to see added, please [add an issue](https://github.com/skulled/timekeeper/issues/new) and tag it as "feature".

If you encounter any bugs or cannot get something working, please check the current [open issues](https://github.com/skulled/timekeeper/issues) to see if it has already been raised, before adding a new issue with the problem you are facing.