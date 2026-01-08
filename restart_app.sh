#!/bin/bash

# Course Management System - Easy Restart Script
echo "🔄 Restarting Course Management System..."
echo "=========================================="

# Navigate to project directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

is_database_running() {
    pgrep -x mysqld >/dev/null 2>&1 || pgrep -x mariadbd >/dev/null 2>&1
}

start_database() {
    if is_database_running; then
        echo "✅ Database is already running"
        return 0
    fi

    if command -v systemctl >/dev/null 2>&1; then
        for svc in mysql mariadb mysqld; do
            sudo systemctl start "${svc}.service" >/dev/null 2>&1 || true
            if is_database_running; then
                echo "✅ Database started (${svc}.service)"
                return 0
            fi
        done
    fi

    if command -v service >/dev/null 2>&1; then
        for svc in mysql mariadb mysqld; do
            sudo service "$svc" start >/dev/null 2>&1 || true
            if is_database_running; then
                echo "✅ Database started ($svc)"
                return 0
            fi
        done
    fi

    echo "❌ Could not start MySQL/MariaDB. Install it and/or start it manually, then re-run this script."
    return 1
}

# Stop Tomcat
echo "⏹️  Stopping Tomcat..."
sudo /opt/tomcat/bin/shutdown.sh

echo "🛢️  Starting database (MySQL/MariaDB)..."
if ! start_database; then
    exit 1
fi

# Build the project
echo "🔨 Building project..."
mvn clean package -q

if [ $? -eq 0 ]; then
    echo "✅ Build successful"
    
    # Deploy to Tomcat
    echo "📦 Deploying application..."
    sudo cp target/course-management-system-1.0.0.war /opt/tomcat/webapps/
    
    # Start Tomcat
    echo "🚀 Starting Tomcat..."
    sudo /opt/tomcat/bin/startup.sh
    
    # Wait a moment for startup
    echo "⏳ Waiting for application to start..."
    sleep 8
    
    # Check if application is running
    echo "🔍 Checking application status..."
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/course-management-system-1.0.0/)
    
    if [ "$HTTP_STATUS" = "200" ]; then
        echo ""
        echo "🎉 SUCCESS! Application restarted successfully"
        echo ""
        echo "📋 Access your application:"
        echo "   🌐 URL: http://localhost:8080/course-management-system-1.0.0/"
        echo ""
        echo "🔑 Login Credentials:"
        echo "   👤 Admin:   admin    / password123"
        echo "   👨‍🏫 Teacher: teacher1 / password123"
        echo "   👨‍🎓 Student: student1 / password123"
        echo ""
        echo "📊 Logs: sudo tail -f /opt/tomcat/logs/catalina.out"
    else
        echo "❌ Application may not be ready yet. Check logs:"
        echo "   sudo tail -f /opt/tomcat/logs/catalina.out"
    fi
else
    echo "❌ Build failed. Please check for errors above."
fi

echo ""
echo "✨ Restart complete!"
