# CAT Operator Copilot

Mobile-first operator assistant for construction machinery. The Flutter app keeps
safety decisions on the device, while the FastAPI service provides cloud data,
ETA predictions, and optional language generation.

## Repository

- `frontend/` — Flutter tablet and phone application
- `backend/` — FastAPI cloud service
- `data/` — synthetic data generator and generated datasets
- `Caterpillar_Operator_Copilot_Organized_Ideas_Features.docx` — product brief

## Development

### Mobile

```powershell
cd frontend
flutter pub get
flutter run
```

### Backend

```powershell
cd backend
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -e ".[dev]"
uvicorn app.main:app --reload
```

The backend health check is available at `http://localhost:8000/health`.

Devices keep a local SQLite copy of tasks, checklists, shifts, and handovers.
Offline writes go into an outbox. When the network is up, the app pushes that
outbox to `POST /sync/push` and then pulls newer cloud rows from `GET /sync/pull`.
Conflicts use last-write-wins on `updated_at`.
