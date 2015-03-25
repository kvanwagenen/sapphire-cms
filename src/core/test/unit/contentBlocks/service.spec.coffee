describe 'Content blocks service', ->
	$q = null
	$rootScope = null
	$http = null
	service = null
	mocks = null
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
		inject (_$q_, _$rootScope_, _$http_, _ContentBlockService_, _ContentBlockMocks_, _RouteManifestMocks_) ->
			$q = _$q_
			$rootScope = _$rootScope_
			$http = _$http_
			service = _ContentBlockService_
			mocks = _ContentBlockMocks_
			manifestMocks = _RouteManifestMocks_

	it 'is injected', ->
		expect(service).not.toBe(null)

	describe 'getRouteManifest function', ->
		manifest = null

		describe 'when routes are not cached', ->
			beforeEach ->
				manifest = null
				service.routeManifest = null
				spyOn($http, 'get').and.callThrough()
				service.getRouteManifest().then (_manifest) ->
					manifest = _manifest
				deferred.resolve(manifestMocks.basic)
				$rootScope.$digest()

			it 'should request a manifest of unique routes from the server if not cached', ->
				expect($http.get).toHaveBeenCalled()

			it 'should return an associative array of unique routes and block ids', ->
				expect(manifest).toEqual(manifestMocks.basic)

			it 'should be cached after requesting', ->
				expect(service.routeManifest).toEqual(manifest)

		describe 'when routes are cached', ->

			beforeEach ->
				manifest = null
				service.routeManifest = manifestMocks.basic
				spyOn($http, 'get').and.callThrough()
				service.getRouteManifest().then (_manifest) ->
					manifest = _manifest
				deferred.resolve(manifestMocks.basic)
				$rootScope.$digest()

			it 'should return the manifest of routes from the cache', ->
				expect($http.get).not.toHaveBeenCalled()
				expect(manifest).toEqual(manifestMocks.basic)


	describe 'slugCache', ->

		it 'should exist', ->
			expect(service.slugCache).not.toBe(null)

		beforeEach ->
			service.slugCache.removeAll()
			service.slugCache.put(mocks.basicBlock)

		describe 'get function', ->
			it 'returns an object', ->
				expect(service.slugCache.get(mocks.basicBlock.slug) instanceof Object).toBe(true)

		describe 'getVersion function when passed a version', ->
			it 'returns a block with a given slug and version', ->
				expect(service.slugCache.getVersion(mocks.basicBlock.slug, mocks.basicBlock.version)).toBe(mocks.basicBlock)

		describe 'getNewestPublished function', ->
			beforeEach ->
				service.slugCache.removeAll()
				service.slugCache.put mocks.basicPublishedV3
				service.slugCache.put mocks.basicUnpublishedV4
				service.slugCache.put mocks.basicPublishedV2				

			it 'returns a promise that resolves to the published block with the highest version for a given slug', ->
				promise = service.slugCache.getNewestPublished(mocks.basicPublishedV2.slug)
				expect(promise.$$state.value).toBe(mocks.basicPublishedV3)
				
