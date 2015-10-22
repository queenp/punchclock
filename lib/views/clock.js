"use babel";
"use strict";

/** @jsx etch.dom */

/// IMPORTS ///
import etch from 'etch';

export default class ClockView {
    /// CONSTRUCTOR ///
    constructor() {
        this.time = "00:00:00";
        etch.createElement(this);
    }

    /// CONTENT ///
    render() {
        return (
            <div className='punchclock inline-block'>
                <div className='timer'>
                    <span className='icon icon-clock'> </span>
                    <span id='time'>{this.time} </span>
                </div>
            </div>
        );
    }

    attach(statusBar) {
        // Check if we have the status bar
        if(statusBar){
            statusBar.addRightTile({
                item: this,
                priority: 100
            });
        }
    }

    destroy() {
        this.detach();
    }

    update( time ) {
        this.time = time;
        etch.updateElement(this);
    }
}
