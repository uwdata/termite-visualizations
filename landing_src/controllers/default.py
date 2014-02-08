#!/usr/bin/env python

from core import TermiteCore

def index():
	core = TermiteCore( request, response )
	return core.GenerateResponse( {},
		{
			'css_files' : [],
			'js_files' : [ 'js/Home.js' ]
		}
	)