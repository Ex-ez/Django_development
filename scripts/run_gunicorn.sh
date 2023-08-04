#!/bin/bash

# 실행 경로 진입
cd /home/lion/Django_development/lion_app
# activate venv
source /home/lion2/Django_develioment/venv/bin/activate
# gunicorn 실행
gunicorn lion_app.wsgi:application --config lion_app/gunicorn_config.py
