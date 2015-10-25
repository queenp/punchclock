"use babel";
"use strict";

var moment = require('moment');

// Date representations relative to Unix Epoch (ie: at millisecond granularity)
// Mostly for easier integration with Date.now()
export default class Pause {
    constructor({start:start,end:end}={}) {
        if(Number.isInteger(start)){
            this.start = moment(start)
        }
        if(Number.isInteger(end)){
            this.end = moment(end);
        }
    }

    set start(unixEpoch) {
        if(!moment.isMoment(this._start))
        {
            this._start = moment(unixEpoch);
        }
    }

    set end(unixEpoch) {
        if(!moment.isMoment(this._end)){
            this._end = moment(unixEpoch);
        }
    }

    get start() {
        return this._start;
    }

    get end() {
        return this._end;
    }

    get duration() {
        if(!this._start){
            // Default to 0 duration
            return moment.duration(0);
        } else if(!this._end) {
            return moment.duration(moment().diff(this._start));
        } else {
            return moment.duration(this._end.diff(this._start));
        }
    }

    get object() {
        return {
            start: +this.start,
            end: +this.end,
            duration: +this.duration
        };
    }
}
