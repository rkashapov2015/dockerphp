#!/bin/bash

./check-env.sh || exit 1
docker-compose up -d --build