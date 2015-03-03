angular.module('sp.core').factory "ContentBlockService", ['$http', '$cacheFactory', '$q', ($http, $cacheFactory, $q) ->
	service =
		idCache: $cacheFactory('blocksById')
		slugCache: $cacheFactory('blocksBySlug')

		get: (params=null, page=null, pageSize=null) ->
			$http({url: "/sp/api/content_blocks", method: "GET", params: params, headers: {'Accept': 'application/json'}})
				.then (response) ->
					response.data

		find: (id) ->
			block = null
			if block = service.idCache.get(id)
				deferred = $q.defer()
				deferred.resolve(block)
				deferred.promise
			else
				$http({url: "/sp/api/content_blocks/#{id}", method: "GET", headers: {'Accept': 'application/json'}})
					.then (response) ->
						if response.data
							block = response.data
							service.idCache.put(id, block)
							service.slugCache.put(block.slug, block)
						block
					, (error) ->
						console.log error

		find_by_slug: (slug, includeUnpublished=false) ->
			block = null
			if block = service.slugCache.get(slug)
				deferred = $q.defer()
				deferred.resolve(block)
				deferred.promise
			else
				$http({url: "/sp/api/content_blocks", method: "GET", params: {slug: slug, includeUnpublished: includeUnpublished}, headers: {'Accept': 'application/json'}})
					.then (response) ->
						if response.data.length > 0 && response.data[0]
							block = response.data[0]
							service.slugCache.put(slug, block)
							service.idCache.put(block.id, block)
						block
					, (error) ->
						console.log error

		save: (block) ->
			if block.id
				service.update(block)
			else
				service.create(block)

		update: (block) ->
			$http.put("/sp/api/content_blocks/#{block.id}", block)
				.then (response) ->
					response.data
		create: (block) ->
			$http.post("/sp/api/content_blocks", block)
				.then (response) ->
					response.data

		destroy: (block) ->
			$http.delete("/sp/api/content_blocks/#{block.id}")
				.then (response) ->
					response.data

	service
]