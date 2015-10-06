from django.db import models

# Create your models here.
class Temp(models.Model):
    text_field = models.CharField(max_length=100)
    other_field = models.CharField(max_length=1)

    def serialize(self):
        return {
                'text_field':self.text_field,
                'id':self.id
                }

