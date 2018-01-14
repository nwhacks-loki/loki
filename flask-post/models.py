import os

from playhouse.db_url import connect
from peewee import Model, PrimaryKeyField
from playhouse.postgres_ext import BinaryJSONField

db = connect(os.environ.get('DATABASE_URL'))


class Emotion(Model):
    key = PrimaryKeyField()
    data = BinaryJSONField()

    class Meta:
        database = db
        db_table = 'emotions'
