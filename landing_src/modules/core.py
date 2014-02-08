#!/usr/bin/env python

import os
import json

class TermiteCore:
	def __init__( self, request, response ):
		self.request = request
		self.response = response
	
	def IsDebugMode( self ):
		return 'debug' in self.request.vars
	
	def GenerateResponse( self, keysAndValues = {} ):
		if self.IsDebugMode():
			return self.GenerateDebugResponse()
		else:
			return self.GenerateNormalResponse( keysAndValues )
	
	def GenerateDebugResponse( self ):
		def GetEnv( env ):
			data = {}
			for key in env:
				value = env[key]
				if isinstance( value, dict ) or \
				   isinstance( value, list ) or isinstance( value, tuple ) or \
				   isinstance( value, str ) or isinstance( value, unicode ) or \
				   isinstance( value, int ) or isinstance( value, long ) or isinstance( value, float ) or \
				   value is None or value is True or value is False:
					data[ key ] = value
				else:
					data[ key ] = 'N/A'
			return data
		
		info = {
			'env' : GetEnv( self.request.env ),
			'cookies' : self.request.cookies,
			'vars' : self.request.vars,
			'get_vars' : self.request.get_vars,
			'post_vars' : self.request.post_vars,
			'folder' : self.request.folder,
			'application' : self.request.application,
			'controller' : self.request.controller,
			'function' : self.request.function,
			'args' : self.request.args,
			'extension' : self.request.extension,
			'now' : str( self.request.now )
		}
		return json.dumps( info, encoding = 'utf-8', indent = 2, sort_keys = True )
	
	
	def GenerateNormalResponse( self, keysAndValues = {} ):
		data = {
			'http_host' : self.request.env['HTTP_HOST'],
			'js_files' : [],
			'css_files' : [],
			'visualizations' : [ 'TermTopicMatrix' ],
			'visualization' : None
		}
		data.update( keysAndValues )
		return data
