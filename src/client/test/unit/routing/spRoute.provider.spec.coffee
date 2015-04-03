describe 'spRouteProvider', ->
	$rootScope = null
	$location = null
	$spRoute = null
	$httpBackend = null
	RouteManifest = null
	RouteManifestMocks = null
	ContentBlockMocks = null
	deferred = null

	beforeEach ->
		module 'sp.client', ($provide) ->

			$provide.provider 'ContentBlockService', ->
				@$get = ->
					find: (id) ->
						deferred = $q.defer()
						# deferred.resolve(ContentBlockMocks.basicBlock)
						deferred.promise
				@

			$provide.provider 'RouteManifest', ->
				@$get = ->
					'/products/:id': 1
					'/about-us': 2
				@
			$provide.provider '$location', ->
				@$get = ->
					currentPath: ""
					path: (path) ->
						if !path?
							@currentPath
						else
							@currentPath = path
							# $rootScope.$broadcast('$locationChangeStart')
							# $rootScope.$broadcast('$locationChangeSuccess')
				@
			null

	beforeEach ->
		inject (_$rootScope_, _$location_, _$spRoute_, _$httpBackend_, _RouteManifestMocks_, RouteManifest, _ContentBlockMocks_) ->
			$rootScope = _$rootScope_
			$location = _$location_
			$spRoute = _$spRoute_
			$httpBackend = _$httpBackend_
			RouteManifestMocks = _RouteManifestMocks_
			RouteManifest = _RouteManifestMocks_
			ContentBlockMocks = _ContentBlockMocks_

	describe 'commitRouteChange on $locationChangeSuccess', ->

		it 'broadcasts $spRouteChangeSuccess', ->
			called = false
			$rootScope.$on '$spRouteChangeSuccess', ->
				called = true
			$location.path('/about-us')
			$rootScope.$apply()
			$rootScope.$broadcast('$locationChangeStart')
			$rootScope.$apply()
			$rootScope.$broadcast('$locationChangeSuccess')
			$rootScope.$apply()
			deferred.resolve(ContentBlockMocks.basicBlock)
			$rootScope.$apply()
			expect(called).toBe(true)

		it 'sets the correct route on $spRoute', ->
			$location.path('/products/12')
			$rootScope.$apply()
			expect($spRoute.current.blockId).toEqual(1)
			expect($spRoute.current.params["id"]).toEqual("12")


		
