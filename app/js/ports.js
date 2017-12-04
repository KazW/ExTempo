'use strict';

class Ports {
  constructor() {
    const ports = window.Main.ports;

    ports.initPort.subscribe(this.initPort);
  }

  // Initialization port, only called once when the Elm App initializes.
  initPort() {
    window.Materialize.updateTextFields();
  }
}

module.exports = Ports;
