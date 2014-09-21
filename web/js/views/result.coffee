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
			@map()
			@picture()
		map: ->
			thiz = @
			counter = 1
			
			_.each $('div.map'), (map) ->
				setTimeout ->
					currentMap = new google.maps.Map map,
						zoom: 12
						center: 
							lat: $(map).data 'lat'
							lng: $(map).data 'lng'

					index = $(map).data 'index'
					index = parseInt index
					attractions = thiz.model.cities[index].attractions
					for a in attractions
						coords = new google.maps.LatLng a.latitude, a.longitude
						marker = new google.maps.Marker
							position: coords
							map: currentMap
							title: a.name
				, counter * 3000
				counter++
			

		picture: ->
			counter = 1
			_.each $('img.attraction'), (img) ->
				setTimeout ->
					api.getPhoto $(img).data('name'), $(img).data('address'), (url) ->
						if url? then $(img).attr 'src', url
				, counter * 400
				counter++