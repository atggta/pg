#!/usr/bin/env bash
set -Eeo pipefail

# Example using the functions of the postgres entrypoint to customize startup to always run files in /always-initdb.d/

source "$(which docker-entrypoint.sh)"

docker_setup_env
# setup data directories and permissions (when run as root)
docker_create_db_directories

if [ "$(id -u)" = '0' ]; then
    # exec gosu postgres "$BASH_SOURCE" "$@"
    echo "su-exec"
    exec su-exec postgres "$BASH_SOURCE" "$@"
    echo $(id)
fi

docker_verify_minimum_env
docker_init_database_dir
pg_setup_hba_conf

# only required for '--auth[-local]=md5' on POSTGRES_INITDB_ARGS
export PGPASSWORD="${PGPASSWORD:-$POSTGRES_PASSWORD}"

docker_temp_server_start "$@" -c max_locks_per_transaction=256
docker_setup_db
docker_process_init_files /docker-entrypoint-initdb.d/*
docker_temp_server_stop
