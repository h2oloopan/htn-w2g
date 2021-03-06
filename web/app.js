// Generated by CoffeeScript 1.7.1
var folder, http, server;

http = require('http');

server = require('node-static');

folder = new server.Server('./', {
  cache: false
});

http.createServer(function(req, res) {
  return req.addListener('end', function() {
    return folder.serve(req, res);
  }).resume();
}).listen(3000);
