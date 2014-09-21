define ['jquery', 'api', 'utils'], ($, api, utils) ->
	#helper
	mn = 
		distance:
			lat: 0.8
			lng: 1.6
	test = (data) ->
		for entry in data
			console.log entry.address_obj.address_string + ' ' + entry.latitude + ' ' + entry.longitude

	#algorithm
	prepare = (stops, attractions) ->
		cities = {}
		ranks = []
		ids = []
		start = stops.start
		end = stops.end
		start_lat = if start.lat < end.lat then start.lat - mn.distance.lat else start.lat + mn.distance.lat
		start_lng = if start.lng < end.lng then start.lng - mn.distance.lng else start.lng + mn.distance.lng
		end_lat = if end.lat < start.lat then end.lat - mn.distance.lat else end.lat + mn.distance.lat
		end_lng = if end.lng < start.lng then end.lng - mn.distance.lng else end.lng + mn.distance.lng
		#remove duplication and classify by city


		for a in attractions
			id = a.location_id
			if ids.indexOf(id) >= 0 then continue

			#continue if out of boundaries
			lat = a.latitude
			lng = a.longitude
			if !(start_lat <= lat && lat <= end_lat || start_lat >= lat && lat >= end_lat) then continue
			if !(start_lng <= lng && lng <= end_lng || start_lng >= lng && lng >= end_lng) then continue

			ids.push id
			city = a.ancestors[0].name
			if !cities[city]? then cities[city] = []
			
			score = (a.percent_recommended * 1.0 / 100.0) * a.num_reviews * a.rating
			a.score = score
			cities[city].push a
			ranks.push a

		for key in utils.keys cities
			cities[key].sort (a, b) ->
				return b.score - a.score

		ranks.sort (a, b) ->
			return b.score - a.score


		result =
			cities: cities
			ranks: ranks
		return result

	awesomify = (stops, attractions, cb) ->
		console.log 'attractions to deal with'
		data = prepare stops, attractions
		console.log stops
		console.log data
		#deal with data here


		return cb null

	mystify = (list, days, cb) ->
		subcategories = 'landmarks'
		console.log 'Something to mystify:'
		console.log list
		console.log days
		output = {}
		keys = utils.keys list
		number = keys.length
		switch number
			when 1
				#we are only visiting one single city
				return
			else
				#we are visiting multiple cities
				start = list[keys[0]]
				end = list[keys[1]]
				todo = 4
				attractions = []
				api.taIds
					lat: start.lat
					lng: start.lng
				, (result) ->
					api.taLocation result.city.id, 
						type: 'attractions'
						subcategory: subcategories
					, (result) ->
						for item in result.data
							attractions.push item
						todo--
						if todo == 0 then awesomify {start: start, end: end}, attractions, cb
					api.taLocation result.country.id,
						type: 'attractions'
						subcategory: subcategories
					, (result) ->
						for item in result.data
							attractions.push item
						todo--
						if todo == 0 then awesomify {start: start, end: end}, attractions, cb

				api.taIds
					lat: end.lat
					lng: end.lng
				, (result) ->
					api.taLocation result.city.id,
						type: 'attractions'
						subcategory: subcategories
					, (result) ->
						for item in result.data
							attractions.push item
						todo--
						if todo == 0 then awesomify {start: start, end: end}, attractions, cb
					api.taLocation result.country.id,
						type: 'attractions'
						subcategory: subcategories
					, (result) ->
						for item in result.data
							attractions.push item
						todo--
						if todo == 0 then awesomify {start: start, end: end}, attractions, cb

		for key in keys
			do (key) ->
				###
				item = list[key]
				api.taMap
					lat: item.lat
					lng: item.lng
				, 'attractions', (result) ->
					console.log result
				###

		return cb output
	return ma =
		attractions:
			subcategories:
				'Other': 'other'
				'Nightlife': 'nightlife'
				'Shopping': 'shopping'
				'Bar': 'bars'
				'Club': 'clubs'
				'Food & Drink': 'food_drink'
				'Ranch Farm': 'ranch_farm'
				'Adventure': 'adventure'
				'Gear Rental': 'gear_rentals'
				'Wellness & Spa': 'wellness_spas'
				'Class': 'classes'
				'Sightseeing Tour': 'sightseeing_tours'
				'Performance': 'performances'
				'Sport': 'sports'
				'Outdoor': 'outdoors'
				'Amusement': 'amusement'
				'Landmark': 'landmarks'
				'Zoo & Aquarium': 'zoos_aquariums'
				'Museums': 'museums'
				'Cultural': 'cultural'
			durations:
				'Other': 5
				'Nightlife': 4
				'Shopping': 2
				'Bar': 3
				'Club': 3
				'Food & Drink': 2
				'Ranch Farm': 2
				'Adventure': 4
				'Gear Rental': 3
				'Wellness & Spa': 3
				'Class': 2
				'Sightseeing Tour': 8
				'Performance': 3
				'Sport': 3
				'Outdoor': 4
				'Amusement': 4
				'Landmark': 2
				'Zoo & Aquarium': 3
				'Museums': 6
				'Cultural': 4
			times:
				'Other': 0
				'Nightlife': 5
				'Shopping': 3
				'Bar': 4
				'Club': 4
				'Food & Drink': 4
				'Ranch Farm': 2
				'Adventure': 2
				'Gear Rental': 2
				'Wellness & Spa': 3
				'Class': 2
				'Sightseeing Tour': 1
				'Performance': 5
				'Sport': 5
				'Outdoor': 2
				'Amusement': 4
				'Landmark': 2
				'Zoo & Aquarium': 4
				'Museums': 2
				'Cultural': 2

			
		search: (input, cb) ->
			list = {}
			inserted = []
			for city in input.cities
				if inserted.indexOf(city) >= 0 then continue
				inserted.push city
				list[city] = 
					address: city
			api.geoCode list, (result) ->
				#now we have all the city in a list with their coords
				#the algorithm is here
				mystify result, input.days, (result) ->
					return cb result
		mock: ->
			fake = [
				{
					day: 1
					city:
						name: 'London'
						address: 'London, United Kingdom'
						photo: 'http://i.telegraph.co.uk/multimedia/archive/02423/london_2423609b.jpg'
					attractions: [
						{
							name: 'London Eye'
							duration: 2
							address: 'Riverside Bldg, County Hall Westminster Bridge Rd London SE1 7PB, United Kingdom'
							photo: 'http://cdn.londonandpartners.com/asset/20adda9d08e8480c6dbbfcf30fbcabdb.jpg'
						}
						{
							name: 'The National Gallery'
							duration: 8
							address: 'Trafalgar Square London WC2N 5DN United Kingdom'
							photo: 'http://ichef.bbci.co.uk/arts/yourpaintings/images/collections/main/NG_collection_image_1.jpg'
						}
					]
				}
			]
			return fake
