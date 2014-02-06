all: tools/d3 tools/backbone tools/underscore tools/jquery

tools/d3:
	bin/setup_d3.sh

tools/backbone:
	bin/setup_backbone.sh

tools/underscore:
	bin/setup_underscore.sh

tools/jquery:
	bin/setup_jquery.sh

clean:
	rm -rf externals/
	rm -rf tools/
	rm -rf client_src/js/d3.js client_min/js/d3.js
	rm -rf client_src/js/backbone.js client_min/js/backbone.js
	rm -rf client_src/js/underscore.js client_min/js/underscore.js
	rm -rf client_src/js/jquery.js client_min/js/jquery.js
