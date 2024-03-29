
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes');

var app = module.exports = express.createServer();
var nowjs = require('now');
var everyone = nowjs.initialize(app, {socketio: {transports:['xhr-polling','jsonp-polling']}});
// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'ejs');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// Routes

app.get('/', routes.index);

cache = [];
CACHE_SIZE = 10000;
//NOWJS CONFIG
everyone.now.distribute_draw = function(first, second, color, size) {
	if (cache.length > CACHE_SIZE)
		cache.shift();
		
	cache.push([first, second, color, size]);
	everyone.now.receive_draw(first, second, color, size);
}

nowjs.on('connect', function() {
	this.now.receive_initial_draw(cache);
});

app.listen(process.env.PORT);
console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
