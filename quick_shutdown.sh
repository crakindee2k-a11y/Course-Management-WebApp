#!/bin/bash

##############################################################################
# ⚡ COURSE MANAGEMENT SYSTEM - QUICK SHUTDOWN
##############################################################################
#
# WHAT THIS DOES: Fast shutdown of Tomcat server
# USAGE: ./quick_shutdown.sh
#
##############################################################################

echo "🛑 Quick Shutdown - Course Management System"
echo "=============================================="

STOP_DB="${STOP_DB:-0}"
for arg in "$@"; do
    if [ "$arg" = "--stop-db" ]; then
        STOP_DB=1
    fi
done

is_database_running() {
    pgrep -x mysqld >/dev/null 2>&1 || pgrep -x mariadbd >/dev/null 2>&1
}

stop_database() {
    if ! is_database_running; then
        echo "✅ Database is already stopped"
        return 0
    fi

    if command -v systemctl >/dev/null 2>&1; then
        for svc in mysql mariadb mysqld; do
            sudo systemctl stop "${svc}.service" >/dev/null 2>&1 || true
            if ! is_database_running; then
                echo "✅ Database stopped (${svc}.service)"
                return 0
            fi
        done
    fi

    if command -v service >/dev/null 2>&1; then
        for svc in mysql mariadb mysqld; do
            sudo service "$svc" stop >/dev/null 2>&1 || true
            if ! is_database_running; then
                echo "✅ Database stopped ($svc)"
                return 0
            fi
        done
    fi

    echo "⚠️  Could not confirm database stop (service name may differ)."
    return 1
}

# Try official Tomcat shutdown first
echo "⚡ Stopping Tomcat service..."
if sudo /opt/tomcat/bin/shutdown.sh >/dev/null 2>&1; then
    echo "✅ Tomcat shutdown command executed"
else
    echo "⚠️  Tomcat shutdown script not found, trying process kill..."
fi

# Wait a moment for processes to stop
sleep 3

# Check if stopped, if not force kill
if pgrep -f "catalina" > /dev/null || pgrep -f "tomcat" > /dev/null; then
    echo "🔥 Force killing remaining processes..."
    sudo pkill -9 -f "catalina" 2>/dev/null
    sudo pkill -9 -f "tomcat" 2>/dev/null
    sleep 1
fi

# Final check
if ! pgrep -f "catalina" > /dev/null && ! pgrep -f "tomcat" > /dev/null; then
    echo "✅ Tomcat stopped successfully"
else
    echo "❌ Some Tomcat processes may still be running"
fi

if [ "${STOP_DB}" -eq 1 ] || [ "${STOP_DB:-0}" = "1" ]; then
    echo "🛢️  Stopping database (MySQL/MariaDB)..."
    stop_database || true
fi

echo "🎉 Quick shutdown complete!"
