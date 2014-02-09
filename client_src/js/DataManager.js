(function(global) {
	var DataManager = Backbone.Model.extend({
		defaults : {
			http_host : null,
			server : "127.0.0.1:8075",
			isValidServer : false,
			dataset : null,
			datasets : [],
			visualization : null,
			visualizations : [],
			ghostVisualizations : [
				"DocumentViewer"
			]
		}
	});

	DataManager.prototype.initialize = function( options ) {
		this.refresh = _.debounce( this.__refresh, 50, false );
		this.setURLAndQueryString = _.debounce( this.__setURLAndQueryString, 10, false );
		this.view = new DataManagerView({ model : this });
		this.set( this.getQueryString() );
		this.refresh( false );
		this.on( "change:server change:dataset", this.refresh, this );
		this.on( "change:dataset change:visualization", this.setURLAndQueryString, this );
	};

	DataManager.prototype.getServerURL = function() {
		var server = this.get( "server" );
		var dataset = this.get( "dataset" );
		var url = "http://" + server;
		if ( dataset ) {
			url += "/" + dataset;
		}
		url += "?format=json"
		return url;
	};
	DataManager.prototype.getVisualizationURL = function() {
		var server = this.get( "server" );
		var dataset = this.get( "dataset" );
		var visualization = this.get( "visualization" );
		var url = "http://" + server;
		if ( dataset ) {
			url += "/" + dataset;
			if ( visualization ) {
				url += "/vis/" + visualization
			}
		}
		url += "?termLimit=1000&format=json"
		return url;
	};
	DataManager.prototype.url = DataManager.prototype.getServerURL;

	DataManager.prototype.__refresh = function( setURL ) {
		var success = function( model, response, options ) {
			var datasets = [];
			if ( response.configs.datasets ) {
				for ( var i = 0; i < response.configs.datasets.length; i++ ) {
					datasets.push( response.configs.datasets[i] );
				}
			}
			this.set({
				"isValidServer" : true,
				"server" : response.configs.server,
				"dataset" : ( response.configs.dataset === "init" ) ? null : response.configs.dataset,
				"datasets" : datasets
			});
			console.log( "Connected to data server: ", url );
			this.trigger( "loaded" );
			if ( setURL ) {
				this.setURLAndQueryString();
			}
		}.bind(this);
		var error = function( model, response, options ) {
			this.set({
				"isValidServer" : false,
				"dataset" : null,
				"datasets" : []
			});
			console.log( "[ERROR] Cannot connect to data server: ", url );
			this.trigger( "failed" );
			if ( setURL ) {
				this.setURLAndQueryString();
			}
		}.bind(this);
		var url = this.url();
		this.fetch({ success : success, error: error });
	};

	DataManager.prototype.__setURLAndQueryString = function() {
		var http_host = this.get( "http_host" );
		var server = this.get( "server" );
		var dataset = this.get( "dataset" );
		var visualization = this.get( "visualization" );
		var url = "http://" + http_host;
		if ( server && dataset ) {
			if ( visualization ) {
				url += "/vis/" + visualization;
			}
		}
		var query = [];
		if ( server ) {
			var server_split = server.split(":");
			if ( server_split.length === 1 ) {
				query.push( "s=" + escape(server) );
			}
			else {
				query.push( "s=" + escape(server_split[0]) );
				query.push( "p=" + escape(server_split[1]) );
			}
		}
		if ( dataset ) {
			query.push( "d=" + escape(dataset) );
		}
		if ( query.length > 0 ) {
			url += "?" + query.join("&");
		}
		if ( this.changed.hasOwnProperty( "visualization" ) ) {
			window.location.href = url;
		}
		else if ( visualization && this.changed.hasOwnProperty( "dataset" ) ) {
			window.location.href = url;
		}
		else {
			history.pushState( null, null, url );
		}
	};
	DataManager.prototype.getQueryString = function() {
		var queryString = window.location.search.substr(1);
		var s = null;
		var p = null;
		var d = null;
		var rePlus = /\+/g;
		var reKeysAndValues = /([^&=]+)=?([^&]*)/g;
		var decode = function ( str ) { return decodeURIComponent( str.replace( rePlus, " " ) ) };
		for ( var i = 0; i < 100; i++ ) {
			var match = reKeysAndValues.exec( queryString );
			if ( match ) {
				var key = decode( match[1] );
				var value = decode( match[2] );
				if ( key === "s" ) { s = value }
				if ( key === "p" ) { p = value }
				if ( key === "d" ) { d = value }
			}
			else {
				break;
			}
		}
		var queryKeysAndValues = {};
		if ( s ) {
			if ( p ) {
				queryKeysAndValues[ "server" ] = s + ":" + p;
			}
			else {
				queryKeysAndValues[ "server" ] = s;
			}
		}
		if ( d ) {
			queryKeysAndValues[ "dataset" ] = d;
		}
		return queryKeysAndValues;
	};

	var DataManagerView = Backbone.View.extend();

	DataManagerView.prototype.initialize = function() {
		this.layers = {};
		this.layers.server = d3.selectAll( ".ServerView" );
		this.layers.datasets = d3.selectAll( ".DatasetsView" );
		this.layers.visualizations = d3.selectAll( ".VisualizationsView" );
		this.layers.blocks = d3.selectAll( ".Blocks" );
		this.initServer();
		this.initDatasets();
		this.initVisualizations();
		this.initBlocks();
		this.model.on( "change:server change:isValidServer", this.updateServer, this );
		this.model.on( "change:dataset", this.updateDataset, this );
		this.model.on( "change:datasets", this.updateDatasets, this );
		this.model.on( "change:visualization", this.updateVisualization, this );
		this.model.on( "change:visualizations", this.updateVisualizations, this );
		this.model.on( "change:visualizations change:ghostVisualizations", this.updateBlocks, this );
	};

	DataManagerView.prototype.initServer = function() {
		this.layers.server.append( "input" )
			.style( "font-family", "Georgia, serif" )
			.style( "font-size", "11pt" )
			.style( "padding", "2px 5px" )
			.style( "border", "1px solid #999" )
			.style( "width", "125px" )
			.attr( "type", "text" )
			.on( "keyup", function() { this.setServer(d3.event.srcElement.value) }.bind(this) );
		this.updateServer();
	};
	DataManagerView.prototype.updateServer = function() {
		var server = this.model.get( "server" );
		var isValidServer = this.model.get( "isValidServer" );
		var dataset = this.model.get( "dataset" );
		this.layers.server.selectAll( "input" )
			.each( function() { d3.select(this).node().value = server } );
		d3.selectAll( ".ShowOnNoServer" ).style( "display", (!isValidServer) ? null : "none" );
		d3.selectAll( ".HideOnNoServer" ).style( "display", (!isValidServer) ? "none" : null );
		d3.selectAll( ".ShowOnNoDataset" ).style( "display", (!isValidServer && dataset===null) ? null : "none" );
		d3.selectAll( ".HideOnNoDataset" ).style( "display", (!isValidServer || dataset===null) ? "none" : null );
	};

	DataManagerView.prototype.initDatasets = function() {
		this.layers.datasets.append( "select" )
			.on( "change", function() { this.setDataset(d3.event.srcElement.value) }.bind(this) );
		this.updateDatasets();
	};
	DataManagerView.prototype.updateDatasets = function() {
		var dataset = this.model.get( "dataset" );
		var datasets = this.model.get( "datasets" );
		var select = this.layers.datasets.select( "select" );
		var elems = select.selectAll( "option" ).data( [null].concat(datasets) );
		elems.exit().remove();
		elems.enter().append( "option" );
		elems
			.attr( "selected", function(d) { return (d===dataset) ? "selected" : null } )
			.attr( "value", function(d) { return d ? d : "NONE" } )
			.html( function(d) { return d ? d : "&mdash; Dataset &mdash;" } );
		d3.selectAll( ".ShowOnNoDataset" ).style( "display", dataset ? "none" : null );
		d3.selectAll( ".HideOnNoDataset" ).style( "display", dataset ? null : "none" );
	};
	DataManagerView.prototype.updateDataset = function() {
		var dataset = this.model.get( "dataset" );
		this.layers.datasets.selectAll( "select" )
			.each( function() { d3.select(this).node().value = dataset ? dataset : "NONE" } );
		d3.selectAll( ".ShowOnNoDataset" ).style( "display", dataset ? "none" : null );
		d3.selectAll( ".HideOnNoDataset" ).style( "display", dataset ? null : "none" );
	};

	DataManagerView.prototype.initVisualizations = function() {
		this.layers.visualizations.append( "select" )
			.on( "change", function() { this.setVisualization(d3.event.srcElement.value) }.bind(this) );
		this.updateVisualizations();
	};
	DataManagerView.prototype.updateVisualizations = function() {
		var visualization = this.model.get( "visualization" );
		var visualizations = this.model.get( "visualizations" );
		var select = this.layers.visualizations.select( "select" );
		var elems = select.selectAll( "option" ).data( [null].concat(visualizations) );
		elems.exit().remove();
		elems.enter().append( "option" );
		elems
			.attr( "selected", function(d) { return (d===visualization) ? "selected" : null } )
			.attr( "value", function(d) { return d ? d : "NONE" } )
			.html( function(d) { return d ? d : "&mdash; Visualization &mdash;" } );
	};
	DataManagerView.prototype.updateVisualization = function() {
		var visualization = this.model.get( "visualization" );
		this.layers.visualizations
			.each( function() { d3.select(this).node().value = visualization ? visualization : "NONE" } );
	};

	DataManagerView.prototype.initBlocks = function() {
		this.updateBlocks();
	};
	DataManagerView.prototype.updateBlocks = function() {
		var visualization = this.model.get( "visualization" );
		var visualizations = this.model.get( "visualizations" );
		var ghostVisualizations = this.model.get( "ghostVisualizations" );
		var elems = this.layers.blocks.selectAll( "div.visualization" ).data( visualizations );
		var newElems = elems.enter().append( "div" )
			.attr( "class", "Block visualization" )
			.on( "click", function(d) { this.setVisualization(d) }.bind(this) )
			.on( "mouseover", function() { d3.select(this).style( "color", "#933" ).style( "border-color", "#933" ).select("img").style( "opacity", 0.4 ) } )
			.on( "mouseout", function() { d3.select(this).style( "color", null ).style( "border-color", null ).select("img").style( "opacity", 0.2 ) } )
			.append( "div" )
				.style( "position", "absolute" );
		newElems.append( "img" )
			.attr( "src", function() { return this.model.get("static").replace( "FILENAME", "images/TermTopicMatrix.png" ) }.bind(this) )
			.style( "position", "absolute" )
			.style( "opacity", 0.2 );
		newElems.append( "div" )
			.style( "position", "absolute" )
			.style( "padding", "12px" )
			.style( "font-weight", "bold" )
			.text( function(d) { return d } );
		var elems = this.layers.blocks.selectAll( "div.ghostVisualization" ).data( ghostVisualizations );
		var newElems = elems.enter().append( "div" )
			.attr( "class", "Block ghostVisualization" )
			.style( "color", "#ccc" )
			.style( "border-color", "#ccc" )
			.style( "cursor", "default" )
			.append( "div" )
				.style( "position", "absolute" );
		newElems.append( "div" )
			.style( "position", "absolute" )
			.style( "padding", "12px" )
			.style( "font-weight", "bold" )
			.text( function(d) { return d } );
	};

	DataManagerView.prototype.setServer = function( value ) {
		this.model.set( "server", value );
	};
	DataManagerView.prototype.setDataset = function( value ) {
		this.model.set( "dataset", value!=="NONE" ? value : null );
	};
	DataManagerView.prototype.setVisualization = function( value ) {
		this.model.set( "visualization", value!=="NONE" ? value : null );
	};

	global.DataManager = DataManager;
})(this);
