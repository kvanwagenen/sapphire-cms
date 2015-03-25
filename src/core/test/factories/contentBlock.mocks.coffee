angular.module('sp.core').factory 'ContentBlockMocks', ->
	basicBlock:
		id: 1
		title: "Basic Block"
		slug: "basic"
		body: "<h1>Basic Block Body</h1>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 1
		status: 'unpublished'
		layout_block_slug: null
	basicPublishedV3:
		title: "Published Block"
		slug: "basic"
		body: "<h1>Published Block Body</h1>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 3
		status: 'published'
		layout_block_slug: null
	basicPublishedV2:
		title: "Published Block"
		slug: "basic"
		body: "<h1>Published Block Body</h1>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 2
		status: 'published'
		layout_block_slug: null
	basicUnpublishedV4:
		title: "Published Block"
		slug: "basic"
		body: "<h1>Published Block Body</h1>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 4
		status: 'unpublished'
		layout_block_slug: null
	wrap:
		title: "Wrapping Block"
		slug: "wrap"
		body: "<h1>I should wrap</h1><sp-include slug=\"wrapped\"></sp-include>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 1
		status: 'published'
		layout_block_slug: null
	wrapped:
		title: "Wrapped Block"
		slug: "wrapped"
		body: "<h1 id=\"wrapped-header\">I should be wrapped</h1>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 1
		status: 'published'
		layout_block_slug: null
	withLayout:
		title: "Block with Layout"
		slug: "withLayout"
		body: "<h1>I should be in a layout</h1>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 1
		status: 'published'
		layout_block_slug: 'layout'
	layout:
		title: "Layout"
		slug: "layout"
		body: "<h1>I'm a layout</h1><sp-yield></sp-yield><footer>End of layout</footer>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 1
		status: 'published'
		layout_block_slug: null