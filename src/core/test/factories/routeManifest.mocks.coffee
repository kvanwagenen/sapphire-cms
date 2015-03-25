RouteManifestMocks = ->
	basic: 
		'/products/:id': 1
		'/about-us': 2

angular.module('sp.core')
.factory 'RouteManifestMocks', RouteManifestMocks