#!/bin/bash

# Course Management System - Quick Setup Script
# This script automates the installation of prerequisites

echo "🚀 Course Management System - Quick Setup"
echo "=========================================="

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root"
   echo "   Please run as a regular user with sudo privileges"
   exit 1
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to print status
print_status() {
    echo ""
    echo "📋 $1"
    echo "----------------------------------------"
}

# Update system
print_status "Updating system packages"
sudo apt update

# Install Java 11
print_status "Installing Java 11"
if command_exists java; then
    echo "✅ Java already installed: $(java -version 2>&1 | head -1)"
else
    sudo apt install openjdk-11-jdk -y
    echo "✅ Java 11 installed"
fi

# Install Maven
print_status "Installing Apache Maven"
if command_exists mvn; then
    echo "✅ Maven already installed: $(mvn -version | head -1)"
else
    sudo apt install maven -y
    echo "✅ Maven installed"
fi

# Install MySQL
print_status "Installing MySQL Server"
if command_exists mysql; then
    echo "✅ MySQL already installed"
else
    sudo apt install mysql-server -y
    sudo systemctl start mysql
    sudo systemctl enable mysql
    echo "✅ MySQL installed and started"
    echo "⚠️  Please run 'sudo mysql_secure_installation' after this script"
fi

# Check if Tomcat is installed
print_status "Checking Apache Tomcat"
if [ -d "/opt/tomcat" ]; then
    echo "✅ Tomcat already installed"
else
    echo "📦 Installing Apache Tomcat 9..."
    
    # Create tomcat user
    sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat 2>/dev/null || true
    
    # Download and install Tomcat
    cd /tmp
    TOMCAT_VERSION="9.0.82"
    wget -q https://downloads.apache.org/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
    
    if [ $? -eq 0 ]; then
        sudo tar -xf apache-tomcat-${TOMCAT_VERSION}.tar.gz -C /opt/tomcat --strip-components=1
        sudo chown -R tomcat: /opt/tomcat
        sudo sh -c 'chmod +x /opt/tomcat/bin/*.sh'
        
        # Create systemd service
        sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOF
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOF
        
        sudo systemctl daemon-reload
        sudo systemctl start tomcat
        sudo systemctl enable tomcat
        
        echo "✅ Tomcat installed and started"
    else
        echo "❌ Failed to download Tomcat"
        exit 1
    fi
fi

# Setup MySQL database
print_status "Setting up MySQL database"
echo "Please enter MySQL root password when prompted:"

sudo mysql -e "CREATE DATABASE IF NOT EXISTS course_management_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; CREATE USER IF NOT EXISTS 'courseapp'@'localhost' IDENTIFIED BY 'MyApp123@'; GRANT ALL PRIVILEGES ON course_management_db.* TO 'courseapp'@'localhost'; FLUSH PRIVILEGES;"

if [ $? -eq 0 ]; then
    echo "✅ Database setup completed"
else
    echo "❌ Database setup failed"
    echo "   Please run the following SQL commands manually:"
    echo "   CREATE DATABASE course_management_db;"
    echo "   CREATE USER 'courseapp'@'localhost' IDENTIFIED BY 'MyApp123@';"
    echo "   GRANT ALL PRIVILEGES ON course_management_db.* TO 'courseapp'@'localhost';"
    echo "   FLUSH PRIVILEGES;"
fi

# Build the project
print_status "Building the project"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [ -f "pom.xml" ]; then
    mvn clean package -q
    
    if [ $? -eq 0 ]; then
        echo "✅ Project built successfully"
        
        # Deploy to Tomcat
        if [ -f "target/course-management-system-1.0.0.war" ]; then
            sudo cp target/course-management-system-1.0.0.war /opt/tomcat/webapps/
            sudo systemctl restart tomcat
            echo "✅ Application deployed to Tomcat"
        else
            echo "❌ WAR file not found"
        fi
    else
        echo "❌ Project build failed"
    fi
else
    echo "❌ pom.xml not found in current directory"
fi

# Final status
print_status "Setup Summary"
echo "Java:    $(if command_exists java; then echo "✅ Installed"; else echo "❌ Not installed"; fi)"
echo "Maven:   $(if command_exists mvn; then echo "✅ Installed"; else echo "❌ Not installed"; fi)"
echo "MySQL:   $(if command_exists mysql; then echo "✅ Installed"; else echo "❌ Not installed"; fi)"
echo "Tomcat:  $(if [ -d "/opt/tomcat" ]; then echo "✅ Installed"; else echo "❌ Not installed"; fi)"

echo ""
echo "🎉 Setup completed!"
echo ""
echo "📋 Next Steps:"
echo "1. Wait 30 seconds for Tomcat to fully start"
echo "2. Open your browser and go to:"
echo "   http://localhost:8080/course-management-system-1.0.0/"
echo ""
echo "🔑 Default Login Credentials:"
echo "   Admin:   admin    / password123"
echo "   Teacher: teacher1 / password123"
echo "   Student: student1 / password123"
echo ""
echo "📊 Check Status:"
echo "   Tomcat:  sudo systemctl status tomcat"
echo "   MySQL:   sudo systemctl status mysql"
echo "   Logs:    sudo tail -f /opt/tomcat/logs/catalina.out"
echo ""

# Check if services are running
sleep 2
echo "🔍 Service Status Check:"
if sudo systemctl is-active --quiet mysql; then
    echo "✅ MySQL is running"
else
    echo "❌ MySQL is not running - run 'sudo systemctl start mysql'"
fi

if sudo systemctl is-active --quiet tomcat; then
    echo "✅ Tomcat is running"
else
    echo "❌ Tomcat is not running - run 'sudo systemctl start tomcat'"
fi

echo ""
echo "🚀 Your Course Management System is ready!"
