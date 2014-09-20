require.config
	baseUrl: 'js/libs'
	paths:
		templates: '../../templates'
		views: '../views'
		router: '../router'
		app: '../app'
		vender: '../vendor'
	shim:
		'bootstrap': ['jquery']
		'backbone': ['underscore', 'jquery']
		'app': ['backbone', 'bootstrap']

require ['app'], (app) ->
	app.initialize()
