angular.module('sp.admin').directive 'spAceHtmlEditor', [()->
	restrict: 'A'
	replace: true
	scope:
		theme: "chrome"
	controller: ($scope) ->
		
]