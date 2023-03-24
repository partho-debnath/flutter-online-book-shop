from django.db import models

# Create your models here.



class Book(models.Model):
    name = models.CharField(max_length=255, blank=False, null=False, unique=True)
    edition = models.CharField(max_length=10, blank=False, null=False)
    author = models.CharField(max_length=255, blank=False, null=False)
    cover = models.ImageField(upload_to='books')
    image1 = models.ImageField(upload_to='books')
    image2 = models.ImageField(upload_to='books')
    description = models.TextField(blank=False, null=False)
    price = models.IntegerField(default=0)

    def __str__(self):
        return f"Name: {self.name[:20].title()}, Edition: {self.edition}"



class User(models.Model):
    userId = models.CharField(unique=True, max_length=100, blank=False, null=False)
    name = models.CharField(max_length=50)
    email = models.EmailField(unique=True)
    profilepic = models.ImageField(upload_to='users/profilepic', default='users/abc.png')


    def __str__(self):
         return f"User: {self.userId}"


class OrderId(models.Model):
    uid = models.ForeignKey(User, on_delete=models.CASCADE)
    dateTime = models.CharField(unique=True, max_length=100, blank=False, null=False)

    def __str__(self):
        return f"User: {self.uid}"
    
    class Meta:
        unique_together = ['uid', 'dateTime']
    

class Cart(models.Model):
    uid = models.ForeignKey(User, on_delete=models.CASCADE)
    productId = models.ForeignKey(Book, on_delete=models.CASCADE)
    quantity = models.IntegerField(default=0)


    def __str__(self):
        return f'{self.quantity}'


class Order(models.Model):
    name = models.CharField(max_length=50, blank=False, null=False)
    address = models.CharField(max_length=500, blank=False, null=False)
    phoneNum = models.CharField(max_length=15, blank=False, null=False)
    oid = models.ForeignKey(OrderId, on_delete=models.CASCADE)
    products = models.ManyToManyField(Cart)
    amount = models.FloatField(default=0.0)


    def __str__(self):
        return f'order id{self.oid}'
        


