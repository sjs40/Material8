from pathlib import Path

from app.db import get_db_connection


MIGRATIONS_DIR = Path(__file__).resolve().parent.parent / 'migrations' / 'sql'


def main() -> None:
    migration_files = sorted(MIGRATIONS_DIR.glob('*.sql'))

    with get_db_connection() as conn:
        with conn.cursor() as cur:
            cur.execute(
                '''
                CREATE TABLE IF NOT EXISTS schema_migrations (
                  version TEXT PRIMARY KEY,
                  applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
                )
                '''
            )

            for migration_file in migration_files:
                version = migration_file.name
                cur.execute('SELECT 1 FROM schema_migrations WHERE version = %s', (version,))
                if cur.fetchone():
                    continue

                sql = migration_file.read_text(encoding='utf-8')
                cur.execute(sql)
                cur.execute('INSERT INTO schema_migrations(version) VALUES (%s)', (version,))
                print(f'Applied migration: {version}')


if __name__ == '__main__':
    main()
