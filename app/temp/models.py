from django.db import models

# Create your models here.
class Temp(models.Model):
    text_field = models.CharField(max_length=100)
    other_field = models.CharField(max_length=1)
    new_field = models.CharField(max_length=2, default='no')

    def serialize(self):
        return {
                'text_field':self.text_field,
                'id':self.id
                }

