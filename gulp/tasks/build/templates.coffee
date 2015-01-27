gulp = require 'gulp'
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
jade = require 'gulp-jade'
templateCache = require 'gulp-angular-templatecache'
path = require 'path'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'templates', ->
  gulp.src(PATHS.templates)
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))
    .pipe(jade({
      locals:
        GLOBALS: PUBLIC_GLOBALS
      pretty: true
    }))
    .on('error', notify.onError((error) -> error.message))

    .pipe(templateCache("app_templates.js", {
      module: GLOBALS.ANGULAR_APP_NAME
      base: (file) ->
        file.path
          .replace(path.resolve("./"), "")
          .replace("/app/", "")
    }))
    .pipe(gulp.dest(DESTINATIONS.scripts))
