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
                <div className="collection">{
                    this.projects.map(proj => <RecentProject project={proj} /> )
                }</div>
            </div>
        );
    }
}
