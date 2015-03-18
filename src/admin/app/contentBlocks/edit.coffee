SapphireAdmin.controller 'ContentBlockEditController', ['$scope', '$routeParams', 'ContentBlockService', "$location", "$window", ($scope, $routeParams, ContentBlockService, $location, $window) ->
	@editor = null

	ContentBlockService.find($routeParams.id)
		.then (data) ->
			$scope.block = data
			if @editor?
				@editor.setValue($scope.block.body)
	$scope.save = ->
		ContentBlockService.save($scope.block)
			.then (success) ->
				alert('Successfully saved!')
			, (err) ->
				alert('Error saving block')

	$scope.preview = ->
		ContentBlockService.save($scope.block)
			.then (success) ->
				$window.open("/#/#{$scope.block.slug}")
			, (err) ->
				alert('Can not preview')

	$scope.onAceLoaded = (_editor) ->
		# Save editor
		@editor = _editor

		# Editor part
		_session = _editor.getSession();
		_renderer = _editor.renderer;

		# Options
		_editor.setReadOnly false
		_session.setUndoManager new ace.UndoManager()
		_renderer.setShowGutter false

		# Events
		_editor.on "changeSession", ->
		_session.on "change", ->

		if $scope? && $scope.block?
			_editor.setValue($scope.block.body)

	$scope.onAceChanged = (e) ->
		$scope.block.body = @editor.getValue()

#	$scope.preview =
]