describe 'Content blocks service', ->
	beforeEach module('sp.core')

	service = {}
	deferred = {}

	beforeEach ->
		inject (_$q_, _$rootScope_, _$http_) ->
			$q = _$q_
			$rootScope = _$rootScope_
			$http = _$http_

	beforeEach ->

	it 'has a passing test', ->
		expect(true).toEqual(true)