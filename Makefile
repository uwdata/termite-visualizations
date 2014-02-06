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
