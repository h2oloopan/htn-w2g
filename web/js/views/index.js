// Generated by CoffeeScript 1.8.0
define(['jquery', 'ma', 'utils', 'vv', 'text!templates/index.html', 'text!templates/advance.html'], function($, ma, utils, vv, template, template_advance) {
  var IndexView;
  return IndexView = Backbone.View.extend({
    el: $('body'),
    events: {
      'click .btn-search': 'search',
      'click #advance-add': 'advanceAdd',
      'click .btn-test': 'test'
    },
    render: function() {
      this.$el.html(_.template(template)({
        subcategories: ma.attractions.subcategories
      }));
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
    test: function() {
      var form;
      form = utils.serialize($('.div-test'));
      alert(JSON.stringify(form));
      return false;
    },
    advanceAdd: function() {
      return $('.advanced-search').append(template_advance);
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
