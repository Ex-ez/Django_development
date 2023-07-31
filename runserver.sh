#git pull
echo "git pull"
git pull

#가상환경 적용 (source)
echo "start to activeate venv"
source venv/bin/activate

#runserver
echo "reunserver"
python SAPP_NAME/mange.py runserver 0.0.0.:8000