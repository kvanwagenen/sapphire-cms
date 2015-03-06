describe('Content blocks edit controller', function(){

	beforeEach(module('sp.admin'));

	var $controller;
	var deferred;

	beforeEach(inject(function(_$controller_, _$q_){
		$controller = _$controller_;
		$q = _$q_;
	}));

	beforeEach(function(){
		contentBlockService = {
			save: function(){},
			find: function(){}
		}
		$scope = {
			block: {
				key: "value"
			}
		};
		deferred = $q.defer();
		spyOn(contentBlockService, "find").and.returnValue($q.when({}));
		spyOn(contentBlockService, "save").and.returnValue(deferred.promise);
		controller = $controller('ContentBlockEditController', {
			$scope: $scope,
			ContentBlockService: contentBlockService
		});
	});

	describe('$scope.save', function(){
		it('should call save on the ContentBlockService', function(){
			$scope.save();
			expect(contentBlockService.save).toHaveBeenCalled();
		});

		describe('with an alert spy', function(){
			beforeEach(function(){
				window.alert = function(){console.log("alert");};
				spyOn(window, "alert");
			});

			it('should alert when successfully saved', function(){
				$scope.save();
				deferred.resolve();
				expect(window.alert).toHaveBeenCalled();
			});

			it('should alert when save failed', function(){
				$scope.save();
				deferred.reject();
				expect(window.alert).toHaveBeenCalled();
			});
		})		
	});

});