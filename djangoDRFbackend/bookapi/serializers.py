from rest_framework import serializers

from . models import *
        


class BookSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields = [ 'id', 'name', 'edition', 'author', 'cover', 'description', 'price', ]


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = '__all__'


class OrderIdSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderId
        fields = '__all__'


class CartSerializer(serializers.ModelSerializer):
    productId = BookSerializer()
    class Meta:
        model = Cart
        fields = '__all__'


class OrderSerializer(serializers.ModelSerializer):
    oid = OrderIdSerializer()
    products = CartSerializer(many=True)
    
    class Meta:
        model = Order
        fields = '__all__'

