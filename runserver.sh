#git pull
APP_NAME=lion_app
echo "git pull"
git pull

#가상환경 적용 (source)
if [ -d "venv/Scripts" ]; then
  source venv/Scripts/activate
else
  source venv/bin/activate
fi
#runserver
echo "reunserver"
python $APP_NAME/manage.py runserver 0.0.0.0:8000