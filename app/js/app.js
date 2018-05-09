'use strict';

// Style
require('js/style');

// Load Elm and JS
const Elm    = require('elm/ExTempo');
const Config = require('js/config');
const Ports  = require('js/ports');
const config = new Config();

//Monitoring
const Raven = require('raven-js');

// Hack to get around Elm some how breaking "this" scoping in class methods.
Raven.config(config.sentryDSN()).install();
Raven.context(function () {
  window.ExTempo      = Elm.ExTempo.fullscreen(config.fromMeta());
  window.ExTempoPorts = new Ports();
});
