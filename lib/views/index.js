"use babel";

/** @jsx etch.dom */

/// IMPORTS ///

import etch from 'etch';

HeaderView = require("./header.js");
DashboardView = require("./dashboard.js");

/// EXPORTS ///
export default class PunchclockView {
    /// CONTENT ///
    render () {
        return(
            <div className="punchclock pane-item" tabindex="-1">
                <div className="ui-page">
                    <HeaderView packageTitle={this.getTitle()} />
                    <div className="content">
                        <DashboardView />
                    </div>
                </div>
            </div>
        );
    }

    /// CONSTRUCTOR ///
    constructor({page}) {
        this.page = page;
        if(this.page) {
            // Get the uri path without the forward slash
            this.controller = this.page.substring( 1 ).split( "/" )[0];
                // Let us check what kind of view we want to generate
        }
        etch.createElement(this);
    }

    /// INTERNAL METHODS ###
    /// GET TITLE ###
    getTitle () {
        return "Punchclock";
    }

    /// GET ICON NAME ///
    getIconName () {
        return "clock";
    }

    /// GET URI ###
    getURI () {
        return this.uri;
    }
}
