define ['jquery', 'ma', 'utils', 'vv', 'text!templates/result.html'], 
($, ma, utils, vv, template) ->
	return ResultView = Backbone.View.extend 
		el: $('body')
		render: ->
			@$el.html _.template(template)()
			vv.work()