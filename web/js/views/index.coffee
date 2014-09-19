define ['text!templates/index.html'], (template) ->
	return IndexView = Backbone.View.extend
		el: $('body')
		render: ->
			@$el.html _.template(template) 
				hello: 'Hello Vera!'
				list: ['A', 'B', 'C', 'D']