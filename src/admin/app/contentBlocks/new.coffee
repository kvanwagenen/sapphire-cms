SapphireAdmin.controller 'ContentBlockNewController', ['$scope', '$location', 'ContentBlockService', '$window', ($scope, $location, ContentBlockService, $window) ->
	$scope.block = 
		title: null
		slug: null
		version: 1
		body: null
		status: 'unpublished'
	$scope.save = ->
		ContentBlockService.save($scope.block)
			.then((data) ->
				$location.path('/content-blocks')
			, (err) ->
				alert('Error creating content block')
			)

	$scope.preview = ->
		ContentBlockService.save($scope.block)
			.then (success) ->
				$window.open("/#/#{$scope.block.slug}")
			, (err) ->
				alert('Unable to preview because there was an error when saving')
]