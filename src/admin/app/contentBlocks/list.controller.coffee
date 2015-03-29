SapphireAdmin.controller "ContentBlocksController", ["$scope", "ContentBlockService", "$location", ($scope, ContentBlockService, $location) ->
	ContentBlockService.get().then (data) ->
		$scope.contentBlocks = data

	$scope.destroy = (block) ->
		ContentBlockService.destroy(block)
			.then (data) ->
				toRemove = $scope.contentBlocks.indexOf(block)
				$scope.contentBlocks.splice(toRemove, 1)
	$scope.duplicate = (block) ->
		new_block = angular.copy(block)
		delete new_block.id
		new_block.version = new_block.version + 1
		new_block.status = "unpublished"
		ContentBlockService.create(new_block)
			.then (data) ->
				$location.path("/content-blocks/#{data.id}/edit")
]