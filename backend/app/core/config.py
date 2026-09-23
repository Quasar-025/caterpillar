from functools import lru_cache
from typing import Literal

from pydantic import SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    app_name: str = "CAT Operator Copilot API"
    database_url: str = "sqlite:///./operator_copilot.db"
    cors_origins: list[str] = ["http://localhost"]
    llm_provider: Literal["none", "gemini", "openai"] = "none"
    gemini_api_key: SecretStr | None = None
    gemini_model: str = "gemini-3.8-live"
    openai_api_key: SecretStr | None = None
    openai_model: str = "gpt-4.1-mini"
    llm_timeout_seconds: float = 3.0

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
