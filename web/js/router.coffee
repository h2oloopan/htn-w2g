define [], () ->
	Router = Backbone.Router.extend
		currentView: null
		routes:
			'': 'index'
		change: (view) ->
			if @currentView?
				@currentView.undelegateEvents()

			thiz = @
			require [view], (View) ->
				next = new View()
				thiz.currentView = next
				thiz.currentView.render()

		#views
		index: ->
			@change 'views/index'
