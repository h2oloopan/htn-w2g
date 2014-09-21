define ['jquery', 'ma', 'utils', 'vv', 'text!templates/result.html'], 
($, ma, utils, vv, template) ->
	return ResultView = Backbone.View.extend 
		el: $('body')
		model: null
		initialize: (options) ->
			@model = options.data
		render: ->
			@$el.html _.template(template)(@model)
			vv.work()