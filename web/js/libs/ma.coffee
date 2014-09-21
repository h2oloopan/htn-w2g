define ['jquery', 'api', 'utils'], ($, api, utils) ->
	#helper
	mn = 
		distance:
			lat: 1
			lng: 2
		threshold: 4.0
		hours: 12
		defaultDuration: 3
		extraDay: 1

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
		console.log data

		#algorithm handling
		start = stops.start
		end = stops.end
		days = stops.days
		cities = []
		inserted = []
		names = utils.keys data.cities
		duration = 0
		for name in names
			attractions = data.cities[name]
			find = false
			if stops.list?
				keys = utils.keys stops.list
				for key in keys
					if stops.list[key].name == name
						duration = stops.list[key].stay
						if !duration? then duration = Math.round attractions.length / mn.threshold
						find = true
						break
				if !find then duration = Math.round attractions.length / mn.threshold
			else
				duration = Math.round attractions.length / mn.threshold
			if duration == 0 then duration = 1

			max = mn.extraDay + Math.round attractions.length / mn.threshold
			if duration > max then duration = max

			city =
				name: name
				duration: duration
				address: attractions[0].location_string
				must: find
				score: 0
				attractions: []

			totalHours = mn.hours * duration
			currentHours = 0
			for attraction in attractions
				if attraction.subcategory[1]? then cost = ma.attractions.durations[attraction.subcategory[1].name]
				if !cost? then cost = ma.attractions.durations[attraction.subcategory[0].name]
				if !cost? then cost = mn.defaultDuration
				if currentHours + cost > totalHours then break
				attraction.duration = cost
				currentHours += cost
				city.attractions.push attraction
				city.score += attraction.score

			cities.push city

		cities.sort (a, b) ->
			return b.score - a.score

		cityDuration = (cities) ->
			total = 0
			for city in cities
				total += city.duration
			return total

		for j in [0...cities.length]
			if cityDuration(cities) <= days then break
			p = cities.pop()
			if p.must then cities.unshift p

		#then list city from start to end
		sortedCities = []
		startCity = null
		endCity = null
		for city in cities
			lat = city.attractions[0].latitude
			lng = city.attractions[0].longitude
			if city.name == start.name 
				startCity = city
				continue
			else if city.name == end.name
				endCity = city
				continue
			city.distance = (lat - start.lat) * (lat - start.lat) * (lng - start.lng) * (lng - start.lng)
			sortedCities.push city

		sortedCities.sort (a, b) ->
			return a.distance - b.distance

		sortedCities.unshift startCity
		sortedCities.push endCity

		trip = 
			cities: sortedCities
			ranks: data.ranks
		return cb trip

	mystify = (list, days, options, cb) ->
		categorize = (preferences) ->
			if preferences?
				qs = ''
				for p in preferences
					qs += p + ','
				qs = qs.substr 0, qs.length - 1
				return qs
			else
				return null

		if !cb?
			cb = options
			options = null
		if !options? then options = {}
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
				end = list[keys[number - 1]]
				todo = number * 2
				attractions = []

				for i in [0...number]
					api.taIds
						lat: list[keys[i]].lat
						lng: list[keys[i]].lng
					, (result) ->
						api.taLocation result.city.id, 
							type: 'attractions'
							subcategory: categorize options.preferences
						, (result) ->
							for item in result.data
								attractions.push item
							todo--
							if todo == 0 then awesomify {start: start, end: end, days: days, list: list}, attractions, cb
						api.taLocation result.country.id,
							type: 'attractions'
							subcategory: categorize options.preferences
						, (result) ->
							for item in result.data
								attractions.push item
							todo--
							if todo == 0 then awesomify {start: start, end: end, days: days, list: list}, attractions, cb

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
				'other': 5
				'nightlife': 5
				'shopping': 4
				'bars': 3
				'clubs': 3
				'food_drink': 2
				'ranch_farm': 3
				'adventure': 6
				'gear_rentals': 3
				'wellness_spas': 3
				'class': 2
				'sightseeing_tours': 8
				'performances': 4
				'sports': 4
				'outdoors': 6
				'amusement': 4
				'landmarks': 3
				'zoos_aquariums': 3
				'museums': 6
				'cultural': 4
			times:
				'other': 0
				'nightlife': 5
				'shopping': 3
				'bars': 4
				'clubs': 4
				'food_drink': 4
				'ranch_farm': 2
				'adventure': 2
				'gear_rentals': 2
				'wellness_spas': 3
				'classes': 2
				'sightseeing_tours': 1
				'performances': 5
				'sports': 5
				'outdoors': 2
				'amusement': 4
				'landmarks': 2
				'zoos_aquariums': 4
				'museums': 2
				'cultural': 2

		
		search: (input, cb) ->
			options =
				preferences: input.preferences || ['adventure', 'outdoors', 'landmarks', 'museums', 'cultural']
				stays: input.stays
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
				if options.stays?
					counter = 0
					keys = utils.keys result
					for key in keys
						result[key].stay = options.stays[counter]
						counter++
				mystify result, input.days, options, (result) ->
					api.saveTrip result.cities, (id) ->
						for i in [0...result.cities.length]
							for j in [0...result.cities[i].attractions.length]
								result.cities[i].attractions[j] = JSON.parse result.cities[i].attractions[j]
						localStorage.setItem id, JSON.stringify result
						console.log result
						cb id
		load: (id) ->
			return JSON.parse localStorage.getItem(id)





