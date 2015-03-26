describe 'spView directive', ->
	$spRoute = null
	$compile = null
	$rootScope = null
	mocks = null
	$q = null
	deferred = null

	beforeEach module 'sp.client', ($provide) ->
		$provide.provider 'ContentBlockService', ->
			@$get = ->
				find: (id) -> 
					deferred = $q.defer()
					deferred.resolve(mocks.basicBlock)
					deferred.promise
				getNewestPublished: (slug) ->
					deferred = $q.defer()
					deferred.resolve(mocks.basicBlock)
					deferred.promise
			@
		null

	beforeEach ->
		inject (_$compile_, _$q_, _$rootScope_, _$spRoute_, _ContentBlockMocks_) ->
			$compile = _$compile_
			$q = _$q_
			$rootScope = _$rootScope_
			$spRoute = _$spRoute_
			mocks = _ContentBlockMocks_

	beforeEach ->
		$spRoute.current = 
			blockId: mocks.basicBlock.id

	element = null
	beforeEach ->
		element = $compile("<sp-view></sp-view>")($rootScope)
		$rootScope.$apply()

	it 'sets its contents to the body of the block in the current route on $spRouteChangeSuccess', ->
		$rootScope.$broadcast('$spRouteChangeSuccess')
		$rootScope.$apply()
		expect(element.html().replace(/\s*class="ng-scope"/g, "")).toEqual(mocks.basicBlock.body)

