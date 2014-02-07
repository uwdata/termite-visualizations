all: client_src/js/d3.js client_src/js/backbone.js client_src/js/underscore.js client_src/js/jquery.js client_src/css/font-awesome.css tools/closure tools/yui web2py

tools/d3:
	bin/setup_d3.sh

tools/backbone:
	bin/setup_backbone.sh

tools/underscore:
	bin/setup_underscore.sh

tools/jquery:
	bin/setup_jquery.sh

tools/font-awesome:
	bin/setup_fontawesome.sh

tools/closure:
	bin/setup_closure.sh

tools/yui:
	bin/setup_yui.sh

web2py:
	bin/setup_web2py.sh

client_src/js/d3.js client_min/js/d3.js: tools/d3
	cp tools/d3/d3.js client_src/js/d3.js
	cp tools/d3/d3.min.js client_min/js/d3.js

client_src/js/backbone.js client_min/js/backbone.js: tools/backbone
	cp tools/backbone/backbone.js client_src/js/backbone.js
	cp tools/backbone/backbone.min.js client_min/js/backbone.js

client_src/js/underscore.js client_min/js/underscore.js: tools/underscore
	cp tools/underscore/underscore.js client_src/js/underscore.js
	cp tools/underscore/underscore.min.js client_min/js/underscore.js

client_src/js/jquery.js client_min/js/jquery.js: tools/jquery
	cp tools/jquery/jquery.js client_src/js/jquery.js
	cp tools/jquery/jquery.min.js client_min/js/jquery.js

client_src/css/font-awesome.css client_min/css/font-awesome.css: tools/font-awesome
	cp tools/font-awesome/css/font-awesome.css client_src/css/font-awesome.css
	cp tools/font-awesome/css/font-awesome.min.css client_min/css/font-awesome.css
	cp -r tools/font-awesome/fonts client_src/
	cp -r tools/font-awesome/fonts client_min/
	cp -r tools/font-awesome/less client_src/
	cp -r tools/font-awesome/less client_min/
	cp -r tools/font-awesome/scss client_src/
	cp -r tools/font-awesome/scss client_min/
	
clean:
	rm -r externals/
	rm -r tools/
	rm client_src/js/d3.js client_min/js/d3.js
	rm client_src/js/backbone.js client_min/js/backbone.js
	rm client_src/js/underscore.js client_min/js/underscore.js
	rm client_src/js/jquery.js client_min/js/jquery.js
	rm client_src/css/font-awesome.css client_min/css/font-awesome.css
	rm -r client_src/fonts/ client_min/fonts/
	rm -r client_src/less/ client_min/less/
	rm -r client_src/scss/ client_min/scss/
	
