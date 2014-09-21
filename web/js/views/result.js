// Generated by CoffeeScript 1.7.1
define(['jquery', 'ma', 'utils', 'vv', 'text!templates/result.html'], function($, ma, utils, vv, template) {
  var ResultView;
  return ResultView = Backbone.View.extend({
    el: $('body'),
    model: null,
    initialize: function(options) {
      return this.model = options.data;
    },
    render: function() {
      console.log(this.model);
      this.$el.html(_.template(template)(this.model));
      return vv.work();
    }
  });
});
