// Generated by CoffeeScript 1.7.1
define(['jquery', 'ma', 'utils', 'vv', 'text!templates/index.html'], function($, ma, utils, vv, template) {
  var IndexView;
  return IndexView = Backbone.View.extend({
    el: $('body'),
    events: {
      'click .btn-search': 'search'
    },
    render: function() {
      this.$el.html(_.template(template)({}));
      vv.work();
      return this.autocomplete();
    },
    autocomplete: function() {
      var acEnd, acStart;
      acStart = new google.maps.places.Autocomplete(document.getElementById('txt-start'), {
        types: ['(cities)']
      });
      return acEnd = new google.maps.places.Autocomplete(document.getElementById('txt-end'), {
        types: ['(cities)']
      });
    },
    search: function() {
      var form, input;
      form = utils.serialize($('#form-search-simple'));
      form.days = parseInt(form.days);
      input = {
        cities: [form.start, form.end],
        days: form.days
      };
      return ma.search(input, function(result) {
        return console.log(result);
      });
    }
  });
});
