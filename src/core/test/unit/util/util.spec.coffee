describe 'Util', ->

	beforeEach ->
		module('sp.core')

	Util = null
	Config = null
	
	beforeEach ->
		inject (_Util_, _Config_) ->
			Util = _Util_
			Config = _Config_

	describe 'url function', ->
		it 'adds the configured prefix to passed in urls', ->
			expect(Util.url("/path")).toEqual("#{Config.urlPrefix}/path")
