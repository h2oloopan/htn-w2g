define ['jquery', 'ma', 'utils', 'vv', 'text!templates/index.html'], ($, ma, utils, vv, template) ->
	return IndexView = Backbone.View.extend
		el: $('body')
		events:
			'click .btn-search': 'search'
		render: ->
			@$el.html _.template(template)({})
			vv.work()
			@autocomplete()
		autocomplete: ->
			acStart = new google.maps.places.Autocomplete document.getElementById('txt-start'), 
				types: ['(cities)']
			acEnd = new google.maps.places.Autocomplete document.getElementById('txt-end'),
				types: ['(cities)']

		search: ->
			form = utils.serialize $('#form-search-simple')
			form.days = parseInt form.days
			input =
				cities: [form.start, form.end]
				days: form.days
			ma.search input, (result) ->
				#do nothing
				console.log result

