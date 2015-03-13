window.SapphireAdmin = angular.module 'sp.admin', ['ngRoute', 'sp.core', 'ui.ace']

SapphireAdmin.config ['$routeProvider', ($routeProvider) ->
	$routeProvider
		.when('/', {
			templateUrl: 'assets/content_blocks/list.html',
			controller: 'ContentBlocksController'
		})
		.when('/content-blocks', {
			templateUrl: 'assets/content_blocks/list.html',
			controller: 'ContentBlocksController'
		})
		.when('/content-blocks/:id/edit', {
			templateUrl: 'assets/content_blocks/edit.html',
			controller: 'ContentBlockEditController'
		})
		.when('/content-blocks/new', {
			templateUrl: 'assets/content_blocks/new.html',
			controller: 'ContentBlockNewController'
		})
]

SapphireAdmin.config ['$httpProvider', ($httpProvider) ->
	$httpProvider.defaults.headers.common['Accept'] = '*/*'

	$httpProvider.interceptors.push [->
		iso8601RegEx = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d+)?Z$/
		response: (response) ->
			convertDates = (obj) ->
 
            for key, value of obj
 
              #If it is a string of the expected form convert to date  
              type = typeof value
              if type is 'string' and iso8601RegEx.test value
                  obj[key] = new Date(value)
 
              #Recursively evaluate nested objects
              else if type is 'object'
                convertDates value
 
          convertDates response.data
 
          response
	]
]