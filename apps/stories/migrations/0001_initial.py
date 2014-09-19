# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Answer',
            fields=[
            ],
            options={
                'db_table': 'stories_answer',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Question',
            fields=[
            ],
            options={
                'db_table': 'stories_question',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Questiongroup',
            fields=[
            ],
            options={
                'db_table': 'stories_questiongroup',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='QuestiongroupQuestions',
            fields=[
            ],
            options={
                'db_table': 'stories_questiongroup_questions',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='QuestionType',
            fields=[
            ],
            options={
                'db_table': 'stories_questiontype',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Source',
            fields=[
            ],
            options={
                'db_table': 'stories_source',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Story',
            fields=[
            ],
            options={
                'db_table': 'stories_story',
                'managed': False,
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='StoryImage',
            fields=[
            ],
            options={
                'db_table': 'stories_storyimage',
                'managed': False,
            },
            bases=(models.Model,),
        ),
    ]
