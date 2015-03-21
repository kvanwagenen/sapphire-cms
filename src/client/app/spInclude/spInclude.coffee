SpIncludeDirective = ['ContentBlockService', '$animate', '$sce', (ContentBlockService, $animate, $sce) ->
	restrict: 'EA'
	priority: 400
	terminal: true
	replace: false
	template: "<div>SpInclude Placeholder Template</div>"
	controller: angular.noop
	scope: 
		slug: '@'
	compile: (element, attrs) ->
		# Post-link function
		(scope, element, attrs) ->
			scope.$watch 'slug', (slug) ->
				ContentBlockService.findBySlug(slug)
					.then (block) ->
						element.replaceWith(block.body)
					, (err) ->

]

angular.module('sp.client').directive 'spInclude', SpIncludeDirective