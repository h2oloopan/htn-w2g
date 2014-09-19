define ['text!templates/index.html'], (template) ->
	return IndexView = Backbone.View.extend
		el: $('body')
		render: ->
			@$el.html template