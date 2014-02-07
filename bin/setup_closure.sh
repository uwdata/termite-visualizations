#!/bin/bash

EXTERNALS_PATH=externals
TOOLS_PATH=tools

if [ ! -d "client_src" ] || [ ! -d "landing_src" ]
then
	echo "Usage: bin/setup_closure.sh"
	echo "    Download and set up Closure compiler."
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

function __setup_closure__ {
	EXTERNALS_SUBPATH=$EXTERNALS_PATH/closure-latest
	TOOLS_SUBPATH=$TOOLS_PATH/closure

	echo "# Downloading Closure..."
	if [ ! -d "$EXTERNALS_SUBPATH" ]
	then
		__create_folder__ $EXTERNALS_SUBPATH
		curl --insecure --location http://dl.google.com/closure-compiler/compiler-latest.zip > $EXTERNALS_SUBPATH/compiler-latest.zip
		echo "    Extracting license..."
		unzip $EXTERNALS_SUBPATH/compiler-latest.zip COPYING -d $EXTERNALS_SUBPATH &&\
			mv $EXTERNALS_SUBPATH/COPYING $EXTERNALS_SUBPATH/LICENSE
		echo "You may delete downloaded files in this folder without affecting the topic model visualizations." > $EXTERNALS_SUBPATH/safe-to-delete.txt
	else
		echo "    Already downloaded: $EXTERNALS_SUBPATH/compiler-latest.zip"
	fi
	echo

	echo "# Setting up Closure..."
	if [ ! -d "$TOOLS_SUBPATH" ]
	then
		__create_folder__ $TOOLS_SUBPATH "    "
		echo "    Uncompressing..."
		unzip $EXTERNALS_SUBPATH/compiler-latest.zip compiler.jar -d $TOOLS_SUBPATH
	else
		echo "    Already available: $TOOLS_SUBPATH"
	fi
	echo
}

__create_folder__ $EXTERNALS_PATH
__create_folder__ $TOOLS_PATH
__setup_closure__
