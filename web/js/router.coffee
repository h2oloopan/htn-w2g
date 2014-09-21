define [], () ->
	Router = Backbone.Router.extend
		currentView: null
		routes:
			'': 'index'
			'result/:id': 'result'
		change: (view, options) ->
			if @currentView?
				@currentView.undelegateEvents()

			thiz = @
			require [view], (View) ->
				next = new View options
				thiz.currentView = next
				thiz.currentView.render()

		#views
		index: ->
			@change 'views/index'

		result: (id)->
			data = JSON.parse localStorage.getItem(id)
			@change 'views/result',
				data: data
