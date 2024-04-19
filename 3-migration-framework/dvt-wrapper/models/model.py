"""
This file will be used for adding the Models for DB Tables.
"""
from uuid import uuid4

from app import db
from sqlalchemy_utils import URLType


class DummyModels(db.Model):
    id = db.Column(db.String, default=uuid4, primary_key=True, unique=True)
    supply_id = db.Column(db.String, index=False, unique=False)
    provider = db.Column(db.String(120), index=False, unique=False)
    model_link = db.Column(URLType)

    def __repr__(self):
        return "<DummyModels {} -> {}>".format(self.provider, self.supply_id)
