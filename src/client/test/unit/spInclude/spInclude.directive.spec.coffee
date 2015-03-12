describe 'spInclude directive', ->
	beforeEach module('sp.client')

	beforeEach ->
		inject (_$compile_, _$q_, _$rootScope_, _$http_) ->
			$compile = _$compile_
			$q = _$q_
			$rootScope = _$rootScope_
			$http = _$http_

	it 'expects a slug parameter', ->
		expect(true).toEqual(false)

	# it 'requests the block with the given slug from the content block service', ->
	# 	expect(true).toEqual(false)

	# it 'replaces itself in the DOM with the block body'
	# 	expect(true).toEqual(false)
