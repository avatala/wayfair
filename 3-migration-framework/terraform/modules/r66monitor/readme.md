# Phase API / Monitoring

This module creates:
* bigquery datasets for raw pubsub messages, sheets for google sheets metadata, transforms for sql views that join messages with sheets metadata, and reporting for dims and fact sql views
* bigquery tables for raw pubsub subscription tables - raw message data and created datetime
* pubsub topics defined in variables or passed in to override defaults
* pubsub bq subscriptions that link the topics to the destination bq tables