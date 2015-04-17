angular.module('sp.core').controller 'SignUpController', ['$scope', '$auth', ($scope, $auth) ->
	$scope.signUp = ->
		$auth.submitRegistration($scope.signUpForm)
]