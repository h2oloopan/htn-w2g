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
