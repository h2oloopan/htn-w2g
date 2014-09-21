define ['jquery', 'ma', 'utils', 'vv', 'text!templates/index.html', 'text!templates/advance.html'], 
($, ma, utils, vv, template, template_advance) ->
	return IndexView = Backbone.View.extend
		el: $('body')
		events:
			'click .simple-search-submit': 'search'
			'click #advance-add': 'advanceAdd'
			'click .btn-advance-submit': 'advanceSearch'
		render: ->
			@$el.html _.template(template)({subcategories: ma.attractions.subcategories})
			vv.work()
			@autocomplete()
		autocomplete: ->
			acStart = new google.maps.places.Autocomplete document.getElementById('txt-start'), 
				types: ['(cities)']
			acEnd = new google.maps.places.Autocomplete document.getElementById('txt-end'),
				types: ['(cities)']

			_.each $('.txt-city'), (txt) ->
				new google.maps.places.Autocomplete txt,
					types: ['(cities)']
		advanceSearch: ->
			form = utils.serialize $('.advanced-search-form')
			days = 0
			stays = []
			for day in form.day
				stay = parseInt day
				stays.push stay
				days += stay
			input =
				cities: form.city
				stays: stays
				days: days
				preferences: form.preference
			ma.search input, (result) ->
				#do nothing
				console.log result
			return false
		advanceAdd: ->
			$('.advanced-search').append template_advance
			txt = $('.advanced-search .txt-city:last')[0]
			new google.maps.places.Autocomplete txt,
				types: ['(cities)']
		search: ->
			form = utils.serialize $('#form-search-simple')
			form.days = parseInt form.days
			input =
				cities: [form.start, form.end]
				days: form.days
			ma.search input, (id) ->
				#do nothing
				window.location.href = '#result/' + id
				
			return false

