#!/bin/bash

EXTERNALS_PATH=externals
TOOLS_PATH=tools
SRC_PATH=client_src/js
MIN_PATH=client_min/js

if [ ! -d "client_src" ]
then
	echo "Usage: bin/setup_d3.sh"
	echo "    Download and set up D3 JavaScript Visualization Library."
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

function __setup_d3__ {
	EXTERNALS_SUBPATH=$EXTERNALS_PATH/d3-3.4.1
	TOOLS_SUBPATH=$TOOLS_PATH/d3-3.4.1
	SYMLINK_SUBPATH=$TOOLS_PATH/d3
	SYMLINK=d3-3.4.1
	
	echo "# Downloading D3 javascript library..."
	if [ ! -f "$EXTERNALS_SUBPATH/d3-3.4.1.zip" ]
	then
		__create_folder__ $EXTERNALS_SUBPATH "    "
		curl --insecure --location https://github.com/mbostock/d3/archive/v3.4.1.zip > $EXTERNALS_SUBPATH/d3-3.4.1.zip

		echo "    Extracting D3 license..."
		unzip $EXTERNALS_SUBPATH/d3-3.4.1.zip d3-3.4.1/LICENSE -d $EXTERNALS_SUBPATH &&\
			mv $EXTERNALS_SUBPATH/d3-3.4.1/LICENSE $EXTERNALS_SUBPATH &&\
			rmdir $EXTERNALS_SUBPATH/d3-3.4.1
	else
		echo "    Already downloaded: $EXTERNALS_SUBPATH/d3-3.4.1.zip"
	fi
	echo

	echo "# Setting up D3..."
	if [ ! -d "$TOOLS_SUBPATH" ]
	then
		__create_folder__ $TOOLS_SUBPATH "    "
		echo "    Uncompressing D3..."
		unzip $EXTERNALS_SUBPATH/d3-3.4.1.zip d3-3.4.1/d3.js -d $TOOLS_SUBPATH &&\
		unzip $EXTERNALS_SUBPATH/d3-3.4.1.zip d3-3.4.1/d3.min.js -d $TOOLS_SUBPATH &&\
			mv $TOOLS_SUBPATH/d3-3.4.1/* $TOOLS_SUBPATH &&\
			rmdir $TOOLS_SUBPATH/d3-3.4.1
		ln -s $SYMLINK $SYMLINK_SUBPATH
		ln -s ../../$SYMLINK_SUBPATH/d3.js $SRC_PATH/d3.js
		ln -s ../../$SYMLINK_SUBPATH/d3.min.js $MIN_PATH/d3.js
	else
		echo "    Already available: $TOOLS_SUBPATH"
	fi
	echo
}

__create_folder__ $EXTERNALS_PATH
__create_folder__ $TOOLS_PATH
__setup_d3__
