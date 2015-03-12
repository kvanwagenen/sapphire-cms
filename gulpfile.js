// Gulp and plugins
var gulp = require('gulp');
var gulpif = require('gulp-if');
var sass = require('gulp-sass');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var slim = require('gulp-slim');
var sourcemaps = require('gulp-sourcemaps');
// var imagemin = require('gulp-imagemin'); // Removed because plugin doesn't work on Windows as a result of long paths

var karma = require('karma').server;

var del = require('del');
var path = require('path');

var files = {
  core: {
    js: ['src/core/app/**/*.coffee', 'src/core/app/**/*.js']
  },
  client: {
    js: ['src/client/app/**/*.coffee', 'src/client/app/**/*.js'],
    css: ['src/client/**/*.scss', 'src/client/**/*.css']
  },
  admin: {
    css: ['src/admin/**/*.scss', 'src/client/**/*.css'],
    js: ['src/admin/app/**/*.coffee', 'src/admin/app/**/*.js'],
    templates: ['src/admin/templates/**/*.html', 'src/admin/templates/**/*.slim']
  }
};

var compileModuleCss = function(src, dest){
  return gulp.src(src)
    .pipe(gulpif(/[.]scss$/, sass()))
    .pipe(concat(dest))
    .pipe(gulp.dest(path.join('dist')));
};

var compileModuleJs = function(src, dest){
  return gulp.src(src)
    .pipe(gulpif(/[.]coffee$/, coffee()))
    .pipe(concat(dest))
    .pipe(gulp.dest(path.join('dist')));
};

var compileModuleTemplates = function(src, dest){
  return gulp.src(src)
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
  return compileModuleJs(files.core.js, 'core/sapphire-cms.core.js');
    // .pipe(sourcemaps.init())
    // .pipe(coffee())
    // .pipe(uglify())
    // .pipe(concat('all.min.js'))
    // .pipe(sourcemaps.write())
    // .pipe(gulp.dest('dist/js'));
});

gulp.task('compile:client:js', function() {
  return compileModuleJs(files.client.js, 'client/sapphire-cms.client.js');
});

gulp.task('compile:client:css', function(){
  return compileModuleCss(files.client.css, 'client/sapphire-cms.client.css');
});

gulp.task('compile:admin:js', function(){
  return compileModuleJs(files.admin.js, 'admin/sapphire-cms.admin.js');
});

gulp.task('compile:admin:css', function(){
  return compileModuleCss(files.admin.css, 'admin/sapphire-cms.admin.css');
});

gulp.task('compile:admin:templates', function(){
  return compileModuleTemplates(files.admin.templates, 'admin/templates');
});

gulp.task('compile:all', [
  'compile:admin:js',
  'compile:client:js', 
  'compile:core:js',
  'compile:admin:css',   
  'compile:client:css',
  'compile:admin:templates'
])

gulp.task('test', function(doneCb){
  karma.start({
    configFile: __dirname + 'test/karma.conf.js',
    autoWatch: false,
    singleRun: true
  }, doneCb);
});

// Rerun the task when a file changes
gulp.task('watch', function() {
  gulp.watch(files.core.js, ['compile:core:js']);
  gulp.watch(files.client.js, ['compile:client:js']);
  gulp.watch(files.admin.js, ['compile:admin:js']);
  gulp.watch(files.client.css, ['compile:client:css']);
  gulp.watch(files.admin.css, ['compile:admin:css']);
  gulp.watch(files.admin.templates, ['compile:admin:templates']);
});

// The default task (called when you run `gulp` from cli)
gulp.task('default', ['watch', 'compile:all']);