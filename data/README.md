CAT Operator Copilot - Structured Synthetic Dataset

Files:
- tasks.csv: task-level ETA training records. actual_duration_min is the ETA target.
- telemetry.csv: live task telemetry/state samples.
- anomalies.csv: labelled anomaly events linked to real task IDs and telemetry timestamps.
- shifts.csv: shift entity.
- checklist_items.csv: machine checklist entity.
- operator_baselines.csv: median cycle time, idle, corrections and reaction baseline per operator/task type.
- training_modules.csv: anomaly-to-training mapping.
- handovers.csv: shift handover records.

Important:
- tasks.csv contains variable completion: quantity_done and progress_pct can be 45%, 55%, 65%, 75%, 85%, 90%, 95%, or 100%.
- telemetry progress follows the corresponding task's actual completion percentage and starts at 0%.
- task cycle_time_sec is the task average; telemetry cycle_time_sec is the latest cycle; rolling_cycle_time_sec is the recent rolling average.
- Data is synthetic and intended for prototype/demo/ML development, not operational safety decisions.
