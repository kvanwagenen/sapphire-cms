SpIncludeDirective = ['ContentBlockService', 'SpViewBuilder', '$animate', '$sce', '$compile', (ContentBlockService, SpViewBuilder, $animate, $sce, $compile) ->
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
				SpViewBuilder.builder.build({slug: slug}).then (template) ->
					element.html(template)
					$compile(element.contents()) scope
					element.replaceWith(element.contents())
]

angular.module('sp.client').directive 'spInclude', SpIncludeDirective