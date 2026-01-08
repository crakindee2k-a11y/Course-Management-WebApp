package com.coursemanagement.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for password hashing and verification using BCrypt.
 */
public class PasswordUtil {
    
    /**
     * The number of rounds to use for BCrypt hashing.
     * Higher values provide better security but take more time.
     */
    private static final int BCRYPT_ROUNDS = 10;
    
    /**
     * Hashes a password using BCrypt
     * 
     * @param plainTextPassword The plain text password to hash
     * @return The hashed password
     * @throws IllegalArgumentException if the password is null or empty
     */
    public static String hashPassword(String plainTextPassword) {
        if (plainTextPassword == null || plainTextPassword.trim().isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt(BCRYPT_ROUNDS));
    }
    
    /**
     * Verifies a plain text password against a hashed password
     * 
     * @param plainTextPassword The plain text password to verify
     * @param hashedPassword The hashed password to verify against
     * @return true if the passwords match, false otherwise
     */
    public static boolean verifyPassword(String plainTextPassword, String hashedPassword) {
        if (plainTextPassword == null || hashedPassword == null) {
            return false;
        }
        
        try {
            return BCrypt.checkpw(plainTextPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            // This can happen if the hashedPassword is not a valid BCrypt hash
            System.err.println("Invalid BCrypt hash: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Generates a random salt for BCrypt hashing
     * This method is primarily for testing or manual password generation
     * 
     * @return A BCrypt salt string
     */
    public static String generateSalt() {
        return BCrypt.gensalt(BCRYPT_ROUNDS);
    }
    
    /**
     * Checks if a password meets basic security requirements
     * 
     * @param password The password to validate
     * @return true if the password is valid, false otherwise
     */
    public static boolean isValidPassword(String password) {
        if (password == null) {
            return false;
        }
        
        // Check minimum length
        if (password.length() < 6) {
            return false;
        }
        
        // Check maximum length (to prevent DoS attacks)
        if (password.length() > 128) {
            return false;
        }
        
        // Password should contain at least one letter or number
        boolean hasAlphaNumeric = password.matches(".*[a-zA-Z0-9].*");
        
        return hasAlphaNumeric;
    }
    
    /**
     * Gets password validation error message
     * 
     * @param password The password to validate
     * @return Error message if password is invalid, null if password is valid
     */
    public static String getPasswordValidationError(String password) {
        if (password == null) {
            return "Password cannot be null";
        }
        
        if (password.length() < 6) {
            return "Password must be at least 6 characters long";
        }
        
        if (password.length() > 128) {
            return "Password must not exceed 128 characters";
        }
        
        if (!password.matches(".*[a-zA-Z0-9].*")) {
            return "Password must contain at least one letter or number";
        }
        
        return null; // Password is valid
    }
    
    /**
     * Securely compares two strings to prevent timing attacks
     * This is used for comparing sensitive data like tokens or hashes
     * 
     * @param a First string
     * @param b Second string
     * @return true if strings are equal, false otherwise
     */
    public static boolean secureEquals(String a, String b) {
        if (a == null || b == null) {
            return a == b;
        }
        
        if (a.length() != b.length()) {
            return false;
        }
        
        int result = 0;
        for (int i = 0; i < a.length(); i++) {
            result |= a.charAt(i) ^ b.charAt(i);
        }
        
        return result == 0;
    }
}
