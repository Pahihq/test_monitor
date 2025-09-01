#!/bin/bash

LOGFILE="/var/log/monitoring.log"
URL="https://test.com/monitoring/test/api"
ROCNAME="test"
STATEFILE="/var/run/test_monitor_state"

timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

PID=$(pgrep -x "$PROCNAME")

if [ -n "$PID" ]; then
    # Проверка на перезапуск
    if [ -f "$STATEFILE" ]; then
        OLD_PID=$(cat "$STATEFILE")
        if [ "$PID" != "$OLD_PID" ]; then
            echo "$(timestamp) | $PROCNAME был перезапущен (PID $OLD_PID -> $PID)" >> "$LOGFILE"
        fi
    fi
    echo "$PID" > "$STATEFILE"

    # Проверка доступности сервера
    curl -s -o /dev/null --max-time 5 "$URL"
    if [ $? -ne 0 ]; then
        echo "$(timestamp) | Сервер мониторинга недоступен" >> "$LOGFILE"
    fi
fi
