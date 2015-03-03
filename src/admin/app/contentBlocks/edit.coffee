SapphireAdmin.controller 'ContentBlockEditController', ['$scope', '$routeParams', 'ContentBlockService', ($scope, $routeParams, ContentBlockService) ->
	ContentBlockService.find($routeParams.id)
		.then (data) ->
			$scope.block = data
	$scope.save = ->
		ContentBlockService.save($scope.block)
			.then (success) ->
				alert('Successfully saved!')
			, (err) ->
				alert('Error saving block')					
]