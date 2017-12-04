'use strict';

class Config {
  // Pull information out of meta tags
  fromMeta() {
    var metas = document.getElementsByTagName('meta');
    var config = {};

    // These are in meta tags because they get passed in from ENV variables at compile time.
    for (var i = 0; i < metas.length; i++) {
      if (metas[i].getAttribute('property') === 'api-url') {
        config.apiUrl = metas[i].getAttribute('content');
      }
    }

    return config;
  }
}

module.exports = Config;
