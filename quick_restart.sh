#!/bin/bash

# Quick Restart - Minimal version
echo "🔄 Quick restart..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

is_database_running() {
    pgrep -x mysqld >/dev/null 2>&1 || pgrep -x mariadbd >/dev/null 2>&1
}

start_database() {
    if is_database_running; then
        return 0
    fi

    if command -v systemctl >/dev/null 2>&1; then
        for svc in mysql mariadb mysqld; do
            sudo systemctl start "${svc}.service" >/dev/null 2>&1 || true
            if is_database_running; then
                return 0
            fi
        done
    fi

    if command -v service >/dev/null 2>&1; then
        for svc in mysql mariadb mysqld; do
            sudo service "$svc" start >/dev/null 2>&1 || true
            if is_database_running; then
                return 0
            fi
        done
    fi

    return 1
}

echo "🛢️  Starting database (MySQL/MariaDB)..."
if ! start_database; then
    echo "❌ Could not start MySQL/MariaDB. Install/start it manually, then re-run."
    exit 1
fi

sudo /opt/tomcat/bin/shutdown.sh > /dev/null 2>&1
if ! mvn clean package -q; then
    echo "❌ Build failed."
    exit 1
fi
sudo cp target/course-management-system-1.0.0.war /opt/tomcat/webapps/
sudo /opt/tomcat/bin/startup.sh > /dev/null 2>&1

echo "✅ Done! Wait 10 seconds then go to:"
echo "   http://localhost:8080/course-management-system-1.0.0/"
