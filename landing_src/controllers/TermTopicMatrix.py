#!/usr/bin/env python

from core import TermiteCore

def index():
	core = TermiteCore( request, response )
	return core.GenerateResponse({
		'js_files' : [
			"js/TermTopicMatrix/CoreModel.js",
			"js/TermTopicMatrix/CoreView.js",
			"js/TermTopicMatrix/MatrixState.js",
			"js/TermTopicMatrix/MatrixModel.js",
			"js/TermTopicMatrix/MatrixModel_Precomputations.js",
			"js/TermTopicMatrix/MatrixModel_Visibilities.js",
			"js/TermTopicMatrix/MatrixModel_Styles.js",
			"js/TermTopicMatrix/MatrixModel_Values.js",
			"js/TermTopicMatrix/MatrixModel_Positions.js",
			"js/TermTopicMatrix/MatrixModel_AnnotationControls.js",
			"js/TermTopicMatrix/MatrixModel_SelectionGroups.js",
			"js/TermTopicMatrix/MatrixInteractions.js",
			"js/TermTopicMatrix/MatrixView.js",
			"js/TermTopicMatrix/MatrixSelections.js"
		],
		'css_files' : [
			"css/TermTopicMatrix.css"
		],
		'visualization' : 'TermTopicMatrix'
	})
