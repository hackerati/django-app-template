# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('temp', '0003_temp_new_field'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='temp',
            name='new_field',
        ),
        migrations.RemoveField(
            model_name='temp',
            name='other_field',
        ),
    ]
