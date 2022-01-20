#! /usr/bin/env sh

# Entrypoint for Logz.io Logs for Salesforce Commerce Cloud
# Adapted from https://github.com/fluent/fluentd-docker-image/blob/master/v1.11/alpine/entrypoint.sh

#source vars if file exists
DEFAULT=/etc/default/fluentd

if [ -r $DEFAULT ]; then
    set -o allexport
    . $DEFAULT
    set +o allexport
fi

# If the user has supplied only arguments append them to `fluentd` command
if [ "${1#-}" != "$1" ]; then
    set -- fluentd "$@"
fi

# If user does not supply config file or plugins, use the default
if [ "$1" = "fluentd" ]; then
    if ! echo $@ | grep ' \-c' ; then
       set -- "$@" -c /fluentd/etc/${FLUENTD_CONF}
    fi

    if ! echo $@ | grep ' \-p' ; then
       set -- "$@" -p /fluentd/plugins
    fi
fi

# Instead of exec fluentd here, write full command to an env var
# that supervisord will execute and manage.
# exec "$@"
export FLUENTD_CMD="$@"
# Used by supervisord to run cctail
export CCTAIL_ARGS="$SFCC_PROFILE $CCTAIL_ARGS"

exec supervisord -c /etc/supervisord.conf
