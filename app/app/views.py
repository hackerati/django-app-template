from time import time

from django.shortcuts import render
from django.conf import settings

from sample_app.models import Temp


def home(request):
    temp = Temp(text_field=str(time()))
    temp.save()
    models = [model.serialize() for model in Temp.objects.all()]
    return render(request, "home.html", {'models':models})


# This block of code checks for changes to your code every five seconds
# and reloads the app if there are changes. This only runs in dev mode.
if settings.ENVIRONMENT == 'development':
    import uwsgi
    from uwsgidecorators import timer
    from django.utils import autoreload

    @timer(5)
    def reload_uwsgi_on_code_change(sig):
        """This function will check every five seconds to see whether
        the Django code has changed, and if it has uWSGI will reload.
        This mimics the autoreload functionality
        of manage.py runserver."""
        if autoreload.code_changed():
            uwsgi.reload()
