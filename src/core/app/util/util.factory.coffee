angular.module('sp.core')
	.factory 'Util', ['Config', (Config) ->
		{
			url: (url) ->
				"#{Config.urlPrefix}#{url}"
		}
	]