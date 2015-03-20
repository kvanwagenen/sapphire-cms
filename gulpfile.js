// Gulp and plugins
var gulp = require('gulp');
var gulpif = require('gulp-if');
var sass = require('gulp-sass');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var slim = require('gulp-slim');
var sourcemaps = require('gulp-sourcemaps');
var gulpcopy = require('gulp-copy');
var plumber = require('gulp-plumber');
// var debug = require('gulp-debug');
// var imagemin = require('gulp-imagemin'); // Removed because plugin doesn't work on Windows as a result of long paths

var argv = require('yargs').argv;
// var karma = require('karma').server;

var del = require('del');
var path = require('path');
var changeCase = require('change-case');

var localRailsEngineAssetsPath = "../sapphire_cms_rails/app/assets"

var files = {
  core: {
    js: ['src/core/app/**/*.coffee', 'src/core/app/**/*.js'],
    dist: {
      js: ['dist/core/sapphire-cms.core.js']
    }
  },
  client: {
    js: ['src/client/app/**/*.coffee', 'src/client/app/**/*.js'],
    css: ['src/client/**/*.scss', 'src/client/**/*.css'],
    dist: {
      js: ['dist/client/sapphire-cms.client.js']
    }
  },
  admin: {
    css: ['src/admin/**/*.scss', 'src/client/**/*.css'],
    js: ['src/admin/app/**/*.coffee', 'src/admin/app/**/*.js'],
    templates: ['src/admin/templates/**/*.html', 'src/admin/templates/**/*.slim'],
    dist: { 
      css: ['dist/admin/sapphire-cms.admin.css'],
      js: ['dist/admin/sapphire-cms.admin.js'],
      templates: ['dist/admin/templates/**/*']
    }
  }
};

var compileModuleCss = function(src, dest){
  return gulp.src(src)
    .pipe(plumber())
    .pipe(gulpif(/[.]scss$/, sass()))
    .pipe(concat(dest))
    .pipe(gulp.dest(path.join('dist')));
};

var compileModuleJs = function(src, dest){
  return gulp.src(src)
    .pipe(plumber())
    .pipe(gulpif(/[.]coffee$/, coffee()))
    .pipe(concat(dest))
    .pipe(gulp.dest(path.join('dist')));
};

var compileModuleTemplates = function(src, dest){
  return gulp.src(src)
    .pipe(plumber())
    .pipe(gulpif(/[.]slim$/, slim({
      pretty: true,
      options: "attr_list_delims={'(' => ')', '[' => ']'}"
    })))
    .pipe(gulp.dest(path.join('dist', dest)))
}

gulp.task('clean', function(cb) {
  del(['dist/**'], cb);
});

gulp.task('compile:core:js', function() {
  // Minify and copy all JavaScript (except vendor scripts)
  // with sourcemaps all the way down
  var stream = compileModuleJs(files.core.js, 'core/sapphire-cms.core.js');
  stream.on('end', function(){
    if(argv.syncToRails){
      gulp.start('copy:core:js:rails');
    }
  });
    // .pipe(sourcemaps.init())
    // .pipe(coffee())
    // .pipe(uglify())
    // .pipe(concat('all.min.js'))
    // .pipe(sourcemaps.write())
    // .pipe(gulp.dest('dist/js'));
});

gulp.task('compile:client:js', function() {
  var stream = compileModuleJs(files.client.js, 'client/sapphire-cms.client.js');
  stream.on('end', function(){
    if(argv.syncToRails){
      gulp.start('copy:client:js:rails');
    }
  });
});

gulp.task('compile:admin:js', function(){
  var stream = compileModuleJs(files.admin.js, 'admin/sapphire-cms.admin.js');
  stream.on('end', function(){
    if(argv.syncToRails){
      gulp.start('copy:admin:js:rails');
    }
  });
});

gulp.task('compile:admin:css', function(){
  var stream = compileModuleCss(files.admin.css, 'admin/sapphire-cms.admin.css');
  stream.on('end', function(){
    if(argv.syncToRails){
      gulp.start('copy:admin:css:rails');
    }
  });
});

gulp.task('compile:admin:templates', function(){
  var stream = compileModuleTemplates(files.admin.templates, 'admin/templates');
  stream.on('end', function(){
    if(argv.syncToRails){
      gulp.start('copy:admin:templates:rails');
    }
  });
});


// Tasks to sync files to neighboring sapphire_cms_rails Rails engine for development
var copyFilesToLocalRailsEngine = function(src, destDir){
  var prefix = 0;
  var wildCardIndex = src[0].indexOf('*');
  if(wildCardIndex >= 0){
    pathBeforeWildcard = src[0].slice(0,wildCardIndex);
    prefix = pathBeforeWildcard.split('/').length - 1;
  }else{
    prefix = src[0].split('/').length
  }
  return gulp.src(src)
    .pipe(gulpcopy(destDir, {
      prefix: prefix,

      // Change file leading directories to snake case for Rails
      destPath: function(path){
        var parts = path.split('/');
        var name = parts.pop();
        modifiedParts = [];
        parts.forEach(function(part){
          modifiedParts.push(changeCase.snakeCase(part));
        });
        modifiedParts.push(name);
        return modifiedParts.join('/');
      }
    }));
}

gulp.task('copy:admin:css:rails', function(){
  return copyFilesToLocalRailsEngine(files.admin.dist.css, path.join(localRailsEngineAssetsPath, 'stylesheets', 'sapphire_cms'));
})

gulp.task('copy:admin:js:rails', function(){
  return copyFilesToLocalRailsEngine(files.admin.dist.js, path.join(localRailsEngineAssetsPath, 'javascripts', 'sapphire_cms'));
});

gulp.task('copy:admin:templates:rails', function(){
  return copyFilesToLocalRailsEngine(files.admin.dist.templates, path.join(localRailsEngineAssetsPath, 'templates'));
});

gulp.task('copy:client:js:rails', function(){
  return copyFilesToLocalRailsEngine(files.client.dist.js, path.join(localRailsEngineAssetsPath, 'javascripts', 'sapphire_cms'));
});

gulp.task('copy:core:js:rails', function(){
  return copyFilesToLocalRailsEngine(files.core.dist.js, path.join(localRailsEngineAssetsPath, 'javascripts', 'sapphire_cms'));
});

gulp.task('copy:rails', function(){
  gulp.start('copy:admin:css:rails');
  gulp.start('copy:admin:js:rails');
  gulp.start('copy:admin:templates:rails');
  gulp.start('copy:client:js:rails');
  gulp.start('copy:core:js:rails');
});


gulp.task('compile:all', [
  'compile:admin:js',
  'compile:client:js', 
  'compile:core:js',
  'compile:admin:css',
  'compile:admin:templates'
]);

// gulp.task('test', function(doneCb){
//   karma.start({
//     configFile: __dirname + 'test/karma.conf.js',
//     autoWatch: false,
//     singleRun: true
//   }, doneCb);
// });

// Rerun the task when a file changes
gulp.task('watch', function() {
  gulp.watch(files.admin.js, ['compile:admin:js']);
  gulp.watch(files.admin.css, ['compile:admin:css']);
  gulp.watch(files.admin.templates, ['compile:admin:templates']);
  gulp.watch(files.client.js, ['compile:client:js']);
  gulp.watch(files.core.js, ['compile:core:js']);
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', ['watch', 'compile:all']);