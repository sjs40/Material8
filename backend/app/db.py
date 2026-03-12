from psycopg import connect
from psycopg.rows import dict_row

from app.core.config import settings


def get_db_connection():
    return connect(
        host=settings.postgres_host,
        port=settings.postgres_port,
        dbname=settings.postgres_db,
        user=settings.postgres_user,
        password=settings.postgres_password,
        row_factory=dict_row,
        autocommit=True,
    )
