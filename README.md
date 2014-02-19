# AngularJS UI for DataBindery

# Deploy notes

had to delete vendor/bower/jquery/jquery-migrate.min.js because it references a sourcemap file that's missing from the distro, which causes lineman's concat_sourcemap to fail

# Dev Notes

If you get EMFILE error from grunt watch task, use 'ulimit -n 800 10480' (or similar). See https://github.com/gruntjs/grunt-contrib-watch#how-do-i-fix-the-error-emfile-too-many-opened-files and http://superuser.com/questions/302754/increase-the-maximum-number-of-open-file-descriptors-in-snow-leopard
