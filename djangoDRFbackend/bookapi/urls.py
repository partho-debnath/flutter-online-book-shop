from django.urls import path

from . import views

urlpatterns = [
   path('', views.BookView.as_view(), name='book-list'),
   path('create-user/', views.CreateNewUser.as_view(), name='create-new-user'),
   path('get-user/', views.GetUser.as_view(), name='get-user'),
   path('orders/<str:uid>/', views.OrderView.as_view(), name='orders'),
]
