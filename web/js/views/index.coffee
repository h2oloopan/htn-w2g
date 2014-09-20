define ['jquery', 'ma', 'vv', 'text!templates/index.html'], ($, ma, vv, template) ->
	return IndexView = Backbone.View.extend
		el: $('body')
		events:
			'click .btn-search': 'search'
		render: ->
			@test()
			@$el.html _.template(template)({})
			vv.work()
		search: ->