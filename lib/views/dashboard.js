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

        currentProjects = this.reporter.getProjects()

        // Check if we have any projects to put in the message area
        if( currentProjects.length == 0 ){
            // Set the content to no time tracking
            this.message = "You are currently not tracking time for any projects! :(";
        }
        else if (currentProjects.length == 1) {
            // We have one project, show the message
            this.message = "You are currently tracking time for one project";
        }
        else{
            // We have some projects, show the message
            this.message = "You are currently tracking time for #{currentProjects.length} projects";
        }
        // Add the available projects to the summary list
        if (currentProjects.length > 0){
            // Display Recent Projects
            this.message = currentProjects;
        }
        etch.createElement(this);
    }

    /// CONTENT ///
    render(){
        // Setup the container
        return (
            <div id="dashboard" className="wrapper">
                // Message
                <div className="message"><RecentProjectsComponent projects={this.reporter.getProjects()} /></div>
            </div>
        );
    }

    /// INITIALIZE ///
    initialize(){
    }
}
