angular.module('sp.core').factory 'ContentBlockFactory', ->
	basicBlock: 
		title: "Basic Block"
		slug: "basic"
		body: "<h1>Basic Block Body</h1>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 1
		status: 'unpublished'
		layoutBlockSlug: null
	basicPublishedV3:
		title: "Published Block"
		slug: "basic"
		body: "<h1>Published Block Body</h1>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 3
		status: 'published'
		layoutBlockSlug: null
	basicPublishedV2:
		title: "Published Block"
		slug: "basic"
		body: "<h1>Published Block Body</h1>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 2
		status: 'published'
		layoutBlockSlug: null
	basicUnpublishedV4:
		title: "Published Block"
		slug: "basic"
		body: "<h1>Published Block Body</h1>"
		createdAt: Date.now()
		updatedAt: Date.now()
		version: 4
		status: 'unpublished'
		layoutBlockSlug: null
