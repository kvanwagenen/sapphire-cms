AceEditorController = [ '$scope', ($scope) ->
	$scope.aceEditor = null

	$scope.onAceLoaded = (_editor) ->
		# Save editor
		$scope.aceEditor = _editor

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
		$scope.block.body = $scope.aceEditor.getValue()

	$scope.$watch 'block', (block) ->
		if $scope.aceEditor? && block? && block.body?
			$scope.aceEditor.setValue(block.body)
]

angular.module('sp.admin').controller 'AceEditor', AceEditorController