from functools import lru_cache

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "CAT Operator Copilot API"
    database_url: str = "sqlite:///./operator_copilot.db"
    cors_origins: list[str] = ["http://localhost"]

    model_config = SettingsConfigDict(env_file=".env", env_prefix="CAT_", extra="ignore")

    @property
    def sqlalchemy_database_url(self) -> str:
        if self.database_url.startswith("postgresql://"):
            return self.database_url.replace(
                "postgresql://",
                "postgresql+psycopg://",
                1,
            )
        return self.database_url


@lru_cache
def get_settings() -> Settings:
    return Settings()
