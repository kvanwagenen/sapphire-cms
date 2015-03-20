describe 'spInclude directive', ->
	beforeEach module 'sp.client', ($provide) ->
		$provide.provider 'ContentBlockService', ->
			@$get = ->
				{}
			@
		null

	$compile = null
	$rootScope = null

	beforeEach ->
		inject (_$compile_, _$q_, _$rootScope_) ->
			$compile = _$compile_
			$q = _$q_
			$rootScope = _$rootScope_

	describe 'when passed a slug parameter', ->
		it 'replaces the element with the body of the block returned by the content block service', ->
			element = $compile("<sp-include></sp-include>") $rootScope

			expect(true).toEqual(false)


	# it 'requests the block with the given slug from the content block service', ->
	# 	expect(true).toEqual(false)

	# it 'replaces itself in the DOM with the block body'
	# 	expect(true).toEqual(false)
