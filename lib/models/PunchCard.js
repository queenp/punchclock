"use babel";
"use strict";

var moment = require('moment');
var Pause = require('./Pause');

export default class PunchCard extends Pause {

    constructor(args) {
        super(args);
        if('label' in args) {
            this.pauses = this.pauses || [];
            this.autoPauses = this.autoPauses || [];
            this.paused = null;
        }
    }

    pause() {
        if(!this.paused){
            this.paused = new Pause();
        } else {
            resume(); // Why not.
        }
    }

    resume() {
        if(paused) {
            this.paused.finish();
            this.pauses.push(this.paused);
            this.paused = null; // get rid of instance reference now it's saved
        }
    }

    autoPause() {
        if(!this.paused && !this.autoPaused) {
            this.autoPaused = new Pause();
        }
    }

    autoResume() {
        if(this.autoPaused) {
            this.autoPaused.finish();
            this.autoPauses.push(this.autoPaused);
            this.autoPaused = null;
        }
    }

    finish() {
        this.end = moment();
        return this.to_object();
    }

    to_object() {
        var obj = super.to_object();
        obj.merge({
            pauses: this.pauses.map(function(pause) {
                return pause.to_object();
            }),
            autoPauses: this.autoPauses.map(function(pause) {
                return pause.to_object();
            })
        });
        return obj;
    }

    duration(pauses=true,autoPauses=true) {
        var dur = moment(this.end || undefined).diff(this.start);
        if(pauses && this.pauses.length>0) {
            for(let pause of this.pauses) {
                dur -= pause.duration();
            }
        }
        if (autoPauses && this.autoPauses.length>0) {
            for(let pause of this.autoPauses) {
                dur -= pause.duration();
            }
        }
        return dur;
    }
}
