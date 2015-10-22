'use babel';

/** @jsx etch.dom */

import etch from 'etch'

export default class RecentProject {
    constructor({project}){
        this.project = project;
        etch.createElement(this);
    }

    render() {
        return (
            <div className="project item">
                <h6 className="title">{this.project.label}</h6>
                <span className="subtitle">{this.project.path}</span>
                <div className="duration">{this.project.duration}</div>
            </div>
        );
    }

    update({project}) {
        this.project = project;
        etch.updateElement(this);
    }
}
