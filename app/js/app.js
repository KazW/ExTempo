'use strict';

// Style
require('js/style');

// Load Elm and JS
const Elm    = require('elm/Main');
const Config = require('js/config');
const Ports  = require('js/ports');
const config = new Config;

// Hack to get around Elm some how breaking "this" scoping in class methods.
window.Main      = Elm.Main.fullscreen(config.fromMeta());
window.MainPorts = new Ports;
