'use strict';

class Ports {
  constructor() {
    const ports = window.Main.ports;

    ports.initPort.subscribe(this.initPort);
    ports.updateTextFields.subscribe(this.updateTextFields);
  }

  // Initialization port, only called once when the Elm App initializes.
  initPort() {
    window.MainPorts.updateTextFields();
  }

  // Used when dynamically updating Materialize text fields.
  updateTextFields() {
    window.Materialize.updateTextFields();
  }
}

module.exports = Ports;
