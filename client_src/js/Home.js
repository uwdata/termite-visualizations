var Home = Backbone.Model.extend({
	defaults : {
		server : "127.0.0.1:8075",
		dataset : null,
		datasets : [ null ]
	},
	url : function() {
		var server = this.get( "server" );
		var dataset = this.get( "dataset" );
		var url = "http://" + server;
		if ( dataset ) { url += "/" + dataset }
		url += "?format=json"
		return url;
	}
});

Home.prototype.initialize = function() {
	this.view = new HomeView({ model : this });
};

Home.prototype.load = function() {
	var success = function( model, response, options ) {
		var datasets = [ null ];
		if ( response.configs.datasets ) {
			for ( var i = 0; i < response.configs.datasets.length; i++ ) {
				datasets.push( response.configs.datasets[i] );
			}
		}
		this.set({
			"server" : response.configs.server,
			"dataset" : response.configs.dataset,
			"datasets" : datasets
		})
		console.log( "success" );
	}.bind(this);
	var error = function( model, response, options ) {
		console.log( "error" );
	}.bind(this);
	this.fetch({ success : success, error: error });
};

var HomeView = Backbone.View.extend();

HomeView.prototype.initialize = function() {
	this.setServer = _.debounce( this.__setServer, 50 );
	this.delaySetServer = _.debounce( this.setServer, 2500, false );
	this.layer = {};
	this.layer.server = d3.select( ".ServerView" );
	this.layer.datasets = d3.select( ".DatasetsView" )
	this.io = {};
	this.initServer();
	this.initDatasets();
	this.model.on( "change:server", this.updateServer, this );
	this.model.on( "change:dataset", this.updateDataset, this );
	this.model.on( "change:datasets", this.updateDatasets, this );
};

HomeView.prototype.initServer = function() {
	var layer = this.layer.server;
	this.io.server = layer.append( "input" )
		.attr( "type", "text" )
		.on( "keyup", this.delaySetServer.bind(this) );
	this.io.refresh = layer.append( "i" )
		.attr( "class", "fa fa-refresh" )
		.style( "margin", "0 5px" )
		.style( "font-size", "0.8em" )
		.style( "cursor", "pointer" )
		.on( "click", this.setServer.bind(this) );
	this.updateServer();
};

HomeView.prototype.updateServer = function() {
	var layer = this.layer.server;
	var server = this.model.get( "server" );
	layer.select( "input" ).node().value = server;
};

HomeView.prototype.initDatasets = function() {
	var layer = this.layer.datasets;
	this.io.dataset = layer.append( "select" )
		.on( "change", this.setDataset.bind(this) )
	this.updateDatasets();
};

HomeView.prototype.updateDatasets = function() {
	var layer = this.layer.datasets;
	var dataset = this.model.get( "dataset" );
	var datasets = this.model.get( "datasets" );
	var select = layer.select( "select" );
	var elems = select.selectAll( "option" ).data( datasets );
	elems.enter().append( "option" )
		.attr( "selected", function(d) { return d === dataset ? "selected" : null } )
		.attr( "value", function(d) { return (d===null) ? "NONE" : d } )
		.html( function(d) { return (d===null) ? "&mdash; Dataset &mdash;" : d } );
};

HomeView.prototype.updateDataset = function() {
	var dataset = this.model.get( "dataset" );
	this.io.dataset.node().value = dataset;
};

HomeView.prototype.__setServer = function() {
	var value = this.io.server.node().value;
	this.model.set( "server", value );
	this.model.load();
};

HomeView.prototype.setDataset = function() {
	var value = this.io.dataset.node().value;
	if ( value === "NONE" ) {
		this.model.set( "dataset", null );
	}
	else {
		this.model.set( "dataset", value );
	}
};
