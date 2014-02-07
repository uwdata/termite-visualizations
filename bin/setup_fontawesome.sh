#!/bin/bash

EXTERNALS_PATH=externals
TOOLS_PATH=tools

if [ ! -d "client_src" ]
then
	echo "Usage: bin/setup_fontawesome.sh"
	echo "    Download and set up Font Awesome."
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

function __setup_fontawesome__ {
	EXTERNALS_SUBPATH=$EXTERNALS_PATH/font-awesome-4.0.3
	TOOLS_SUBPATH=$TOOLS_PATH/font-awesome-4.0.3
	SYMLINK_SUBPATH=$TOOLS_PATH/font-awesome
	SYMLINK=font-awesome-4.0.3
	
	echo "# Downloading Font Awesome..."
	if [ ! -f "$EXTERNALS_SUBPATH/font-awesome-4.0.3.zip" ]
	then
		__create_folder__ $EXTERNALS_SUBPATH "    "
		curl --insecure --location http://fontawesome.io/assets/font-awesome-4.0.3.zip > $EXTERNALS_SUBPATH/font-awesome-4.0.3.zip
	else
		echo "    Already downloaded: $EXTERNALS_SUBPATH/font-awesome-4.0.3.zip"
	fi
	echo

	echo "# Setting up Font Awesome..."
	if [ ! -d "$TOOLS_SUBPATH" ]
	then
		__create_folder__ $TOOLS_SUBPATH "    "
		echo "    Uncompressing..."
		unzip $EXTERNALS_SUBPATH/font-awesome-4.0.3.zip -d $TOOLS_PATH
		ln -s $SYMLINK $SYMLINK_SUBPATH
	else
		echo "    Already available: $TOOLS_SUBPATH"
	fi
	echo
}

__create_folder__ $EXTERNALS_PATH
__create_folder__ $TOOLS_PATH
__setup_fontawesome__
