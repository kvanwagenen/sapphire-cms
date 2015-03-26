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
	service = 
		builder: 
			build: ($routeParams) ->
				service.buildForRoute($routeParams)

		buildForRoute: ($routeParams) ->
			# Get root slug if no slug parameter
			slug = $routeParams.slug || '/' 			
			@buildForSlug(slug)

		buildForSlug: (slug, toLayoutSlug) ->
			blocks = []

			compile = ->
				blocks.reverse()
				template = blocks[0].body
				blocks = blocks[1..-1]
				angular.forEach blocks, (block) ->
					template = template.replace("<sp-yield></sp-yield>", "<sp-yield data-layout=\"#{block.layout_block_slug}\">#{block.body}</sp-yield>")
				template
			
			getLayout = (layout_block_slug) ->
				ContentBlockService.getNewestPublished(layout_block_slug)
					.then (layout) ->
						if layout?
							block = layout
							blocks.push(layout)
							if block.layout_block_slug? and (block.layout_block_slug isnt toLayoutSlug)
								getLayout(block.layout_block_slug)

			ContentBlockService.getNewestPublished(slug)
				.then (block) ->
					blocks.push(block)
					if block.layout_block_slug? and (block.layout_block_slug isnt toLayoutSlug)
						getLayout(block.layout_block_slug)
							.then ->
								compile()
					else
						compile()

	service

angular
	.module('sp.client')
	.provider 'SpViewBuilder', SpViewBuilderProvider