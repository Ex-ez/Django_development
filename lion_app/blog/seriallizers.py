from  rest_framework import serializers


client = MongoClient(host="mongo")
db = client.likelion


class BlogSerializer(serializers):
    title = serializers.CharField(max_length=100)
    content = serializers.CharField()
    author = serializers.CharField(max_length=100)

    def create(self, validated_data):
        return db.blog.insert_one(validated_data)