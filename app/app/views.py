"""
This is a very simple sample app which keeps track of the timestamps
for each time that the main page is loaded, and then displays them
on the page. It's sole purpose at the moment is to show the user that
the database is correctly configured and connected to the app.
"""
import os

from django.shortcuts import render
from django.conf import settings

from sample_app.models import PageLoad


def home(request):
    page_load = PageLoad()
    page_load.save()
    page_loads = [model.format_datetime() for model in PageLoad.objects.all()]
    return render(request, "home.html", {'page_loads':page_loads})


# This block of code checks for changes to your code every five seconds
# and reloads the app if there are changes. This only runs in dev mode.
if settings.ENVIRONMENT == 'development' and 'TRAVIS' not in os.environ:
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
