SapphireAdmin.controller 'ContentBlockNewController', ['$scope', '$location', 'ContentBlockService', ($scope, $location, ContentBlockService) ->
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
]