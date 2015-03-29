AceEditorController = [ '$scope', ($scope) ->
	@editor = null

	$scope.onAceLoaded = (_editor) ->
		# Save editor
		@editor = _editor

		# Editor part
		_session = _editor.getSession();
		_renderer = _editor.renderer;

		# Options
		_editor.setReadOnly false
		_session.setUndoManager new ace.UndoManager()
		_renderer.setShowGutter true

		# Events
		_editor.on "changeSession", ->
		_session.on "change", ->

		if $scope? && $scope.block?
			_editor.setValue($scope.block.body)

	$scope.onAceChanged = (e) ->
		$scope.block.body = @editor.getValue()

	$scope.$watch 'block', (block) ->
		if @editor?
			@editor.setValue(block.body)
]

angular.module('sp.admin').controller 'AceEditor', AceEditorController