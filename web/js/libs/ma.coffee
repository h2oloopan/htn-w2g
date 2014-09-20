define ['jquery', 'api', 'utils'], ($, api, utils) ->
	#algorithm
	mystify = (list, days, cb) ->
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
				api.taMapBox
					lat: start.lat
					lng: start.lng
				,
					lat: end.lat
					lng: end.lng
				,
					type: 'attractions' 
				, (result) ->
					console.log result

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
