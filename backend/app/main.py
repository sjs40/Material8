from fastapi import FastAPI

from app.api.health import router as health_router
from app.core.config import settings

app = FastAPI(title=settings.app_name)
app.include_router(health_router)


@app.get('/')
def root():
    return {'service': settings.app_name, 'env': settings.app_env}
