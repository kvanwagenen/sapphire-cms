angular.module('sp.admin').directive 'SpAceHtmlEditor', [()->
	restrict: 'A'
	replace: true
	scope:
		theme: "chrome"
	controller: ($scope) ->
		
]