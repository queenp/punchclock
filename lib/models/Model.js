"use babel";
"use strict";

require("babel/polyfill"); //Necessary for Object.assign

export default class Model {
    constructor(object) {
        Object.assign(this,object);
    }
}
