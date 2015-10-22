"use babel";
"use strict";

/** @jsx etch.dom */

/// IMPORTS ///
import etch from 'etch';

export default class HeaderView {
    constructor({packageTitle}) {
        this.name = packageTitle;
        etch.createElement(this);
    }

    /// CONTENT ///
    render() {
        return (
            <div className="header">
                <h2>{this.name}</h2>
            </div>
        );
    }
}
