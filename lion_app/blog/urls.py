from rest_framework.routers import DefaultRouter
from pymongo import MongoClient

from . import views

router = DefaultRouter()
router.register('', view.BlogViewSet, basename='blog')
