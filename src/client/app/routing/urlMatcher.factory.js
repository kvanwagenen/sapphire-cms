var UrlMatcherFactory = [function(){
  var factory = {
    pathExpObjCache: {},
    /**
    * @param path {string} path
    * @param opts {Object} options
    * @return {?Object}
    *
    * @description
    * Normalizes the given path, returning a regular expression
    * and the original path.
    *
    * Inspired by pathRexp in visionmedia/express/lib/utils.js.
    */
    pathRegExp: function(path, opts) {
      // var insensitive = opts.caseInsensitiveMatch,
      var insensitive = false, 
        ret = {
          originalPath: path,
          regexp: path
        },
        keys = ret.keys = [];

      path = path
        .replace(/([().])/g, '\\$1')
        .replace(/(\/)?:(\w+)([\?\*])?/g, function(_, slash, key, option) {
          var optional = option === '?' ? option : null;
          var star = option === '*' ? option : null;
          keys.push({ name: key, optional: !!optional });
          slash = slash || '';
          return ''
            + (optional ? '' : slash)
            + '(?:'
            + (optional ? slash : '')
            + (star && '(.+?)' || '([^/]+)')
            + (optional || '')
            + ')'
            + (optional || '');
        })
        .replace(/([\/$\*])/g, '\\$1');

      ret.regexp = new RegExp('^' + path + '$', insensitive ? 'i' : '');
      return ret;
    },

    checkMatch: function(path, pathExp){
      return this.getPathExpObj(path, pathExp).regexp.exec(path);
    },

    getPathExpObj: function(path, pathExp){
      if(!this.pathExpObjCache[pathExp]){
        this.pathExpObjCache[pathExp] = this.pathRegExp(pathExp);
      }
      return this.pathExpObjCache[pathExp];
    },

    getPathObj: function(path, pathExp){
      var pathExpObj = this.getPathExpObj(path, pathExp);
      params = {};
      var match = pathExpObj.regexp.exec(path);
      for(var i = 1, len = match.length; i < len; ++i){
        var key = pathExpObj.keys[i - 1];
        var val = match[i];
        if(key && val){
          params[key.name] = val;
        }
      }
      return angular.extend(angular.copy(pathExpObj), {params: params})
    }
  }
  return factory;
}]

angular.module('sp.client').factory('UrlMatcher', UrlMatcherFactory);