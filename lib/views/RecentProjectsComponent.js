'use babel';

/** @jsx etch.dom */

import etch from 'etch'

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
                <ul className="collection">
                    this.projects.map( project =>
                        <li className="project">{project}
                            <h6 className="title">{project.label}</h6>
                            <p className="subtitle">{project.path}</p>
                            <p className="duration">{project.path}</p>
                        </li>
                    );
                </ul>
            </div>
        );
    }
}
