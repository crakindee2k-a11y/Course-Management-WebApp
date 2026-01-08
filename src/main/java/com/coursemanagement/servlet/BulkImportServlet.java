package com.coursemanagement.servlet;

import com.coursemanagement.dao.CourseDAO;
import com.coursemanagement.dao.UserDAO;
import com.coursemanagement.model.Course;
import com.coursemanagement.model.User;
import com.coursemanagement.util.PasswordUtil;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@WebServlet("/admin/bulk-import")
@MultipartConfig
public class BulkImportServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        Part filePart = request.getPart("file");

        if (filePart == null || filePart.getSize() == 0) {
            request.getSession().setAttribute("errorMessage", "Please select a file to upload.");
            response.sendRedirect(request.getHeader("Referer"));
            return;
        }
        
        String fileName = filePart.getSubmittedFileName();
        InputStream fileContent = filePart.getInputStream();

        String redirectUrl = "";
        String successMessage = "";
        String errorMessage = "";

        try {
            if ("users".equals(type)) {
                redirectUrl = request.getContextPath() + "/admin/users";
                List<User> users = parseUsers(fileContent, fileName);
                UserDAO userDAO = new UserDAO();
                for (User user : users) {
                    userDAO.createUser(user);
                }
                successMessage = users.size() + " users imported successfully.";
            } else if ("courses".equals(type)) {
                redirectUrl = request.getContextPath() + "/admin/courses";
                List<Course> courses = parseCourses(fileContent, fileName);
                CourseDAO courseDAO = new CourseDAO();
                for (Course course : courses) {
                    courseDAO.createCourse(course);
                }
                successMessage = courses.size() + " courses imported successfully.";
            } else {
                throw new ServletException("Invalid import type.");
            }
            request.getSession().setAttribute("successMessage", successMessage);
        } catch (Exception e) {
            e.printStackTrace();
            errorMessage = "Error importing file: " + e.getMessage();
            request.getSession().setAttribute("errorMessage", errorMessage);
        }
        
        response.sendRedirect(redirectUrl);
    }

    private List<User> parseUsers(InputStream inputStream, String fileName) throws IOException {
        List<User> users = new ArrayList<>();
        if (fileName.endsWith(".xlsx")) {
            // Excel parsing
            Workbook workbook = new XSSFWorkbook(inputStream);
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> iterator = sheet.iterator();

            // Skip header row
            if (iterator.hasNext()) {
                iterator.next();
            }

            while (iterator.hasNext()) {
                Row currentRow = iterator.next();
                User user = new User();
                user.setUsername(getCellValue(currentRow.getCell(0)));
                user.setEmail(getCellValue(currentRow.getCell(1)));
                String hashedPassword = PasswordUtil.hashPassword(getCellValue(currentRow.getCell(2)));
                user.setPassword(hashedPassword);
                user.setFullName(getCellValue(currentRow.getCell(3)));
                user.setUserType(User.UserType.valueOf(getCellValue(currentRow.getCell(4)).toUpperCase()));
                users.add(user);
            }
            workbook.close();
        } else if (fileName.endsWith(".csv")) {
            // CSV parsing
            try (Reader reader = new InputStreamReader(inputStream);
                 CSVParser csvParser = new CSVParser(reader, CSVFormat.DEFAULT.withFirstRecordAsHeader().withTrim())) {

                for (CSVRecord csvRecord : csvParser) {
                    User user = new User();
                    user.setUsername(csvRecord.get("username"));
                    user.setEmail(csvRecord.get("email"));
                    String hashedPassword = PasswordUtil.hashPassword(csvRecord.get("password"));
                    user.setPassword(hashedPassword);
                    user.setFullName(csvRecord.get("fullName"));
                    user.setUserType(User.UserType.valueOf(csvRecord.get("userType").toUpperCase()));
                    users.add(user);
                }
            }
        }
        return users;
    }

    private List<Course> parseCourses(InputStream inputStream, String fileName) throws IOException {
        List<Course> courses = new ArrayList<>();
        if (fileName.endsWith(".xlsx")) {
            // Excel parsing
            Workbook workbook = new XSSFWorkbook(inputStream);
            Sheet sheet = workbook.getSheetAt(0);
            Iterator<Row> iterator = sheet.iterator();
            
            // Skip header row
            if (iterator.hasNext()) {
                iterator.next();
            }

            while (iterator.hasNext()) {
                Row currentRow = iterator.next();
                Course course = new Course();
                course.setCourseCode(getCellValue(currentRow.getCell(0)));
                course.setCourseName(getCellValue(currentRow.getCell(1)));
                course.setDescription(getCellValue(currentRow.getCell(2)));
                course.setCredits((int) Double.parseDouble(getCellValue(currentRow.getCell(3))));
                course.setMaxStudents((int) Double.parseDouble(getCellValue(currentRow.getCell(4))));
                String teacherIdStr = getCellValue(currentRow.getCell(5));
                if (teacherIdStr != null && !teacherIdStr.isEmpty()) {
                    course.setTeacherId(Integer.parseInt(teacherIdStr));
                }
                courses.add(course);
            }
            workbook.close();
        } else if (fileName.endsWith(".csv")) {
            // CSV parsing
            try (Reader reader = new InputStreamReader(inputStream);
                 CSVParser csvParser = new CSVParser(reader, CSVFormat.DEFAULT.withFirstRecordAsHeader().withTrim())) {
                
                for (CSVRecord csvRecord : csvParser) {
                    Course course = new Course();
                    course.setCourseCode(csvRecord.get("courseCode"));
                    course.setCourseName(csvRecord.get("courseName"));
                    course.setDescription(csvRecord.get("description"));
                    course.setCredits(Integer.parseInt(csvRecord.get("credits")));
                    course.setMaxStudents(Integer.parseInt(csvRecord.get("maxStudents")));
                    String teacherIdStr = csvRecord.get("teacherId");
                    if (teacherIdStr != null && !teacherIdStr.isEmpty()) {
                        course.setTeacherId(Integer.parseInt(teacherIdStr));
                    }
                    courses.add(course);
                }
            }
        }
        return courses;
    }
    
    private String getCellValue(Cell cell) {
        if (cell == null) {
            return "";
        }
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                return String.valueOf(cell.getNumericCellValue());
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "";
        }
    }
}
