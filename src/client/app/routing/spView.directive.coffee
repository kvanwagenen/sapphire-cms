SpViewDirective = ['$spRoute', '$anchorScroll', '$animate', 'ContentBlockService', 'SpViewBuilder', '$compile', ($spRoute, $anchorScroll, $animate, ContentBlockService, SpViewBuilder, $compile) ->
	restrict: 'ECA'
	terminal: true
	priority: 400
	transclude: 'element'
	controller: angular.noop
	template: "<h1>Test</h1>"
	link: (scope, $element, attributes, controller, $transclude) ->

		update = ->
			newScope = scope.$new()
			current = $spRoute.current
			if current && current.blockId
				ContentBlockService.find(current.blockId)
					.then (block) ->
						
						# Check if block has layout
						# layoutSlug = block.layout_block_slug
						# if layoutSlug?

						# 	# Does the layout exist in the current DOM?
						# 	layoutYieldEl = $element.find("sp-yield[layout=#{layoutSlug}")
						# 	if layoutYieldEl?

						# 		# Replace yield block contents with block body

						# 		# Compile
						# else
						$element.html(block.body)
						# $compile($element.contents()) scope
						$element

		scope.$on '$spRouteChangeSuccess', update
		update()
]

angular.module('sp.client').directive 'spView', SpViewDirective