#!/bin/bash
docker run --rm -v "$(pwd)":/app -w /app crystallizer sh -c 'bundle install --standalone'
docker kill crystallizer-web
docker rm crystallizer-web
docker run --name crystallizer-web -d -v "$(pwd)":/app -w /app -p 8080:8080 crystallizer sh -c 'sh server.sh'
