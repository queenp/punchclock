"use babel";
"use strict";
/// IMPORTS ///
import path from "path";
import {CompositeDisposable} from 'event-kit';

//
// $ = require 'jquery'
//
// # moment
// moment = null
//
// # twix
// twix = null
//
// # mkdirp
// mkdirp = null
//
// # punchclock
import ClockView from './views/ClockView';
import StatusView from './views/StatusView';
import PunchCard from './models/PunchCard';
//
/// EXPORTS ///
export default class Timer {
    constructor( state, timeDataPath ) {
        this.repos = Promise.all(
            atom.project.getDirectories()
                .map(atom.project.repositoryForDirectory.bind(atom.project)))
        .then(repos=>{
            this.root = repos[0].getWorkingDirectory();
            this.branch = repos[0].getShortHead();
        })
    }
}
