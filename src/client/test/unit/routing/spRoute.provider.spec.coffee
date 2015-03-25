describe 'spRouteProvider', ->
	$rootScope = null
	$location = null
	$spRoute = null
	RouteManifest = null
	RouteManifestMocks = null

	beforeEach ->
		module 'sp.client', ($provide) ->
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
							$rootScope.$broadcast('$locationChangeSuccess')
				@
			null

	beforeEach ->
		inject (_$rootScope_, _$location_, _$spRoute_, _RouteManifestMocks_, RouteManifest) ->
			$rootScope = _$rootScope_
			$location = _$location_
			$spRoute = _$spRoute_
			RouteManifestMocks = _RouteManifestMocks_
			RouteManifest = _RouteManifestMocks_

	describe 'commitRoute on $locationChangeSuccess', ->

		it 'broadcasts $spRouteChangeSuccess', ->
			called = false
			$rootScope.$on '$spRouteChangeSuccess', ->
				called = true
			$location.path('/about-us')
			$rootScope.$apply()
			expect(called).toBe(true)

		it 'sets the correct route on $spRoute', ->
			$location.path('/products/12')
			$rootScope.$apply()
			expect($spRoute.current.blockId).toEqual(1)
			expect($spRoute.current.params["id"]).toEqual("12")


		
