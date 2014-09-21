define ['jquery', 'ma', 'api', 'utils', 'vv', 'text!templates/result.html'], 
($, ma, api, utils, vv, template) ->
	return ResultView = Backbone.View.extend 
		el: $('body')
		model: null
		maps: {}
		events:
			'click .btn-tab': 'tab'
		initialize: (options) ->
			@model = options.data
			@maps = {} 
		render: ->
			console.log @model
			@$el.html _.template(template)(@model)
			vv.work()
			@map()
			@picture()
		tab: (e) ->
			thiz = @
			target = e.currentTarget
			index = $(target).data 'index'

			if @maps['m' + index]? then return

			setTimeout ->
				map = $('div.map-' + index)[0]
				currentMap = new google.maps.Map map,
				zoom: 12
				center: 
					lat: $(map).data 'lat'
					lng: $(map).data 'lng'

				thiz.maps['m' + index] = currentMap

				index = $(map).data 'index'
				index = parseInt index
				attractions = thiz.model.cities[index].attractions
				for a in attractions
					coords = new google.maps.LatLng a.latitude, a.longitude
					marker = new google.maps.Marker
						position: coords
						map: currentMap
						title: a.name
			, 300
		map: ->
			thiz = @
			map = $('div.map-1')[0]				
			currentMap = new google.maps.Map map,
				zoom: 12
				center: 
					lat: $(map).data 'lat'
					lng: $(map).data 'lng'
			@maps['m1'] = currentMap

			index = $(map).data 'index'
			index = parseInt index
			attractions = thiz.model.cities[index].attractions
			for a in attractions
				coords = new google.maps.LatLng a.latitude, a.longitude
				marker = new google.maps.Marker
					position: coords
					map: currentMap
					title: a.name

		picture: ->
			counter = 1
			_.each $('img.attraction'), (img) ->
				setTimeout ->
					api.getPhoto $(img).data('name'), $(img).data('address'), (url) ->
						if url? then $(img).attr 'src', url
				, counter * 800
				counter++