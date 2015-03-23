angular.module('sp.core').factory 'SlugCache', ['Util', '$http', '$cacheFactory', '$q', (Util, $http, $cacheFactory, $q) ->
	cache = $cacheFactory('blocksBySlug')
	angular.extend(cache, {
		requested: {}
		idCache: null
		
		oldPut: cache.put
		put: (block) ->
			if (versions = @get(block.slug))?
				versions[block.version] = block
			else
				versions = {}
				versions[block.version] = block
				@oldPut block.slug, versions
			angular.forEach @requested[block.slug], (deferred) ->
				deferred.resolve(block)
			delete @requested[block.slug]
			
		getVersion: (slug, version) ->
			@get(slug)[version]
		
		getNewestPublished: (slug) ->
			deferred = $q.defer()
			promise = deferred.promise
			if Object.keys(@requested).indexOf(slug) > -1
				@requested[slug].push(deferred)
			else if @get(slug)?
				versions = Object.keys(@get(slug)).sort (a,b) ->
					b - a
				block = null
				for version in versions
					block = @get(slug)[version]
					if block.status == 'published'
						break
				deferred.resolve(block)
			else
				@requested[slug] = [deferred]
				promise = $http({url: Util.url("/content_blocks"), method: "GET", params: {slug: slug, includeUnpublished: false}, headers: {'Accept': 'application/json'}})
					.then (response) ->
						if response.data.length > 0 && response.data[0]
							block = response.data[0]
							cache.put(block)
							cache.idCache.put(block.id, block)
						block
					, (error) ->
						console.log error
			promise
	})
	cache
]