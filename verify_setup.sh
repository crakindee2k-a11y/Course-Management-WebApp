#!/bin/bash

# Course Management System - Setup Verification Script
# This script checks if all components are properly installed and configured

echo "🔍 Course Management System - Setup Verification"
echo "==============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check command
check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "${GREEN}✅${NC} $2 is installed"
        return 0
    else
        echo -e "${RED}❌${NC} $2 is not installed"
        return 1
    fi
}

# Function to check service
check_service() {
    if sudo systemctl is-active --quiet "$1"; then
        echo -e "${GREEN}✅${NC} $2 service is running"
        return 0
    else
        echo -e "${RED}❌${NC} $2 service is not running"
        echo -e "   ${YELLOW}Fix:${NC} sudo systemctl start $1"
        return 1
    fi
}

# Function to check port
check_port() {
    if netstat -tlnp 2>/dev/null | grep ":$1 " >/dev/null; then
        echo -e "${GREEN}✅${NC} Port $1 is listening"
        return 0
    else
        echo -e "${RED}❌${NC} Port $1 is not listening"
        return 1
    fi
}

echo ""
echo -e "${BLUE}📋 Checking Prerequisites${NC}"
echo "----------------------------------------"

# Check Java
check_command "java" "Java"
if command -v java >/dev/null 2>&1; then
    JAVA_VERSION=$(java -version 2>&1 | head -1)
    echo "   Version: $JAVA_VERSION"
fi

# Check Maven
check_command "mvn" "Maven"
if command -v mvn >/dev/null 2>&1; then
    MAVEN_VERSION=$(mvn -version | head -1)
    echo "   Version: $MAVEN_VERSION"
fi

# Check MySQL
check_command "mysql" "MySQL"

echo ""
echo -e "${BLUE}📋 Checking Services${NC}"
echo "----------------------------------------"

# Check MySQL service
check_service "mysql" "MySQL"

# Check Tomcat service
check_service "tomcat" "Tomcat"

echo ""
echo -e "${BLUE}📋 Checking Ports${NC}"
echo "----------------------------------------"

# Check MySQL port
check_port "3306"

# Check Tomcat port
check_port "8080"

echo ""
echo -e "${BLUE}📋 Checking Installation Paths${NC}"
echo "----------------------------------------"

# Check Tomcat installation
if [ -d "/opt/tomcat" ]; then
    echo -e "${GREEN}✅${NC} Tomcat directory exists: /opt/tomcat"
    if [ -f "/opt/tomcat/bin/catalina.sh" ]; then
        echo -e "${GREEN}✅${NC} Tomcat binaries found"
    else
        echo -e "${RED}❌${NC} Tomcat binaries not found"
    fi
else
    echo -e "${RED}❌${NC} Tomcat directory not found: /opt/tomcat"
fi

# Check project structure
echo ""
echo -e "${BLUE}📋 Checking Project${NC}"
echo "----------------------------------------"

if [ -f "pom.xml" ]; then
    echo -e "${GREEN}✅${NC} Maven project file (pom.xml) found"
else
    echo -e "${RED}❌${NC} Maven project file (pom.xml) not found"
fi

if [ -f "src/main/webapp/WEB-INF/web.xml" ]; then
    echo -e "${GREEN}✅${NC} Web application descriptor (web.xml) found"
else
    echo -e "${RED}❌${NC} Web application descriptor (web.xml) not found"
fi

if [ -f "target/course-management-system-1.0.0.war" ]; then
    echo -e "${GREEN}✅${NC} WAR file exists"
    WAR_SIZE=$(du -h target/course-management-system-1.0.0.war | cut -f1)
    echo "   Size: $WAR_SIZE"
else
    echo -e "${YELLOW}⚠️${NC} WAR file not found - run 'mvn package' to build"
fi

# Check deployment
echo ""
echo -e "${BLUE}📋 Checking Deployment${NC}"
echo "----------------------------------------"

if [ -f "/opt/tomcat/webapps/course-management-system-1.0.0.war" ]; then
    echo -e "${GREEN}✅${NC} Application WAR deployed to Tomcat"
else
    echo -e "${RED}❌${NC} Application WAR not deployed to Tomcat"
fi

