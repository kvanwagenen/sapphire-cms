describe 'Content blocks service', ->
	beforeEach module('sp.core')

	service = null
	factory = null

	beforeEach ->
		inject (_$q_, _$rootScope_, _$http_, _ContentBlockService_, _ContentBlockFactory_) ->
			$q = _$q_
			$rootScope = _$rootScope_
			$http = _$http_
			service = _ContentBlockService_
			factory = _ContentBlockFactory_

	beforeEach ->

	it 'is injected', ->
		expect(service).not.toBe(null)

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

			it 'returns the published block with the highest version for a given slug', ->
				expect(service.slugCache.getNewestPublished(factory.basicPublishedV2.slug)).toBe(factory.basicPublishedV3)
