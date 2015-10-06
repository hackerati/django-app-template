from time import time

from django.shortcuts import render

from temp.models import Temp


def home(request):
    temp = Temp(
            text_field=str(time()),
            other_field='N')
    temp.save()
    models = [model.serialize() for model in Temp.objects.all()]
    return render(request, "home.html", {'models':models})
