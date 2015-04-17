angular.module('sp.core').controller 'LoginController', ['$scope', '$auth', ($scope, $auth) ->
	$scope.login = ->
		$auth.submitLogin($scope.loginForm)
]