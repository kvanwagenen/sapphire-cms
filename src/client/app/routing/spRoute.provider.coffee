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

			# Match route to block
			angular.forEach RouteManifest, (blockId, route) ->
				if UrlMatcher.checkMatch($location.path(), route)
					nextRoute = UrlMatcher.getPathObj($location.path(), route)
					nextRoute = angular.extend(nextRoute, {blockId: blockId})

			if nextRoute && nextRoute.blockId
				$spRoute.current = nextRoute
				$rootScope.$emit('$spRouteChangeSuccess', nextRoute, lastRoute)

		$rootScope.$on '$locationChangeSuccess', commitRoute

		$spRoute
	]
	@

angular.module('sp.client').provider '$spRoute', $SpRouteProvider
