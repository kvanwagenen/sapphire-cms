angular.module('sp.core').factory "ContentBlockService", ['Util', '$http', '$cacheFactory', '$q', 'SlugCache', (Util, $http, $cacheFactory, $q, SlugCache) ->
	service =
		idCache: $cacheFactory('blocksById')
		slugCache: SlugCache

		get: (params=null, page=null, pageSize=null) ->
			$http({url: Util.url("/content_blocks"), method: "GET", params: params, headers: {'Accept': 'application/json'}})
				.then (response) ->
					response.data

		find: (id) ->
			block = null
			if block = service.idCache.get(id)				
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