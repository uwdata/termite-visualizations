#!/bin/bash

EXTERNALS_PATH=externals
TOOLS_PATH=tools

if [ ! -d "client_src" ] || [ ! -d "landing_src" ]
then
	echo "Usage: bin/setup_yui.sh"
	echo "    Download and set up YUI compiler."
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

function __setup_yui__ {
	EXTERNALS_SUBPATH=$EXTERNALS_PATH/yui-2.4.8
	TOOLS_SUBPATH=$TOOLS_PATH/yui-2.4.8
	SYMLINK_SUBPATH=$TOOLS_PATH/yui
	SYMLINK=yui-2.4.8

	echo "# Downloading YUI..."
	if [ ! -d "$EXTERNALS_SUBPATH" ]
	then
		__create_folder__ $EXTERNALS_SUBPATH
		curl --insecure --location https://github.com/yui/yuicompressor/archive/v2.4.8.zip > $EXTERNALS_SUBPATH/yuicompressor-2.4.8.zip
		echo "    Extracting license..."
		unzip $EXTERNALS_SUBPATH/yuicompressor-2.4.8.zip yuicompressor-2.4.8/LICENSE.TXT -d $EXTERNALS_SUBPATH &&\
			mv $EXTERNALS_SUBPATH/yuicompressor-2.4.8/LICENSE.TXT $EXTERNALS_SUBPATH &&\
			rmdir $EXTERNALS_SUBPATH/yuicompressor-2.4.8
		echo "You may delete downloaded files in this folder without affecting the topic model visualizations." > $EXTERNALS_SUBPATH/safe-to-delete.txt
	else
		echo "    Already downloaded: $EXTERNALS_SUBPATH/yuicompressor-2.4.8.zip"
	fi
	echo

	echo "# Setting up YUI..."
	if [ ! -d "$TOOLS_SUBPATH" ]
	then
		__create_folder__ $TOOLS_SUBPATH "    "
		echo "    Downloaind compiled binary..."
		curl --insecure --location https://github.com/yui/yuicompressor/releases/download/v2.4.8/yuicompressor-2.4.8.jar > $TOOLS_SUBPATH/yuicompressor.jar
		ln -s $SYMLINK $SYMLINK_SUBPATH
	else
		echo "    Already available: $TOOLS_SUBPATH"
	fi
	echo
}

__create_folder__ $EXTERNALS_PATH
__create_folder__ $TOOLS_PATH
__setup_yui__
