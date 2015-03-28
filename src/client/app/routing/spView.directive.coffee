SpViewDirective = ['$spRoute', '$anchorScroll', '$animate', 'ContentBlockService', 'SpViewBuilder', '$compile', ($spRoute, $anchorScroll, $animate, ContentBlockService, SpViewBuilder, $compile) ->
	restrict: 'ECA'
	terminal: true
	priority: 400
	controller: angular.noop
	link: (scope, $element, attributes, controller, $transclude) ->

		update = ->
			newScope = scope.$new()
			current = $spRoute.current
			if current && current.blockId
				ContentBlockService.find(current.blockId)
					.then (routeBlock) ->
						srcBlock = routeBlock
						$dstElement = $element

						buildView = ->
							# Build view up to but not including the layout block already in the DOM
							SpViewBuilder.buildForSlug(routeBlock.slug, srcBlock.layout_block_slug)
								.then (template) ->
									$dstElement.html(template)
									$compile($dstElement.contents()) scope

						findMergePoint = (block) ->
							if !block.layout_block_slug?
								srcBlock = block
								buildView()
							else if (yieldBlocks = $element.find("sp-yield[data-layout=#{block.layout_block_slug}]")).length > 0
								$dstElement = angular.element(yieldBlocks[0])
								srcBlock = block
								buildView()
							else
								ContentBlockService.getNewestPublished(block.layout_block_slug)
									.then (layoutBlock) ->
										findMergePoint(layoutBlock)
						findMergePoint(routeBlock)

						

		scope.$on '$spRouteChangeSuccess', update
		update()
]

angular.module('sp.client').directive 'spView', SpViewDirective