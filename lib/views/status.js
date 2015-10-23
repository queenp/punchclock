"use babel";
"use strict";

/** @jsx etch.dom */

/// IMPORTS ///
import etch from 'etch';
import Promise from 'es6-promise'

export default class StatusView {
    /// CONSTRUCTOR
    constructor() {
        this.status = "";
        etch.createElement(this);
    }

    /// CONTENT ///
    render() {
        return (
            <div className='punchclock inline-block'>
                <div className="timer">
                    <span id="status">{this.status}</span>
                </div>
            </div>
        );
    }

    /// ATTACH ///
    attach(statusBar) {
        // Check if we have the status bar
        if(!statusBar){
            throw(new Error("Error: No Status Bar"));
        }
        this.statusBarTile = statusBar.addRightTile({item: this, priority:101});
    }

    /// DESTROY ///
    destroy() {
        // Detach at this point
        this.detach();
    }

    /// UPDATE ///
    update( status ) {
        // Update the status with the message
        this.status = status;
        etch.updateElement(this);
    }

    /// CLEAR ///
    clear() {
        // Clear any status message
        this.update( "" );
    }
}
