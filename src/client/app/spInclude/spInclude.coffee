angular.module('sp.client').directive 'SpInclude', ['ContentBlockService', '$animate', '$sce', (ContentBlockService, $animate, $sce) ->
	restrict: 'A'
	template: ""
	priority: 400
	scope: 
		slug: "home"
]