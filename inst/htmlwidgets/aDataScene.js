HTMLWidgets.widget({

  name: 'aDataScene',

  type: 'output',

  factory: function(el, width, height) {
    return {
      renderValue: function(x) {
        Object.getOwnPropertyNames(x).forEach(function (key) {
          if (!Array.isArray(x[key])) {
            x[key] = HTMLWidgets.dataframeToD3(x[key]);
          }
        });
        el.emit('update-data', {data: x});
      },
      resize: function(width, height) {
        // no-op
      }
    };
  }
});
