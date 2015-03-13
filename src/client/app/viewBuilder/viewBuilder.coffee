###
# 
###

SpViewBuilderProvider = ->
	builder =
		build: ($routeParams) ->
			""
	@template = ($routeParams) ->
		builder.build($routeParams)
	@$get = ['ContentBlockService', (ContentBlockService) ->
		# Returns the view builder service
		return new SpViewBuilder(ContentBlockService, builder)
	]
	@

SpViewBuilder = (ContentBlockService, builder) ->
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
			ContentBlockService.find_by_slug(layout_block_slug)
				.then (layout) ->
					if layout?
						block = layout
						blocks.push(layout)
						if block.layout_block_slug?
							getLayout(block.layout_block_slug)

		ContentBlockService.find_by_slug(slug)
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