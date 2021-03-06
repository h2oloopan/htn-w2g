// Generated by CoffeeScript 1.7.1
define(['jquery', 'ma', 'utils', 'vv', 'text!templates/index.html', 'text!templates/advance.html'], function($, ma, utils, vv, template, template_advance) {
  var IndexView;
  return IndexView = Backbone.View.extend({
    el: $('body'),
    events: {
      'click .simple-search-submit': 'search',
      'click #advance-add': 'advanceAdd',
      'click .btn-advance-submit': 'advanceSearch'
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
      acEnd = new google.maps.places.Autocomplete(document.getElementById('txt-end'), {
        types: ['(cities)']
      });
      return _.each($('.txt-city'), function(txt) {
        return new google.maps.places.Autocomplete(txt, {
          types: ['(cities)']
        });
      });
    },
    advanceSearch: function() {
      var day, days, form, input, stay, stays, _i, _len, _ref;
      form = utils.serialize($('.advanced-search-form'));
      days = 0;
      stays = [];
      _ref = form.day;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        day = _ref[_i];
        stay = parseInt(day);
        stays.push(stay);
        days += stay;
      }
      input = {
        cities: form.city,
        stays: stays,
        days: days,
        preferences: form.preference
      };
      ma.search(input, function(id) {
        return window.location.href = '#result/' + id;
      });
      return false;
    },
    advanceAdd: function() {
      var txt;
      $('.advanced-search').append(template_advance);
      txt = $('.advanced-search .txt-city:last')[0];
      return new google.maps.places.Autocomplete(txt, {
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
      ma.search(input, function(id) {
        return window.location.href = '#result/' + id;
      });
      return false;
    }
  });
});
