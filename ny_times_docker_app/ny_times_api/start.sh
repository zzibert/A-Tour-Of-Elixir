#!/bin/bash

echo $POSTGRES_HOST

echo "start migration"

mix ecto.migrate

echo "Starting app"

/opt/app/_build/prod/rel/ny_times_api/bin/ny_times_api start