'use strict';

class Ports {
  constructor() {
    const ports = window.Main.ports;

    ports.initPort.subscribe(this.initPort);
    ports.updateTextFields.subscribe(this.updateTextFields);
    ports.openModal.subscribe(this.openModal);
    ports.closeModal.subscribe(this.closeModal);
  }

  // Initialization port, only called once when the Elm App initializes.
  initPort() {
    $('.modal').modal({dismissible: false});
    window.MainPorts.updateTextFields();
  }

  // Used when dynamically updating Materialize text fields.
  updateTextFields(input) {
    window.Materialize.updateTextFields();
  }

  openModal(input) {
    $('#' + input).modal('open');
  }

  closeModal(input) {
    $('#' + input).modal('close');
  }
}

module.exports = Ports;
