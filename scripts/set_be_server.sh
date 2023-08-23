#!/bin/sh

docker login exx1lion-cr.kr.ncr.ntruss.com \
    -u ""\
    -p ""

docker pull exx1lion-cr.kr.ncr.ntruss.com/lion-app:latest


docker run -p 8000:8000 -d \
    --name lion-app \
    -v ~/.aws:/root/.aws:ro \
    --env-file .env \
    exx1lion-cr.kr.ncr.ntruss.com/lion-app:latest