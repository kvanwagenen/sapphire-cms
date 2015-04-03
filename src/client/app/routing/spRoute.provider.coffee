$SpRouteProvider = ->
	controllerDependencies = {}

	@addControllerDependencies = (controller, deps) ->
		controllerDependencies[controller] = deps

	@$get = ['$rootScope', '$q', '$injector', '$location', 'UrlMatcher', 'RouteManifest', 'ContentBlockService', ($rootScope, $q, $injector, $location, UrlMatcher, RouteManifest, ContentBlockService) ->
		preparedRoute = null

		$spRoute = {
			blockId: null
			block: null
			previous: null
			current: null
			nextRoute: null
			controllerDependencies: controllerDependencies
		}

		prepareRouteChange = ->
			routeFound = false

			checkForNextRoute = (blockId, route, path) ->
				if !routeFound && UrlMatcher.checkMatch(path, route)
					preparedRoute = UrlMatcher.getPathObj(path, route)
					preparedRoute = angular.extend(preparedRoute, {blockId: blockId})
					routeFound = true

			# Match route to block
			angular.forEach RouteManifest, (blockId, route) ->
				checkForNextRoute blockId, route, $location.path()
				if $location.path()[0] == '/'
					checkForNextRoute blockId, route, $location.path()[1..]

		commitRouteChange = ->
			$q.when(preparedRoute).then ->
				nextRoute = preparedRoute
				if nextRoute && nextRoute.blockId
					
					# Get new block
					ContentBlockService.find(nextRoute.blockId).then((routeBlock) ->

						# If block has controller with dependencies, resolve them
						deps = {}
						if routeBlock? && routeBlock.controller? && (deps = angular.copy($spRoute.controllerDependencies[routeBlock.controller]))?
							angular.forEach deps, (value, key) ->
								deps[key] = if angular.isString(value) then $injector.get(value) else $injector.invoke(value, null, null, key)
						$q.all(deps)
					).then (deps) ->
						angular.extend(nextRoute, {deps: deps})
						$spRoute.previous = $spRoute.current
						$spRoute.current = nextRoute
						$rootScope.$emit('$spRouteChangeSuccess', nextRoute, null)

		$rootScope.$on '$locationChangeStart', prepareRouteChange
		$rootScope.$on '$locationChangeSuccess', commitRouteChange

		$spRoute
	]
	@

angular.module('sp.client').provider '$spRoute', $SpRouteProvider
