'use strict';

class Ports {
  constructor() {
    const ports = window.ExTempo.ports;

    ports.initPort.subscribe(this.initPort);
    ports.updateTextFields.subscribe(this.updateTextFields);
    ports.openModal.subscribe(this.openModal);
    ports.closeModal.subscribe(this.closeModal);
  }

  // Initialization port, only called once when the Elm App initializes.
  initPort() {
    $('.modal').modal({dismissible: false});
  }

  // Used when dynamically updating Materialize text fields.
  updateTextFields(input) {
    window.Materialize.updateTextFields();
  }

  openModal(input) {
    window.ExTempoPorts.updateTextFields();
    $('#' + input).modal('open');
  }

  closeModal(input) {
    $('#' + input).modal('close');
    window.ExTempoPorts.updateTextFields();
  }
}

module.exports = Ports;
