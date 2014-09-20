define ['jquery', 'api', 'utils'], ($, api, utils) ->
	#helper
	test = (data) ->
		for entry in data
			console.log entry.address_obj.address_string + ' ' + entry.latitude + ' ' + entry.longitude

	#algorithm
	prepare = (attractions) ->
		result = {}
		#remove duplication and classify by city
		for attraction in attractions
			do (a) ->


		return result

	awesomify = (attractions, cb) ->
		console.log 'attractions to deal with'
		input = prepare attractions
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
						if todo == 0 then awesomify attractions, cb
					api.taLocation result.country.id,
						type: 'attractions'
						subcategory: subcategories
					, (result) ->
						for item in result.data
							attractions.push item
						todo--
						if todo == 0 then awesomify attractions, cb

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
						if todo == 0 then awesomify attractions, cb
					api.taLocation result.country.id,
						type: 'attractions'
						subcategory: subcategories
					, (result) ->
						for item in result.data
							attractions.push item
						todo--
						if todo == 0 then awesomify attractions, cb

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
