#!/bin/bash

EXTERNALS_PATH=externals
TOOLS_PATH=tools

if [ ! -d "client_src" ] || [ ! -d "landing_src" ]
then
	echo "Usage: bin/setup_d3.sh"
	echo "    Download and set up D3 javascript library."
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
	
	echo "# Downloading D3..."
	if [ ! -d "$EXTERNALS_SUBPATH" ]
	then
		__create_folder__ $EXTERNALS_SUBPATH "    "
		curl --insecure --location https://github.com/mbostock/d3/archive/v3.4.1.zip > $EXTERNALS_SUBPATH/d3-3.4.1.zip
		echo "    Extracting license..."
		unzip $EXTERNALS_SUBPATH/d3-3.4.1.zip d3-3.4.1/LICENSE -d $EXTERNALS_SUBPATH &&\
			mv $EXTERNALS_SUBPATH/d3-3.4.1/LICENSE $EXTERNALS_SUBPATH &&\
			rmdir $EXTERNALS_SUBPATH/d3-3.4.1
		echo "You may delete downloaded files in this folder without affecting the topic model visualizations." > $EXTERNALS_SUBPATH/safe-to-delete.txt
	else
		echo "    Already downloaded: $EXTERNALS_SUBPATH/d3-3.4.1.zip"
	fi
	echo

	echo "# Setting up D3..."
	if [ ! -d "$TOOLS_SUBPATH" ]
	then
		__create_folder__ $TOOLS_SUBPATH "    "
		echo "    Uncompressing..."
		unzip $EXTERNALS_SUBPATH/d3-3.4.1.zip d3-3.4.1/d3.js -d $TOOLS_SUBPATH &&\
		unzip $EXTERNALS_SUBPATH/d3-3.4.1.zip d3-3.4.1/d3.min.js -d $TOOLS_SUBPATH &&\
			mv $TOOLS_SUBPATH/d3-3.4.1/* $TOOLS_SUBPATH &&\
			rmdir $TOOLS_SUBPATH/d3-3.4.1
		ln -s $SYMLINK $SYMLINK_SUBPATH
	else
		echo "    Already available: $TOOLS_SUBPATH"
	fi
	echo
}

__create_folder__ $EXTERNALS_PATH
__create_folder__ $TOOLS_PATH
__setup_d3__
