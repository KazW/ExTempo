'use strict';

// Style
require('js/style');

// Load Elm and JS
const Elm    = require('elm/ExTempo');
const Config = require('js/config');
const Ports  = require('js/ports');
const config = new Config;

// Hack to get around Elm some how breaking "this" scoping in class methods.
window.ExTempo      = Elm.ExTempo.fullscreen(config.fromMeta());
window.ExTempoPorts = new Ports;
