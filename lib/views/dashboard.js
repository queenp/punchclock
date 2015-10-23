"use babel";
"use strict";

/** @jsx etch.dom */

/// IMPORTS ///
import etch from 'etch';

// punchclock
Reporter = require("../reporter.coffee");
RecentProjectsComponent = require("./RecentProjectsComponent")

/// EXPORTS ///
export default class DashboardView {
    /// CONSTRUCTOR ///
    constructor(){
        this.reporter = new Reporter();
        // Get the projects from the reporter
        etch.createElement(this);
    }

    /// CONTENT ///
    render(){
        return (
            <div id="dashboard" className="wrapper">
                <div className="message"><RecentProjectsComponent projects={this.reporter.getProjects()} /></div>
            </div>
        );
    }

    /// INITIALIZE ///
    initialize(){
    }
}
