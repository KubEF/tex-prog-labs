#!/bin/bash
set -euo pipefail

# Запуск стресс-теста CPU в фоне
stress --cpu 8 &
STRESS_PID=$!

# Настройка лог-файла
LOGFILE="test_runs_$(date +%s).log"
echo "Logging to $LOGFILE"

# Запуск тестов до первого падения
RUN=1
while cargo test my_test > "$LOGFILE" 2>&1; do
    echo "Run $RUN passed"
    ((RUN++))
done

# Очистка и отчёт
kill $STRESS_PID
echo "Test failed on run $RUN"
echo "Last 20 lines of output:"
tail -n 20 "$LOGFILE"
echo "Full log: $LOGFILE"
