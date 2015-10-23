"use babel";
"use strict";

var moment = require('moment');
var Model = require('./Model');

export default class Pause extends Model {
    constructor(timestamps={}) {
        super(timestamps);
        this.start = this.start || moment();
        this.end   = this.end || null;
    }

    finish() {
        this.end = moment();
        return this;
    }

    duration() {
        if(this.end == null) {
            return moment.duration(moment().diff(this.start));
        } else {
            return moment.duration(this.end.diff(this.start));
        }
    }

    to_object() {
        return ({
            start: this.start.unix(),
            end: this.end.unix(),
            duration: this.duration()
        });
    }
}
