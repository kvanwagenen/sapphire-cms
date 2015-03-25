describe 'UrlMatcherFactory', ->

	UrlMatcher = null

	beforeEach ->
		module 'sp.client'

	beforeEach ->
		inject (_UrlMatcher_) ->
			UrlMatcher = _UrlMatcher_

	describe 'checkMatch function', ->

		it 'matches with no parameter', ->
			match = UrlMatcher.checkMatch('/home', '/home')
			expect(match).not.toBeNull()

		it 'matches with a simple id parameter', ->
			match = UrlMatcher.checkMatch('/products/1', '/products/:id')
			expect(match).not.toBeNull()

	describe 'getPathObj function', ->

		it 'returns the correct parameters for a simple id path', ->
			pathObj = UrlMatcher.getPathObj('/products/1', '/products/:id')
			expect(pathObj.params["id"]).toEqual("1")

		it 'returns no parameters for a path without keys', ->
			pathObj = UrlMatcher.getPathObj('/about/history', '/about/history')
			expect(Object.keys(pathObj.params).length).toEqual(0)

		it 'returns the correct parameters if a path has two keys', ->
			pathObj = UrlMatcher.getPathObj('/products/1/attributes/name', '/products/:id/attributes/:attr')
			expect(pathObj.params["id"]).toEqual("1")
			expect(pathObj.params["attr"]).toEqual("name")