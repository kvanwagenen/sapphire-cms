###
# 
###

SpViewBuilderProvider = ->
	builder =
		build: ($routeParams) ->
			""
	@template = ($routeParams) ->
		builder.build($routeParams)
	@$get = ['ContentBlockService', '$urlMatcherFactory', (ContentBlockService, UrlMatcherFactory) ->
		# Returns the view builder service
		return new SpViewBuilder(ContentBlockService, UrlMatcherFactory, builder)
	]
	@

SpViewBuilder = (ContentBlockService, UrlMatcherFactory, builder) ->
	builder.build = ($routeParams) ->
		blocks = []

		# Get root slug if no slug parameter
		slug = if $routeParams.slug? then $routeParams.slug else '/' 

		compile = () ->
			blocks.reverse()
			template = blocks[0].body
			blocks = blocks[1..-1]
			angular.forEach blocks, (block) ->
				template = template.replace("<sp-yield></sp-yield>", block.body)
			template
		getLayout = (layout_block_slug) ->
			ContentBlockService.getNewestPublished(layout_block_slug)
				.then (layout) ->
					if layout?
						block = layout
						blocks.push(layout)
						if block.layout_block_slug?
							getLayout(block.layout_block_slug)

		ContentBlockService.getNewestPublished(slug)
			.then (block) ->
				blocks.push(block)
				if block.layout_block_slug?
					getLayout(block.layout_block_slug)
						.then ->
							compile()
				else
					compile()
	
	service = 
		builder: builder
	service

angular
	.module('sp.client')
	.provider 'SpViewBuilder', SpViewBuilderProvider