describe 'spInclude directive', ->
	$compile = null
	$rootScope = null
	factory = null
	$q = null
	deferred = null

	beforeEach module 'sp.client', ($provide) ->
		$provide.provider 'ContentBlockService', ->
			@$get = ->
				getNewestPublished: (slug, version) -> 
					deferred = $q.defer()
					if slug == 'wrap'
						deferred.resolve(factory.wrap)
					else
						deferred.resolve(factory.wrapped)
					deferred.promise
			@
		null

	beforeEach ->
		inject (_$compile_, _$q_, _$rootScope_, _ContentBlockFactory_) ->
			$compile = _$compile_
			$q = _$q_
			$rootScope = _$rootScope_
			factory = _ContentBlockFactory_

	describe 'with a slug attribute', ->
		element = null
		beforeEach ->
			element = $compile("<div><sp-include slug=\"#{factory.wrap.slug}\"></sp-include></div>")($rootScope)
			$rootScope.$apply()

		it 'replaces the element with the body of the block of the given slug', ->
			compiled = factory.wrap.body.slice().replace("<sp-include slug=\"wrapped\"></sp-include>", factory.wrapped.body)
			expect(element.html().replace(/\s*class="ng-scope"/g, "")).toEqual compiled

		it 'compiles and links the body of the block included', ->
			expect(element.html().indexOf('wrapped-header')).toBeGreaterThan(-1)