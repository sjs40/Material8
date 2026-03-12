from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', env_file_encoding='utf-8', extra='ignore')

    app_name: str = 'Material8 API'
    app_env: str = 'development'
    app_port: int = 8000

    postgres_host: str = 'postgres'
    postgres_port: int = 5432
    postgres_db: str = 'material8'
    postgres_user: str = 'material8'
    postgres_password: str = 'material8'

    redis_url: str = 'redis://redis:6379/0'


settings = Settings()
