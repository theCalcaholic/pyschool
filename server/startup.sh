#!/usr/bin/env bash
set -e

if [ ! -f /is_initialized ]
then
  /init.sh
  touch /is_initialized
fi

cd /var/www/jupyter
jupyter notebook --ip=0.0.0.0 --no-browser --port=8888 --allow-root
