export TMPDIR=${TMPDIR:-/tmp}
PATH=/usr/local/bin:$PATH
exec 3>&1 # make stdout available as fd 3 for the result
exec 1>&2 # redirect all output to stderr for logging
