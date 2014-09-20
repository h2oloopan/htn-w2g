define ['jquery', 'ma', 'vv', 'text!templates/index.html'], ($, ma, vv, template) ->
	return IndexView = Backbone.View.extend
		el: $('body')
		test: ->
			###
			ma.api.ta.map
				lat: '42.33141'
				long: '-71.099396'
			, (result) ->
				console.log result
			###
		render: ->
			@test()
			@$el.html _.template(template)({})
			vv.work()