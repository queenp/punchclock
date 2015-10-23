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

    elapsed() {
        console.log(this.end)
        if(this.end == null) {
            return moment().diff(this.start);
        } else {
            return this.end.diff(this.start);
        }
    }
}
