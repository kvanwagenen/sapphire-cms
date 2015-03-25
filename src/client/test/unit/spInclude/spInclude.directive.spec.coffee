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
					deferred.resolve(factory[slug])
					deferred.promise
			@
		null

	beforeEach ->
		inject (_$compile_, _$q_, _$rootScope_, _ContentBlockMocks_) ->
			$compile = _$compile_
			$q = _$q_
			$rootScope = _$rootScope_
			factory = _ContentBlockMocks_

	describe 'with a slug attribute', ->
		element = null
		beforeEach ->
			element = $compile("<div><sp-include slug=\"#{factory.wrap.slug}\"></sp-include></div>")($rootScope)
			$rootScope.$apply()

		describe 'and a block without a layout', ->
			it 'replaces the element with the body of the block of the given slug', ->
				compiled = factory.wrap.body.slice().replace("<sp-include slug=\"wrapped\"></sp-include>", factory.wrapped.body)
				expect(element.html().replace(/\s*class="ng-scope"/g, "")).toEqual compiled

			it 'compiles and links the body of the block included', ->
				expect(element.html().indexOf('wrapped-header')).toBeGreaterThan(-1)

		describe 'and a block with a layout', ->
			it 'injects the block into it\'s layout if set', ->
				element = $compile("<div><sp-include slug=\"#{factory.withLayout.slug}\"></sp-include></div>")($rootScope)
				$rootScope.$digest()
				expect(element.html().indexOf('I\'m a layout')).toBeGreaterThan(-1)
