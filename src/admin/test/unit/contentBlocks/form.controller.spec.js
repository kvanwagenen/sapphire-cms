describe('Content blocks form controller', function(){

	beforeEach(module('sp.admin'));

	var $controller;
	var saveDeferred, findDeferred;

	beforeEach(inject(function(_$controller_, _$q_, _$rootScope_){
		$controller = _$controller_;
		$q = _$q_;
		$rootScope = _$rootScope_;
	}));

	beforeEach(function(){
		contentBlockService = {
			save: function(){
				saveDeferred = $q.defer();
				return saveDeferred.promise;
			},
			find: function(){
				findDeferred = $q.defer();
				return findDeferred.promise;
			}
		}
		$scope = {
			block: {
				key: "value"
			}
		};
		$routeParams = {
			id: "5"
		};
		spyOn(contentBlockService, "find").and.callThrough();
		spyOn(contentBlockService, "save").and.callThrough();
		controller = $controller('ContentBlockFormController', {
			$scope: $scope,
			$routeParams: $routeParams,
			ContentBlockService: contentBlockService
		});
	});

	describe('on construction', function(){
		it('should call ContentBlockService.find and initialize $scope.block with the returned value', function(){
			expect(contentBlockService.find).toHaveBeenCalled();
			findDeferred.resolve({name: "name"})
			$rootScope.$digest();
			expect($scope.block).toEqual({name: "name"});
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
				saveDeferred.resolve();
				$rootScope.$digest();
				expect(window.alert).toHaveBeenCalled();
			});

			it('should alert when save failed', function(){
				$scope.save();
				saveDeferred.reject();
				$rootScope.$digest();
				expect(window.alert).toHaveBeenCalled();
			});
		})		
	});

});