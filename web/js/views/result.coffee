define ['jquery', 'ma', 'api', 'utils', 'vv', 'text!templates/result.html'], 
($, ma, api, utils, vv, template) ->
	return ResultView = Backbone.View.extend 
		el: $('body')
		model: null
		initialize: (options) ->
			@model = options.data
		render: ->
			console.log @model
			@$el.html _.template(template)(@model)
			vv.work()
			@picture()
		picture: ->
			counter = 1
			_.each $('img.attraction'), (img) ->
				setTimeout ->
					api.getPhoto $(img).data('name'), $(img).data('address'), (url) ->
						if url? then $(img).attr 'src', url
				, counter * 500
				counter++