/* Exports an object that defines
 *  all of the paths & globs that the project
 *  is concerned with.
 *
 * The "configure" task will require this file and
 *  then re-initialize the grunt config such that
 *  directives like <config:files.js.app> will work
 *  regardless of the point you're at in the build
 *  lifecycle.
 *
 * You can find the parent object in: node_modules/lineman/config/files.coffee
 */

module.exports = require(process.env['LINEMAN_MAIN']).config.extend('files', {
  js: {
    vendor: [
      "vendor/bower/jquery/jquery.js",
			"vendor/bower/jquery-ui/jquery-ui.js",
			"vendor/bower/jquery-ui/jquery-scrollTo-min.js",
      "vendor/bower/bootstrap/dist/js/bootstrap.js",
      "vendor/bower/angular/angular.js",
	  	"vendor/bower/angular-resource/angular-resource.js",
			"vendor/bower/angular-sanitize/angular-sanitize.js",
      "vendor/bower/angular-bootstrap/angular-bootstrap.js",
      "vendor/bower/angular-ui-router/release/angular-ui-router.js",
      "vendor/bower/ng-grid/ng-grid-2.0.7.min.js ",
      "vendor/js/**/*.js"
    ],
    app: [
      "app/js/app.js",
      "app/js/**/*.js"
    ]
  },
  css: {
    vendor: [
      "vendor/bower/bootstrap/dist/css/bootstrap.css",
      "vendor/bower/ng-grid/ng-grid.css"
    ]
  }
});
