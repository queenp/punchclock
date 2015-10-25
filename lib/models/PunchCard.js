"use babel";
"use strict";

var moment = require('moment');
var Pause = require('./Pause');

export default class PunchCard extends Pause {

    constructor({
            start,
            end,
            label,
            branch,
            paused,
            autoPaused,
            pauses=[],
            autoPauses=[]
            })
    {
        super({start,end});

        // Working Directory as project label
        this._label = label;

        // Short branch name if any
        this._branch = branch;

        // Current pause object, if paused.
        this._paused = paused;
        this._autoPaused = autoPaused;

        // Not bothering to cast pauses/autoPauses to Pause objects, as they
        // won't be interactable once they're saved, just init to empty array.
        this._pauses = pauses;
        this._autoPauses = autoPauses;
    }

    get label() {
        return this._label;
    }

    get branch() {
        return this._branch;
    }

    get pauses() {
        return this._pauses || [];
    }

    get isPaused() {
        return Boolean(this._paused || this._autoPaused);
    }

    get autoPauses() {
        return this._autoPauses || [];
    }

    get duration() {
        let dur = super.duration;
        if(this.pauses.length) {
            for(let pause of this.pauses) {
                dur.subtract(pause.duration);
            }
        }
        if (this.autoPauses.length) {
            for(let pause of this._autoPauses) {
                dur.subtract(pause.duration);
            }
        }
        return dur;
    }

    get object() {
        let obj = super.object;
        obj.pauses = this.pauses;
        obj.autoPauses = this.autoPauses;
        obj.duration = this.duration;
        return obj;
    }

    pause(time=null) {
        if(!time){
            time = Date.now()
        }
        if(!this.isPaused) {
            return this._paused = new Pause({start:time});
        } else {
            return false;
        }
    }

    autoPause(time=Date.now()) {
        if(!this.isPaused) {
            return this._autoPaused = new Pause({start:time});
        } else {
            return false;
        }
    }

    resume(time=Date.now()) {
        if(this._paused) {
            this._paused.end = time;
            this._pauses.push(this._paused.object);
            delete(this._paused);
        } else if(this._autoPaused) {
            this._autoPaused.end = time;
            this._autoPauses.push(this._autoPaused.object);
            delete(this._autoPaused);
        } //else do nothing
    }
}
