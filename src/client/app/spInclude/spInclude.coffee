angular.module('sp.client').directive 'SpInclude', ['ContentBlockService', '$animate', '$sce', (ContentBlockService, $animate, $sce) ->
	restrict: 'A'
	priority: 400
	terminal: true
	replace: true
	scope: 
		slug: 
]