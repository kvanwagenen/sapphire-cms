describe('Content blocks edit controller', function(){

	beforeEach(module('sp.admin'));

	var $controller;
	var saveDeferred, findDeferred, getDeferred;

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
			},
			get: function(){
				getDeferred = $q.defer();
				return getDeferred.promise;
			}
		}
		$scope = {
			block: {
				key: "value"
			}
		};
		spyOn(contentBlockService, "find").and.callThrough();
		spyOn(contentBlockService, "save").and.callThrough();
		spyOn(contentBlockService, "get").and.callThrough();

		controller = $controller('ContentBlockEditController', {
			$scope: $scope,
			ContentBlockService: contentBlockService
		});
	});

	describe('on construction', function(){
		it('should call ContentBlockService.find and initialize $scope.block with the returned value', function(){
			expect(contentBlockService.find).toHaveBeenCalled();
			findDeferred.resolve({name: "name"})
			$rootScope.$apply();
			expect($scope.block).toEqual({name: "name"});
		});
		it('should load content blocks into the scope.', function(){
			expect(contentBlockService.get).toHaveBeenCalled();
			getDeferred.resolve([{name: "name"}]);
			$rootScope.$apply();
			expect($scope.contentBlocks).toEqual([{name: "name"}]);
		})
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
				$rootScope.$apply();
				expect(window.alert).toHaveBeenCalled();
			});

			it('should alert when save failed', function(){
				$scope.save();
				saveDeferred.reject();
				$rootScope.$apply();
				expect(window.alert).toHaveBeenCalled();
			});
		})		
	});

});