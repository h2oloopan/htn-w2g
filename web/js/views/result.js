// Generated by CoffeeScript 1.8.0
define(['jquery', 'ma', 'utils', 'vv', 'text!templates/result.html'], function($, ma, utils, vv, template) {
  var ResultView;
  return ResultView = Backbone.View.extend({
    el: $('body'),
    render: function() {
      this.$el.html(_.template(template)());
      return vv.work();
    }
  });
});