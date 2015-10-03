#!/bin/bash

set -e

: ${SERVER:=thin}
: ${HOST:=0.0.0.0}
: ${PORT:=8080}

exec bundle exec rackup --server $SERVER --port $PORT --host $HOST
