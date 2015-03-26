angular.module('sp.core').factory "ContentBlockService", ['Util', '$http', '$cacheFactory', '$q', 'SlugCache', 'RouteManifest', (Util, $http, $cacheFactory, $q, SlugCache, RouteManifest) ->
	service =
		idCache: $cacheFactory('blocksById')
		slugCache: SlugCache
		routeManifest: RouteManifest

		get: (params=null, page=null, pageSize=null) ->
			$http({url: Util.url("/content_blocks"), method: "GET", params: params, headers: {'Accept': 'application/json'}})
				.then (response) ->
					response.data

		find: (id) ->
			block = null
			if block = service.idCache.get(id)	
				deferred = $q.defer()			
				deferred.resolve(block)
				deferred.promise
			else
				$http({url: Util.url("/content_blocks/#{id}"), method: "GET", headers: {'Accept': 'application/json'}})
					.then (response) ->
						if response.data
							block = response.data
							service.idCache.put(id, block)
							service.slugCache.put(block)
						block
					, (error) ->
						console.log error

		getNewestPublished: (slug) ->
			service.slugCache.getNewestPublished slug	

		getRouteManifest: ->
			if !@routeManifest?
				$http.get(Util.url("/content_blocks/routes"))
					.then (manifest) ->
						service.routeManifest = manifest
						manifest
			else
				deferred = $q.defer()
				deferred.resolve(@routeManifest)
				deferred.promise

		save: (block) ->
			if block.id
				service.update(block)
			else
				service.create(block)

		update: (block) ->
			$http.put(Util.url("/content_blocks/#{block.id}"), block)
				.then (response) ->
					response.data
		create: (block) ->
			$http.post(Util.url("/content_blocks"), block)
				.then (response) ->
					response.data

		destroy: (block) ->
			$http.delete(Util.url("/content_blocks/#{block.id}"))
				.then (response) ->
					response.data

		init: ->
			@slugCache.idCache = @idCache
			@

	service.init()
]