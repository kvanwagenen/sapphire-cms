SpIncludeDirective = ['ContentBlockService', '$animate', '$sce', '$compile', (ContentBlockService, $animate, $sce, $compile) ->
	restrict: 'EA'
	priority: 400
	terminal: true
	replace: false
	controller: angular.noop
	scope:
		slug: '@'
	compile: (element, attrs) ->
		# Post-link function
		(scope, element, attrs, controller) ->
			scope.$watch 'slug', (slug) ->
				ContentBlockService.getNewestPublished(slug)
					.then (block) ->
						parent = element.parent()
						element.html(block.body)
						$compile(element.contents()) scope
						element.replaceWith(element.contents())
]

angular.module('sp.client').directive 'spInclude', SpIncludeDirective