if [ -d "/opt/tomcat/webapps/course-management-system-1.0.0" ]; then
    echo -e "${GREEN}✅${NC} Application extracted and running"
else
    echo -e "${YELLOW}⚠️${NC} Application directory not found (may still be extracting)"
fi

# Check database
echo ""
echo -e "${BLUE}📋 Checking Database${NC}"
echo "----------------------------------------"

# Test database connection
if mysql -u courseapp -p'MyApp123@' -e "USE course_management_db; SELECT 'Database connection successful' as Status;" 2>/dev/null; then
    echo -e "${GREEN}✅${NC} Database connection successful"
    
    # Check if tables exist
    TABLES=$(mysql -u courseapp -p'MyApp123@' -D course_management_db -e "SHOW TABLES;" 2>/dev/null | grep -v Tables_in)
    if [ -n "$TABLES" ]; then
        echo -e "${GREEN}✅${NC} Database tables found:"
        echo "$TABLES" | sed 's/^/   - /'
    else
        echo -e "${YELLOW}⚠️${NC} No tables found (will be created on first login)"
    fi
else
    echo -e "${RED}❌${NC} Database connection failed"
    echo -e "   ${YELLOW}Check:${NC} MySQL credentials and database existence"
fi

# Test web application
echo ""
echo -e "${BLUE}📋 Checking Web Application${NC}"
echo "----------------------------------------"

# Wait a moment for Tomcat to fully start
sleep 2

# Test if application is responding
if curl -s -o /dev/null -w "%{http_code}" "http://localhost:8080/course-management-system-1.0.0/" | grep -q "200\|302"; then
    echo -e "${GREEN}✅${NC} Web application is responding"
    echo "   URL: http://localhost:8080/course-management-system-1.0.0/"
else
    echo -e "${RED}❌${NC} Web application is not responding"
    echo -e "   ${YELLOW}Check:${NC} Tomcat logs for errors"
fi

# Summary
echo ""
echo -e "${BLUE}📊 Summary${NC}"
echo "----------------------------------------"

TOTAL_CHECKS=0
PASSED_CHECKS=0

# Quick recheck of critical components
if command -v java >/dev/null 2>&1; then ((PASSED_CHECKS++)); fi; ((TOTAL_CHECKS++))
if command -v mvn >/dev/null 2>&1; then ((PASSED_CHECKS++)); fi; ((TOTAL_CHECKS++))
if command -v mysql >/dev/null 2>&1; then ((PASSED_CHECKS++)); fi; ((TOTAL_CHECKS++))
if sudo systemctl is-active --quiet mysql; then ((PASSED_CHECKS++)); fi; ((TOTAL_CHECKS++))
if sudo systemctl is-active --quiet tomcat; then ((PASSED_CHECKS++)); fi; ((TOTAL_CHECKS++))

echo "Passed: $PASSED_CHECKS/$TOTAL_CHECKS critical checks"

if [ $PASSED_CHECKS -eq $TOTAL_CHECKS ]; then
    echo -e "${GREEN}🎉 All systems are ready!${NC}"
    echo ""
    echo "🔗 Access your application at:"
    echo "   http://localhost:8080/course-management-system-1.0.0/"
    echo ""
    echo "🔑 Default Login Credentials:"
    echo "   Admin:   admin    / password123"
    echo "   Teacher: teacher1 / password123"
    echo "   Student: student1 / password123"
else
    echo -e "${YELLOW}⚠️ Some issues found. Please fix them before proceeding.${NC}"
    echo ""
    echo "🔧 Common fixes:"
    echo "   - Start services: sudo systemctl start mysql tomcat"
    echo "   - Build project: mvn clean package"
    echo "   - Deploy WAR: sudo cp target/*.war /opt/tomcat/webapps/"
    echo "   - Check logs: sudo tail -f /opt/tomcat/logs/catalina.out"
fi

echo ""
echo "📋 Useful Commands:"
echo "   Check Tomcat status:  sudo systemctl status tomcat"
echo "   Check MySQL status:   sudo systemctl status mysql"
echo "   View Tomcat logs:     sudo tail -f /opt/tomcat/logs/catalina.out"
echo "   Restart Tomcat:       sudo systemctl restart tomcat"
echo "   Rebuild project:      mvn clean package"
