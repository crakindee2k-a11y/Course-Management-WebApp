package com.coursemanagement.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.TimeUnit;

/**
 * Simple database connection pool.
 */
public class ConnectionPool {
    
    private static final int DEFAULT_POOL_SIZE = 20;
    private static final int CONNECTION_TIMEOUT = 10; // seconds
    private static final int VALIDATION_TIMEOUT = 2; // seconds for isValid() check
    
    private final BlockingQueue<Connection> pool;
    private final String dbUrl;
    private final String dbUsername;
    private final String dbPassword;
    private static ConnectionPool instance;
    
    /**
     * Private constructor for singleton pattern
     */
    private ConnectionPool(String dbUrl, String dbUsername, String dbPassword, int poolSize) {
        this.dbUrl = dbUrl;
        this.dbUsername = dbUsername;
        this.dbPassword = dbPassword;
        this.pool = new ArrayBlockingQueue<>(poolSize);
        
        // Initialize pool with connections
        initializePool(poolSize);
    }
    
    /**
     * Get singleton instance of connection pool
     */
    public static synchronized ConnectionPool getInstance(String dbUrl, String dbUsername, String dbPassword) {
        if (instance == null) {
            instance = new ConnectionPool(dbUrl, dbUsername, dbPassword, DEFAULT_POOL_SIZE);
        }
        return instance;
    }
    
    /**
     * Initialize the connection pool with the specified number of connections
     */
    private void initializePool(int poolSize) {
        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
            // Create initial connections
            for (int i = 0; i < poolSize; i++) {
                Connection conn = createNewConnection();
                if (conn != null) {
                    pool.offer(conn);
                }
            }
            
            System.out.println("Connection pool initialized with " + pool.size() + " connections");
            
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
            throw new RuntimeException("Failed to initialize connection pool", e);
        }
    }
    
    /**
     * Create a new database connection
     */
    private Connection createNewConnection() {
        try {
            return DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        } catch (SQLException e) {
            System.err.println("Failed to create new connection: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get a connection from the pool
     */
    public Connection getConnection() throws SQLException {
        try {
            Connection conn = pool.poll(CONNECTION_TIMEOUT, TimeUnit.SECONDS);
            
            if (conn == null) {
                // Pool exhausted, try to create a new connection
                System.err.println("Connection pool exhausted, creating new connection");
                conn = createNewConnection();
                if (conn == null) {
                    throw new SQLException("Connection pool timeout - no connections available");
                }
                return new PooledConnectionWrapper(conn, this);
            }
            
            // Check if connection is still valid
            try {
                if (conn.isClosed() || !conn.isValid(VALIDATION_TIMEOUT)) {
                    // Connection is invalid, close it properly and create a new one
                    closeQuietly(conn);
                    conn = createNewConnection();
                    if (conn == null) {
                        throw new SQLException("Failed to create new database connection");
                    }
                }
            } catch (SQLException e) {
                // Connection check failed, close and create new
                closeQuietly(conn);
                conn = createNewConnection();
                if (conn == null) {
                    throw new SQLException("Failed to create new database connection");
                }
            }
            
            // Return a wrapped connection that will return to pool on close
            return new PooledConnectionWrapper(conn, this);
            
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new SQLException("Interrupted while waiting for connection", e);
        }
    }
    
    /**
     * Return a connection to the pool
     */
    public void returnConnection(Connection conn) {
        if (conn != null) {
            try {
                // Validate connection before returning to pool
                if (conn.isClosed()) {
                    return; // Don't return closed connections
                }
                
                // Quick validation check
                if (!conn.isValid(1)) {
                    closeQuietly(conn);
                    return; // Don't return invalid connections
                }
                
                // Reset connection state
                conn.setAutoCommit(true);
                conn.clearWarnings();
                
                // Return to pool if there's space
                if (!pool.offer(conn)) {
                    // Pool is full, close the connection
                    closeQuietly(conn);
                }
            } catch (SQLException e) {
                System.err.println("Error returning connection to pool: " + e.getMessage());
                closeQuietly(conn);
            }
        }
    }
    
    /**
     * Close a connection quietly without throwing exceptions
     */
    private void closeQuietly(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
            }
        }
    }
    
    /**
     * Close all connections and shutdown the pool
     */
    public void shutdown() {
        Connection conn;
        while ((conn = pool.poll()) != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection during shutdown: " + e.getMessage());
            }
        }
        System.out.println("Connection pool shutdown complete");
    }
    
    /**
     * Get current pool statistics
     */
    public String getPoolStats() {
        return String.format("Connection Pool - Available: %d, Capacity: %d", 
                           pool.size(), pool.remainingCapacity() + pool.size());
    }
    
    /**
     * Reset the singleton instance (for testing or config changes).
     * Shuts down existing pool first.
     */
    public static synchronized void resetInstance() {
        if (instance != null) {
            instance.shutdown();
            instance = null;
        }
    }
}
