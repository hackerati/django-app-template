from time import time

from django.shortcuts import render

from sample_app.models import Temp


def home(request):
    temp = Temp(text_field=str(time()))
    temp.save()
    models = [model.serialize() for model in Temp.objects.all()]
    return render(request, "home.html", {'models':models})
