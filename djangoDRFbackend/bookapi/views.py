from rest_framework.views import APIView
from rest_framework.generics import ListAPIView
from rest_framework.response import Response
from rest_framework import status


from .models import Book, User, OrderId, Cart, Order
from . serializers import UserSerializer, BookSerializer, OrderSerializer

# Create your views here.

class CreateNewUser(APIView):

    def post(self, request, *args, **kwargs):
        serializer = UserSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class GetUser(APIView):

    def post(self, request, *args, **kwargs):
        user = User.objects.get(email=request.data.get('email'))

        serializer = UserSerializer(user, many=False)
        return Response(serializer.data, status=status.HTTP_200_OK)
    



class BookView(ListAPIView):
    
    queryset =Book.objects.all()
    serializer_class = BookSerializer


class OrderView(APIView):

    def get(self, request, *args, **kwargs):
        orders = Order.objects.filter(oid__uid__userId=kwargs.get('uid'))
    
        serializer = OrderSerializer(orders, many=True)
        return Response(serializer.data)
    

    def post(self, request, *args, **kwargs):
        data = request.data
        print(data)
        userId = data.get('userId')

    
        user, creatUser = User.objects.get_or_create(userId=userId)
        print(user, creatUser)
        userName = data.get('userName')
        userAddress = data.get('address')
        userPhoneNo = data.get('phoneNo')
        orderId = OrderId.objects.create(uid=user, dateTime=data.get('dateTime'))

        li = []
        products = data.get('products')
        for prduct in products:
            book = Book.objects.get(id=prduct.get('id'))

            cart = Cart.objects.create(uid=user, productId=book, quantity=prduct['quantity'])
            li.append(cart)

        orders  = Order.objects.create(name=userName, address=userAddress, phoneNum=userPhoneNo,oid=orderId, amount=data['amount'])
     
        for product in li:
            orders.products.add(product)

        li.clear()
        
        return Response({'orderId': orders.oid.dateTime})

