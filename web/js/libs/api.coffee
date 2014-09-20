define ['jquery', 'utils'], ($, utils) ->
	#keys
	taKey = '379b8b313eaf439d92c521e5fe64a8ce'
	taUrl = 'http://api.tripadvisor.com/api/partner/2.0'
	gKey = 'AIzaSyC-5SLDR76m00GGODHxQ6gXGYtB4sXmP2s'
	geoUrl = 'https://maps.googleapis.com/maps/api/geocode/json?address='

	get = (url, done) ->
		$.ajax
			type: 'GET'
			url: url
			dataType: 'json'
		.done done
		.fail (a, b, c) ->
			console.log a
			console.log b
			console.log c

	return api =
		#awesome stuff is happening here
		geoCode: (list, cb) ->
			keys = utils.keys list
			total = keys.length
			for key in keys
				do (key) ->
					item = list[key]
					url = geoUrl + key + '&key=' + gKey
					get url, (result) ->
						location = result.results[0].geometry.location
						list[key].lat = location.lat
						list[key].lng = location.lng
						total--
						if total == 0 then cb list
			return

	 
		taLocation: (id, option, cb) ->
			if !cb?
				cb = option
				option = null
			#options are 'attractions', 'hotels', 'restaurants'
			url = taUrl + '/location/' + id
			if option? && option.type then url += '/' + option.type
			url += '?key=' + taKey
			if option? && option.subcategory then url += '&subcategory=' + option.subcategory
			if option? && option.limit then url += '&limit=' + option.limit
			if option? && option.offset then url += '&offset=' + option.offset

			if localStorage?
				value = localStorage.getItem url
				if value? then return cb JSON.parse(value)

			get url, (result) ->
				if localStorage?
					localStorage.setItem url, JSON.stringify result
				cb result


		taIds: (coords ,cb) ->
			@taMap coords, (result) ->
				ancestors = result.data[0].ancestors
				city = ancestors[0]
				country = ancestors[ancestors.length - 1]
				return cb 
					place:
						name: result.data[0].name
						id: result.data[0].location_id
					city: 
						name: city.name
						id: city.location_id
					country:
						name: country.name
						id: country.location_id


		taMapBox: (coords1, coords2, option, cb) ->
			if !cb?
				cb = option
				option = null

			url = taUrl + '/map/' + coords1.lat + ',' + coords1.lng + ',' + coords2.lat + ',' + coords2.lng
			if option? && option.type then url += '/' + option.type
			url += '?key=' + taKey
			if option? && option.subcategory then url += '&subcategory=' + option.subcategory

			if localStorage?
				value = localStorage.getItem url
				if value? then return cb JSON.parse(value)

			get url, (result) ->
				if localStorage?
					localStorage.setItem url, JSON.stringify result
				cb result

		taMap: (coords, option, cb) ->
			if !cb?
				cb = option
				option = null
			#options are 'attractions', 'hotels', 'restaurants'
			url = taUrl + '/map/' + coords.lat + ',' + coords.lng
			if option? && option.type then url += '/' + option.type
			url += '?key=' + taKey
			if option? && option.subcategory then url += '&subcategory=' + option.subcategory

			if localStorage?
				value = localStorage.getItem url
				if value? then return cb JSON.parse(value)

			get url, (result) ->
				if localStorage?
					localStorage.setItem url, JSON.stringify result
				cb result







