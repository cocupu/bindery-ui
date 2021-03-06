/* Exports an object that defines
 *  all of the configuration needed by the projects'
 *  depended-on grunt tasks.
 *
 * You can find the parent object in: node_modules/lineman/config/application.coffee
 */

module.exports = require(process.env['LINEMAN_MAIN']).config.extend('application', {
  enableSass: true,
  sass: {
    options: {
      bundleExec: true
    }
  },
  server: {
    pushState: true,
    apiProxy: {
      enabled: true,
      port: 8080,
      prefix: '/'
    }
  },
  watch: {
	  scripts: {
	    files: ["<%= files.js.app %>"],
			tasks: ['jshint'],
			    options: {
			      spawn: false,
			    }
	  },
	},   // concat_sourcemap breaks on deploy because bootstrap has a bad reference in its sourcemap. See, for example https://github.com/linemanjs/lineman/issues/300
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