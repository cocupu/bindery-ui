/* Exports an object that defines
 *  all of the configuration needed by the projects'
 *  depended-on grunt tasks.
 *
 * You can find the parent object in: node_modules/lineman/config/application.coffee
 */

module.exports = require(process.env['LINEMAN_MAIN']).config.extend('application', {
  watch: {
	  scripts: {
	    files: ["<%= files.js.app %>"],
			tasks: ['jshint'],
			    options: {
			      spawn: false,
			    }
	  },
	},
	concat_sourcemap: {
    js: {
      src: [
        "<%= files.js.vendor %>",
        "<%= files.coffee.generated %>",
        "<%= files.js.app %>",
        "<%= files.ngtemplates.dest %>"
      ]
    }
  }
});