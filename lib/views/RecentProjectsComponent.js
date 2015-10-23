"use babel";

/** @jsx etch.dom */

import etch from 'etch';
RecentProject = require('./RecentProject');

export default class RecentProjectsComponent {
    constructor({projects}){
        this.projects = projects;
        etch.createElement(this);
    }

    render() {
        return (
            <div className="recent-projects">
                <div className="header">
                    <h4>Recent Projects</h4>
                </div>
                {this.message()}
                <div className="collection">{
                    this.projects.map(proj => <RecentProject project={proj} /> )
                }</div>
            </div>
        );
    }

    message() {
        if( this.projects.length == 0 ){
            // Set the content to no time tracking
            return "You are currently not tracking time for any projects! :(";
        }
        else if (this.projects.length == 1) {
            // We have one project, show the message
            return "You are currently tracking time for one project";
        }
        else{
            // We have some projects, show the message
            return `You are currently tracking time for ${this.projects.length} projects`;
        }
    }
}
