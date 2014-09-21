define ['jquery', 'ma', 'utils', 'vv', 'text!templates/index.html', 'text!templates/advance.html'], 
($, ma, utils, vv, template, template_advance) ->
	return IndexView = Backbone.View.extend
		el: $('body')
		events:
			'click .btn-search': 'search'
			'click #advance-add': 'advanceAdd'
			'click .btn-test': 'test'
		render: ->
			@$el.html _.template(template)({subcategories: ma.attractions.subcategories})
			vv.work()
			@autocomplete()
		autocomplete: ->
			acStart = new google.maps.places.Autocomplete document.getElementById('txt-start'), 
				types: ['(cities)']
			acEnd = new google.maps.places.Autocomplete document.getElementById('txt-end'),
				types: ['(cities)']
		test: ->
			form = utils.serialize $('.div-test')
			alert JSON.stringify form
			return false
		advanceAdd: ->
			$('.advanced-search').append template_advance
		search: ->
			form = utils.serialize $('#form-search-simple')
			form.days = parseInt form.days
			input =
				cities: [form.start, form.end]
				days: form.days
			ma.search input, (result) ->
				#do nothing
				console.log result

