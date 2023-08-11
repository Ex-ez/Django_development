from drf_spectacular.utils import extend_schema
from rest_framework import viewsets

from .models import Topic, Post
from .serializers import TopicSerializer, PostSerializer



@extend_schema(tags=["Topics", "Forum"])
class TopicViewSet(viewsets.ModelViewSet):
    queryset = Topic.objects.all()
    serializer_class = TopicSerializer

@extend_schema(tags=["Posts", "Forum"])
class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer