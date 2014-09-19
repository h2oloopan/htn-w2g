define ['router'], (Router) ->
	return app = 
		initialize: ->
			router = new Router()
			Backbone.history.start()

