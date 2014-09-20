http = require 'http'
server = require 'node-static'
folder = new server.Server './',
	cache: false


http.createServer (req, res) ->
	req.addListener 'end', ->
		folder.serve req, res
	.resume()
.listen 3000