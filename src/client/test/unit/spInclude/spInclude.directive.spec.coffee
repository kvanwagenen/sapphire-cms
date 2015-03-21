describe 'spInclude directive', ->
	$compile = null
	$rootScope = null
	factory = null
	$q = null
	deferred = null

	beforeEach module 'sp.client', ($provide) ->
		$provide.provider 'ContentBlockService', ->
			@$get = ->
				findBySlug: (slug, version) -> 
					deferred = $q.defer()
					deferred.resolve(factory.basicBlock)
					deferred.promise
			@
		null

	beforeEach ->
		inject (_$compile_, _$q_, _$rootScope_, _ContentBlockFactory_) ->
			$compile = _$compile_
			$q = _$q_
			$rootScope = _$rootScope_
			factory = _ContentBlockFactory_

	describe 'when passed a slug parameter', ->
		it 'replaces the element with the body of the block returned by the content block service', ->
			element = $compile("<div><sp-include slug=\"#{factory.basicBlock.slug}\"></sp-include></div>")($rootScope)
			$rootScope.$apply()
			expect(element.html()).toEqual factory.basicBlock.body
