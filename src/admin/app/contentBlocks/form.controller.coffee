SapphireAdmin.controller 'ContentBlockFormController', ['$scope', '$routeParams', 'ContentBlockService', '$window', '$location', ($scope, $routeParams, ContentBlockService, $window, $location) ->

	if $routeParams.id?
		ContentBlockService.find($routeParams.id)
			.then (data) ->
				$scope.block = data
		$scope.saveCaption = 'Save'
	else
		$scope.block = 
			title: null
			slug: null
			version: 1
			body: ""
			status: 'unpublished'
		$scope.saveCaption = 'Create'

	$scope.save = ->
		ContentBlockService.save($scope.block)
			.then (success) ->
				if $routeParams.id?
					alert('Successfully saved!')
				else
					$location.path('/#/content-blocks')
			, (err) ->
				alert('Error saving block')

	$scope.preview = ->
		ContentBlockService.save($scope.block)
			.then (success) ->
				$window.open("/#/#{$scope.block.slug}")
			, (err) ->
				alert('Unable to preview because there was an error when saving')
]