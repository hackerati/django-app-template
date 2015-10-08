# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('temp', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='temp',
            name='other_field',
            field=models.CharField(default='L', max_length=1),
            preserve_default=False,
        ),
    ]
