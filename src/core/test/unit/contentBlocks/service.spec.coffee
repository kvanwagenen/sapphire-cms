describe 'Content blocks edit controller', ->
	beforeEach module('sp.core')

	service = {}
	deferred = {}

	beforeEach ->
		inject (_$service_, _$q_, _$rootScope_, _$http_) ->
			$service = _$service
			$q = _$q_
			$rootScope = _$rootScope_
			$http = _$http_

	beforeEach ->


	it 'has a passing test', ->
		expect(true).toEqual(true)