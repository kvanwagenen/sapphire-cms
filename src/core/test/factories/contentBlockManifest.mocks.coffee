ContentBlockManifestMocks = [ ->
	basic: 
		'/products/:id': 1
		'/about-us': 2
]

angular.module('sp.core')
.factory 'ContentBlockManifestMocks', ContentBlockManifestMocks