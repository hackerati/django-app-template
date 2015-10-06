# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('temp', '0002_temp_other_field'),
    ]

    operations = [
        migrations.AddField(
            model_name='temp',
            name='new_field',
            field=models.CharField(default=b'no', max_length=2),
        ),
    ]
