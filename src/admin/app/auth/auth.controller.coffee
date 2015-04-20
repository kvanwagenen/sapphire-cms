AuthController = ['$scope', '$auth', '$location', ($scope, $auth, $location) ->
	$scope.userEmail = $auth.user.email
	$scope.signOut = ->
		$auth.signOut()
			.then ->
				$location.path('/login')
]

angular.module('sp.admin').controller 'AuthController', AuthController