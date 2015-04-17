angular.module 'sp.core', ['ng-token-auth']
angular.module('sp.core').config ['$authProvider', ($authProvider) ->
	$authProvider.configure
		apiUrl: '/sp'
]