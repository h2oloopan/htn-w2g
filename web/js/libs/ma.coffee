define ['jquery'], ($) ->
	#keys
	taKey = '379b8b313eaf439d92c521e5fe64a8ce'
	taUrl = 'http://api.tripadvisor.com/api/partner/2.0'

	#helpers
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


	return ma =
		api:
			ta:
				location: (id, option, cb) ->
					if !cb?
						cb = option
						option = null
					#options are 'attractions', 'hotels', 'restaurants'
					url = taUrl + '/location/' + id
					if option? then url += '/' + option
					url += '?key=' + taKey
					get url, cb
				map: (coords, option, cb) ->
					if !cb?
						cb = option
						option = null
					#options are 'attractions', 'hotels', 'restaurants'
					url = taUrl + '/map/' + coords.lat + ',' + coords.long
					if option? then url += '/' + option
					url += '?key=' + taKey
					get url, cb
