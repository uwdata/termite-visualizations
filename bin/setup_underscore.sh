#!/bin/bash

EXTERNALS_PATH=externals
TOOLS_PATH=tools

if [ ! -d "client_src" ]
then
	echo "Usage: bin/setup_underscore.sh"
	echo "    Download and set up Underscore javascript library."
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

function __setup_underscore__ {
	EXTERNALS_SUBPATH=$EXTERNALS_PATH/underscore-1.5.2
	TOOLS_SUBPATH=$TOOLS_PATH/underscore-1.5.2
	SYMLINK_SUBPATH=$TOOLS_PATH/underscore
	SYMLINK=underscore-1.5.2
	
	echo "# Downloading Underscore..."
	if [ ! -f "$EXTERNALS_SUBPATH/underscore-1.5.2.zip" ]
	then
		__create_folder__ $EXTERNALS_SUBPATH "    "
		curl --insecure --location https://github.com/jashkenas/underscore/archive/1.5.2.zip > $EXTERNALS_SUBPATH/underscore-1.5.2.zip
		echo "    Extracting license..."
		unzip $EXTERNALS_SUBPATH/underscore-1.5.2.zip underscore-1.5.2/LICENSE -d $EXTERNALS_SUBPATH &&\
			mv $EXTERNALS_SUBPATH/underscore-1.5.2/LICENSE $EXTERNALS_SUBPATH &&\
			rmdir $EXTERNALS_SUBPATH/underscore-1.5.2
	else
		echo "    Already downloaded: $EXTERNALS_SUBPATH/underscore-1.5.2.zip"
	fi
	echo

	echo "# Setting up Underscore..."
	if [ ! -d "$TOOLS_SUBPATH" ]
	then
		__create_folder__ $TOOLS_SUBPATH "    "
		echo "    Uncompressing..."
		unzip $EXTERNALS_SUBPATH/underscore-1.5.2.zip underscore-1.5.2/underscore.js -d $TOOLS_SUBPATH &&\
		unzip $EXTERNALS_SUBPATH/underscore-1.5.2.zip underscore-1.5.2/underscore-min.js -d $TOOLS_SUBPATH &&\
			mv $TOOLS_SUBPATH/underscore-1.5.2/underscore.js $TOOLS_SUBPATH &&\
			mv $TOOLS_SUBPATH/underscore-1.5.2/underscore-min.js $TOOLS_SUBPATH/underscore.min.js &&\
			rmdir $TOOLS_SUBPATH/underscore-1.5.2
		ln -s $SYMLINK $SYMLINK_SUBPATH
	else
		echo "    Already available: $TOOLS_SUBPATH"
	fi
	echo
}

__create_folder__ $EXTERNALS_PATH
__create_folder__ $TOOLS_PATH
__setup_underscore__
