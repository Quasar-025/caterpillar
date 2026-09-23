from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "CAT Operator Copilot API"
    database_url: str = "sqlite:///./operator_copilot.db"
    cors_origins: list[str] = ["http://localhost"]

    model_config = SettingsConfigDict(env_file=".env", env_prefix="CAT_", extra="ignore")


@lru_cache
def get_settings() -> Settings:
    return Settings()
