describe 'Content blocks service', ->
	$q = null
	$rootScope = null
	$http = null
	service = null
	factory = null
	manifestMocks = null
	deferred = null

	beforeEach ->
		module 'sp.core', ($provide) ->
			$provide.provider '$http', ->
				@$get = ->
					get: (options) ->
						deferred = $q.defer()
						deferred.promise
				@
			null

	beforeEach ->
		inject (_$q_, _$rootScope_, _$http_, _ContentBlockService_, _ContentBlockFactory_, _ContentBlockManifestMocks_) ->
			$q = _$q_
			$rootScope = _$rootScope_
			$http = _$http_
			service = _ContentBlockService_
			factory = _ContentBlockFactory_
			manifestMocks = _ContentBlockManifestMocks_

	it 'is injected', ->
		expect(service).not.toBe(null)

	describe 'getSlugManifest function', ->
		manifest = null

		describe 'when slugs are not cached', ->
			beforeEach ->
				manifest = null
				service.slugManifest = null
				spyOn($http, 'get').and.callThrough()
				service.getSlugManifest().then (_manifest) ->
					manifest = _manifest
				deferred.resolve(manifestMocks.basic)
				$rootScope.$digest()

			it 'should request a manifest of unique slugs from the server if not cached', ->
				expect($http.get).toHaveBeenCalled()

			it 'should return an associative array of unique slugs and block ids', ->
				expect(manifest).toEqual(manifestMocks.basic)

			it 'should be cached after requesting', ->
				expect(service.slugManifest).toEqual(manifest)

		describe 'when slugs are cached', ->

			beforeEach ->
				manifest = null
				service.slugManifest = manifestMocks.basic
				spyOn($http, 'get').and.callThrough()
				service.getSlugManifest().then (_manifest) ->
					manifest = _manifest
				deferred.resolve(manifestMocks.basic)
				$rootScope.$digest()

			it 'should return the manifest of slugs from the cache', ->
				expect($http.get).not.toHaveBeenCalled()
				expect(manifest).toEqual(manifestMocks.basic)


	describe 'slugCache', ->

		it 'should exist', ->
			expect(service.slugCache).not.toBe(null)

		beforeEach ->
			service.slugCache.removeAll()
			service.slugCache.put(factory.basicBlock)

		describe 'get function', ->
			it 'returns an object', ->
				expect(service.slugCache.get(factory.basicBlock.slug) instanceof Object).toBe(true)

		describe 'getVersion function when passed a version', ->
			it 'returns a block with a given slug and version', ->
				expect(service.slugCache.getVersion(factory.basicBlock.slug, factory.basicBlock.version)).toBe(factory.basicBlock)

		describe 'getNewestPublished function', ->
			beforeEach ->
				service.slugCache.removeAll()
				service.slugCache.put factory.basicPublishedV3
				service.slugCache.put factory.basicUnpublishedV4
				service.slugCache.put factory.basicPublishedV2				

			it 'returns a promise that resolves to the published block with the highest version for a given slug', ->
				promise = service.slugCache.getNewestPublished(factory.basicPublishedV2.slug)
				expect(promise.$$state.value).toBe(factory.basicPublishedV3)
				
