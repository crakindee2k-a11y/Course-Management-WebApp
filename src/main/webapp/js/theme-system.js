/**
 * Production-Grade Theme System
 * Handles light/dark mode switching with smooth transitions and persistence
 */

class ThemeController {
    constructor() {
        this.STORAGE_KEY = 'app-theme';
        this.THEME_ATTRIBUTE = 'data-theme';
        this.currentTheme = this.getStoredTheme() || this.getSystemTheme();
        
        this.init();
    }

    /**
     * Initialize the theme system
     */
    init() {
        this.applyTheme(this.currentTheme, false);
        this.createToggleButton();
        this.bindEvents();
        this.preventFlash();
    }

    /**
     * Get stored theme from localStorage
     */
    getStoredTheme() {
        try {
            return localStorage.getItem(this.STORAGE_KEY);
        } catch (e) {
            console.warn('Failed to access localStorage:', e);
            return null;
        }
    }

    /**
     * Get system theme preference
     */
    getSystemTheme() {
        try {
            if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
                return 'dark';
            }
        } catch (e) {
            console.warn('Failed to check system theme:', e);
        }
        return 'light';
    }

    /**
     * Store theme preference
     */
    storeTheme(theme) {
        try {
            localStorage.setItem(this.STORAGE_KEY, theme);
        } catch (e) {
            console.warn('Failed to store theme:', e);
        }
    }

    /**
     * Apply theme to the document
     */
    applyTheme(theme, animate = true) {
        const root = document.documentElement;
        
        // Add transition class for smooth switching
        if (animate) {
            root.style.setProperty('--transition-duration', '0.3s');
        }

        // Set theme attribute
        root.setAttribute(this.THEME_ATTRIBUTE, theme);
        
        // Update meta theme-color for mobile browsers
        this.updateMetaThemeColor(theme);
        
        // Update toggle button if it exists
        this.updateToggleButton(theme);
        
        // Store the current theme
        this.currentTheme = theme;
        this.storeTheme(theme);

        // Remove transition after animation completes
        if (animate) {
            setTimeout(() => {
                root.style.removeProperty('--transition-duration');
            }, 300);
        }
        
        // Dispatch custom event for other components
        this.dispatchThemeChangeEvent(theme);
    }

    /**
     * Toggle between light and dark themes
     */
    toggleTheme() {
        const newTheme = this.currentTheme === 'light' ? 'dark' : 'light';
        this.applyTheme(newTheme, true);
    }

    /**
     * Create theme toggle button
     */
    createToggleButton() {
        // Check if button already exists (e.g., in login.jsp)
        const existingButton = document.getElementById('theme-toggle');
        if (existingButton) {
            // Update existing button with correct icon
            this.updateToggleButton(this.currentTheme, existingButton);
            return;
        }

        // If we're on a dashboard page, create navbar button
        const navbar = document.querySelector('.navbar-nav');
        if (navbar) {
            // Create button container
            const buttonContainer = document.createElement('li');
            buttonContainer.className = 'nav-item';

            // Create toggle button
            const toggleButton = document.createElement('button');
            toggleButton.id = 'theme-toggle';
            toggleButton.className = 'theme-toggle me-2';
            toggleButton.setAttribute('aria-label', 'Toggle theme');
            toggleButton.setAttribute('title', 'Toggle light/dark mode');
            
            // Set initial icon
            this.updateToggleButton(this.currentTheme, toggleButton);
            
            buttonContainer.appendChild(toggleButton);

            // Insert before user dropdown or at the end
            const userDropdown = navbar.querySelector('.dropdown');
            if (userDropdown) {
                navbar.insertBefore(buttonContainer, userDropdown);
            } else {
                navbar.appendChild(buttonContainer);
            }
            return;
        }

        console.warn('No suitable container found for theme toggle button');
    }

    /**
     * Update toggle button icon and aria-label
     */
    updateToggleButton(theme, button = null) {
        const toggleButton = button || document.getElementById('theme-toggle');
        if (!toggleButton) return;

        const isDark = theme === 'dark';
        const label = isDark ? 'Switch to light mode' : 'Switch to dark mode';
        
        // Check if this is a login page button (has specific styling)
        const isLoginPage = toggleButton.style.width === '32px';
        
        if (isLoginPage) {
            // Login page uses smaller Bootstrap icons
            const icon = isDark ? 'bi-sun-fill' : 'bi-moon-fill';
            toggleButton.innerHTML = `<i class="bi ${icon}" style="font-size: 0.9rem;"></i>`;
        } else {
            // Regular pages use larger Bootstrap icons
            const icon = isDark ? 'bi-sun-fill' : 'bi-moon-fill';
            toggleButton.innerHTML = `<i class="bi ${icon} fs-5"></i>`;
        }
        
        toggleButton.setAttribute('aria-label', label);
        toggleButton.setAttribute('title', label);
    }

    /**
     * Bind event listeners
     */
    bindEvents() {
        // Theme toggle button click
        document.addEventListener('click', (e) => {
            if (e.target.closest('#theme-toggle')) {
                e.preventDefault();
                this.toggleTheme();
            }
        });

        // Keyboard shortcut (Ctrl/Cmd + Shift + D)
        document.addEventListener('keydown', (e) => {
            if ((e.ctrlKey || e.metaKey) && e.shiftKey && e.key === 'D') {
                e.preventDefault();
                this.toggleTheme();
            }
        });

        // Listen for system theme changes
        if (window.matchMedia) {
            try {
                const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
                mediaQuery.addEventListener('change', (e) => {
                    // Only auto-switch if user hasn't manually set a preference
                    if (!this.getStoredTheme()) {
                        this.applyTheme(e.matches ? 'dark' : 'light', true);
                    }
                });
            } catch (e) {
                console.warn('Failed to listen for system theme changes:', e);
            }
        }

        // Focus management for interactive elements
        this.bindFocusManagement();
    }

    /**
     * Bind focus management events to prevent persistent outlines after clicks
     */
    bindFocusManagement() {
        // Clear focus after clicking on interactive cards and elements
        document.addEventListener('click', (e) => {
            // Find the clicked element or its clickable parent
            const clickableElement = e.target.closest([
                '.clickable-card',
                '.card[data-clickable="true"]',
                '.card[onclick]',
                '.dashboard-stat[data-clickable="true"]',
                '.dashboard-stat[onclick]',
                '.dashboard-stat.clickable',
                'a[href]',
                '.btn'
            ].join(', '));

            if (clickableElement) {
                // Small delay to allow the click action to complete first
                setTimeout(() => {
                    clickableElement.blur();
                }, 50);
            }
        });

        // Ensure proper focus management for keyboard navigation
        document.addEventListener('keydown', (e) => {
            // If Tab or Shift+Tab is pressed, don't interfere with focus
            if (e.key === 'Tab') {
                return;
            }
            
            // If Enter or Space is pressed on a focused element, clear focus after action
            if ((e.key === 'Enter' || e.key === ' ') && document.activeElement) {
                const focusedElement = document.activeElement;
                if (focusedElement.matches([
                    '.clickable-card',
                    '.card[data-clickable="true"]',
                    '.card[onclick]',
                    '.dashboard-stat[data-clickable="true"]',
                    '.dashboard-stat[onclick]',
                    '.dashboard-stat.clickable'
                ].join(', '))) {
                    setTimeout(() => {
                        focusedElement.blur();
                    }, 100);
                }
            }
        });
    }

    /**
     * Prevent initial flash of wrong theme
     */
    preventFlash() {
        // Remove any existing flash prevention styles
        const existingStyle = document.getElementById('theme-flash-prevention');
        if (existingStyle) {
            existingStyle.remove();
        }
    }

    /**
     * Update meta theme-color for mobile browsers
     */
    updateMetaThemeColor(theme) {
        let metaThemeColor = document.querySelector('meta[name="theme-color"]');
        
        if (!metaThemeColor) {
            metaThemeColor = document.createElement('meta');
            metaThemeColor.name = 'theme-color';
            document.head.appendChild(metaThemeColor);
        }
        
        const color = theme === 'dark' ? '#1a1a1d' : '#f8fafc';
        metaThemeColor.content = color;
    }

    /**
     * Dispatch custom theme change event
     */
    dispatchThemeChangeEvent(theme) {
        const event = new CustomEvent('themechange', {
            detail: { theme, controller: this }
        });
        document.dispatchEvent(event);
    }

    /**
     * Get current theme
     */
    getCurrentTheme() {
        return this.currentTheme;
    }

    /**
     * Set specific theme
     */
    setTheme(theme) {
        if (theme === 'light' || theme === 'dark') {
            this.applyTheme(theme, true);
        } else {
            console.warn('Invalid theme:', theme);
        }
    }
}

/**
 * Initialize theme system when DOM is ready
 */
function initThemeSystem() {
    // Create global theme controller instance
    window.themeController = new ThemeController();
    
    // Add helpful console message
    if (window.console && console.info) {
        console.info('🎨 Theme System Loaded! Use Ctrl/Cmd + Shift + D to toggle themes.');
    }
}

// Auto-initialize when DOM is loaded
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initThemeSystem);
} else {
    initThemeSystem();
}

// Also expose for manual initialization if needed
window.initThemeSystem = initThemeSystem;
