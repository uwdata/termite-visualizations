#!/bin/bash

EXTERNALS_PATH=externals
TOOLS_PATH=tools
SRC_PATH=client_src/js
MIN_PATH=client_min/js

if [ ! -d "client_src" ]
then
	echo "Usage: bin/setup_jquery.sh"
	echo "    Download and set up jQuery JavaScript Visualization Library."
	echo "    This script should be run from the root of the git repo."
	echo
	exit -1
fi

function __create_folder__ {
	FOLDER=$1
	TAB=$2
	if [ ! -d $FOLDER ]
	then
		echo "${TAB}Creating folder: $FOLDER"
		mkdir $FOLDER
	fi
}

function __setup_jquery__ {
	EXTERNALS_SUBPATH=$EXTERNALS_PATH/jquery-3.4.1
	TOOLS_SUBPATH=$TOOLS_PATH/jquery-3.4.1
	SYMLINK_SUBPATH=$TOOLS_PATH/jquery
	SYMLINK=jquery-3.4.1
	
	echo "# Downloading jQuery javascript library..."
	if [ ! -f "$EXTERNALS_SUBPATH/jquery-master.zip" ]
	then
		__create_folder__ $EXTERNALS_SUBPATH "    "
		curl --insecure --location https://github.com/mbostock/jquery/archive/v3.4.1.zip > $EXTERNALS_SUBPATH/jquery-3.4.1.zip

		echo "    Extracting jQuery license..."
		unzip $EXTERNALS_SUBPATH/jquery-3.4.1.zip jquery-3.4.1/MIT-LICENSE.txt -d $EXTERNALS_SUBPATH &&\
			mv $EXTERNALS_SUBPATH/jquery-3.4.1/MIT-LICENSE.txt $EXTERNALS_SUBPATH &&\
			rmdir $EXTERNALS_SUBPATH/jquery-3.4.1
	else
		echo "    Already downloaded: $EXTERNALS_SUBPATH/jquery-3.4.1.zip"
	fi
	echo

	echo "# Setting up jQuery..."
	if [ ! -d "$TOOLS_SUBPATH" ]
	then
		__create_folder__ $TOOLS_SUBPATH "    "
		echo "    Downloading compiled jQuery..."
		curl --insecure --location http://code.jquery.com/jquery-2.1.0.js > $TOOLS_SUBPATH/jquery.js
		curl --insecure --location http://code.jquery.com/jquery-2.1.0.min.js > $TOOLS_SUBPATH/jquery.min.js
		ln -s $SYMLINK $SYMLINK_SUBPATH
		ln -s ../../$SYMLINK_SUBPATH/jquery.js $SRC_PATH/jquery.js
		ln -s ../../$SYMLINK_SUBPATH/jquery.min.js $MIN_PATH/jquery.js
	else
		echo "    Already available: $TOOLS_SUBPATH"
	fi
	echo
}

__create_folder__ $EXTERNALS_PATH
__create_folder__ $TOOLS_PATH
__setup_jquery__
