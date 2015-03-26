$SpRouteProvider = ->
	routes = {}

	@$get = ['$rootScope', '$location', 'UrlMatcher', 'RouteManifest', ($rootScope, $location, UrlMatcher, RouteManifest) ->
		$spRoute = {
			routes: routes
			blockId: null
			current: null
			previous: null
		}

		commitRoute = ->
			lastRoute = $spRoute.current
			nextRoute = null

			checkForNextRoute = (blockId, route, path) ->
				if !nextRoute? && UrlMatcher.checkMatch(path, route)
					nextRoute = UrlMatcher.getPathObj(path, route)
					nextRoute = angular.extend(nextRoute, {blockId: blockId})

			# Match route to block
			angular.forEach RouteManifest, (blockId, route) ->
				checkForNextRoute blockId, route, $location.path()
				if $location.path()[0] == '/'
					checkForNextRoute blockId, route, $location.path()[1..]

			if nextRoute && nextRoute.blockId
				$spRoute.current = nextRoute
				$rootScope.$emit('$spRouteChangeSuccess', nextRoute, lastRoute)

		$rootScope.$on '$locationChangeSuccess', commitRoute

		$spRoute
	]
	@

angular.module('sp.client').provider '$spRoute', $SpRouteProvider
