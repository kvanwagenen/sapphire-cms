angular.module('sp.core').controller 'LoginController', ['$scope', '$auth', '$location', ($scope, $auth, $location) ->
	$scope.login = ->
		$auth.submitLogin($scope.loginForm)
			.then ->
				if $location.search().return_url?
					$location.path($location.search().return_url).search('return_url', null).replace()
				else
					$location.path('/').replace()
			, (err) ->
				alert "Invalid credentials!"
]