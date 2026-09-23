import asyncio
import csv
import json
from pathlib import Path

from fastapi import APIRouter, WebSocket, WebSocketDisconnect

router = APIRouter(prefix="/telemetry", tags=["telemetry"])

# The path to the telemetry.csv data relative to backend execution
DATA_PATH = Path(__file__).resolve().parent.parent.parent.parent / "data" / "telemetry.csv"


@router.websocket("/stream")
async def telemetry_stream(websocket: WebSocket, time_scale: float = 1.0):
    await websocket.accept()
    
    if not DATA_PATH.exists():
        print(f"Data file not found: {DATA_PATH}")
        await websocket.close(code=1011, reason="telemetry.csv not found")
        return

    try:
        while True:
            # Reopen the file each time we loop the dataset
            with open(DATA_PATH, "r", encoding="utf-8") as f:
                reader = csv.DictReader(f)
                for row in reader:
                    await websocket.send_text(json.dumps(row))
                    
                    # Sleep duration inversely proportional to time_scale
                    # At 1x, sleep for 2.0s. At 10x, 0.2s. At 60x, ~0.033s.
                    sleep_amount = 2.0 / max(time_scale, 0.1)
                    # Keep sleep within reasonable bounds to avoid freezing or spamming
                    sleep_amount = max(0.05, min(sleep_amount, 5.0))
                    
                    await asyncio.sleep(sleep_amount)
            # If the CSV ends, we loop back to the beginning.
            # Give a small pause before restarting
            await asyncio.sleep(1.0)
            
    except WebSocketDisconnect:
        print("Client disconnected from telemetry stream")
    except Exception as e:
        print(f"Error in telemetry stream: {e}")
        # Using a proper check for client_state is necessary, but standard starlette doesn't
        # expose client_state easily. A simple try-except on close is safer.
        try:
            await websocket.close(code=1011)
        except:
            pass
