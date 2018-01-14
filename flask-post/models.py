import os
import datetime

from playhouse.db_url import connect
from peewee import Model, PrimaryKeyField, DateTimeField
from playhouse.postgres_ext import BinaryJSONField

db = connect(os.environ.get('DATABASE_URL'))


class Emotion(Model):
    key = PrimaryKeyField()
    data = BinaryJSONField()
    timestamp = DateTimeField(default=datetime.datetime.now)

    class Meta:
        database = db
        db_table = 'emotions'
