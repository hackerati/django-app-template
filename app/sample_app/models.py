from django.db import models

# Create your models here.
class PageLoad(models.Model):
    datetime_stamp = models.DateTimeField(auto_now_add=True)

    def format_datetime(self):
        return self.datetime_stamp.strftime("%Y/%m/%d at %H:%M:%S")
