// Karma configuration
// Generated on Thu Mar 05 2015 18:30:36 GMT+0000 (UTC)

module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '../',


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['jasmine'],


    // list of files / patterns to load in the browser
    files: [
      {pattern: 'test/bower_components/ace-builds/src-min-noconflict/ace.js'},
      {pattern: 'test/bower_components/angular/angular.js', included: true},
      {pattern: 'test/bower_components/angular-route/angular-route.js', included: true},
      {pattern: 'test/bower_components/angular-ui-router/release/angular-ui-router.js', included: true},
      {pattern: 'test/bower_components/angular-mocks/angular-mocks.js', included: true},
      {pattern: 'test/bower_components/angular-ui-ace/ui-ace.js'},
      {pattern: 'dist/**/*.js'},
      {pattern: '../sapphire-cms-spree/dist/**/*.js'},
      {pattern: 'src/admin/test/factories/**/*.coffee'},
      {pattern: 'src/admin/test/unit/**/*.js'},
      {pattern: 'src/admin/test/unit/**/*.coffee'},
      {pattern: 'src/client/test/**/*.js'},
      {pattern: 'src/client/test/**/*.coffee'},
      {pattern: 'src/core/test/**/*.js'},
      {pattern: 'src/core/test/**/*.coffee'},
      {pattern: '../sapphire-cms-spree/src/test/**/*.coffee'}
    ],


    // list of files to exclude
    exclude: [
    ],


    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
      '**/*.coffee': ['coffee']
    },

    coffeePreprocessor: {
      options: {
        bare: true,
        sourceMap: false
      },

      transformPath: function(path){
        return path.replace(/\.coffee$/, '.js');
      }
    },


    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['PhantomJS'],


    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false
  });
};
