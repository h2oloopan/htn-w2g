// Generated by CoffeeScript 1.6.3
define(['text!templates/index.html'], function(template) {
  var IndexView;
  return IndexView = Backbone.View.extend({
    el: $('body'),
    render: function() {
      return this.$el.html(_.template(template)({
        hello: 'Hello Vera!',
        list: ['A', 'B', 'C', 'D']
      }));
    }
  });
});
