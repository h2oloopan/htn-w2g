require.config
	baseUrl: 'js/libs'
	paths:
		templates: '../../templates'
		views: '../views'
		router: '../router'
		app: '../app'
		vender: '../vendor'
		gPlaces: 'http://maps.googleapis.com/maps/api/js?libraries=places'
	shim:
		'bootstrap': ['jquery']
		'backbone': ['underscore', 'jquery']
		'app': ['backbone', 'bootstrap']

require ['app'], (app) ->
	app.initialize()
