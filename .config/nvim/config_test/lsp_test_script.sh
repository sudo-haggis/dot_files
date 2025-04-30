#!/bin/bash
# LSP functionality test script
# This script creates test files for different languages to verify LSP functionality

# Set output directory
TEST_DIR="$HOME/lsp_test"
mkdir -p "$TEST_DIR"
echo "Creating test files in $TEST_DIR"

# Create Python test file
cat > "$TEST_DIR/python_test.py" << 'EOF'
import os
import sys
from datetime import datetime, timedelta

# Test function with docstring for hover documentation
def calculate_future_date(days_to_add: int) -> datetime:
    """
    Calculate a future date by adding a specified number of days to today.
    
    Args:
        days_to_add: Number of days to add to the current date
        
    Returns:
        A datetime object representing the future date
    """
    today = datetime.now()
    future = today + timedelta(days=days_to_add)
    return future

# Class to test completion and documentation
class DataProcessor:
    def __init__(self, data_source: str):
        """
        Initialize a data processor with a source.
        
        Args:
            data_source: Path to the data source
        """
        self.data_source = data_source
        self.data = None
    
    def load_data(self):
        """Load data from the data source."""
        if os.path.exists(self.data_source):
            with open(self.data_source, 'r') as f:
                self.data = f.read()
    
    def process_data(self, filter_func=None):
        """
        Process the loaded data, optionally applying a filter.
        
        Args:
            filter_func: Optional function to filter data
        
        Returns:
            Processed data
        """
        if self.data is None:
            self.load_data()
        
        # Test auto-completion by typing: result = self.data.
        result = self.data
        
        if filter_func:
            result = filter_func(result)
        
        return result

# Test the functionality
# To test hovering: place cursor over calculate_future_date and press K
future = calculate_future_date(10)
print(f"Future date: {future}")

# To test completion: 
# 1. Type "processor = DataProcessor(" and check for parameter hints
# 2. Type "processor." and check for method suggestions
processor = DataProcessor("sample.txt")

# To test go to definition:
# Place cursor on DataProcessor and press gd
processor.load_data()

# Test os module completion:
# Type "os." and see completion options
current_dir = os.getcwd()
EOF

# Create PHP test file
cat > "$TEST_DIR/php_test.php" << 'EOF'
<?php

/**
 * Calculate the area of a rectangle
 * 
 * @param float $width Width of the rectangle
 * @param float $height Height of the rectangle
 * @return float Area of the rectangle
 */
function calculateRectangleArea(float $width, float $height): float {
    return $width * $height;
}

/**
 * User class for testing LSP functionality
 */
class User {
    private int $id;
    private string $name;
    private string $email;
    
    /**
     * Create a new user
     * 
     * @param string $name User's name
     * @param string $email User's email
     */
    public function __construct(string $name, string $email) {
        $this->name = $name;
        $this->email = $email;
        $this->id = rand(1, 1000);
    }
    
    /**
     * Get user's display name
     * 
     * @return string Formatted display name
     */
    public function getDisplayName(): string {
        return "#" . $this->id . " - " . $this->name;
    }
    
    /**
     * Send an email to the user
     * 
     * @param string $subject Email subject
     * @param string $message Email body
     * @return bool Success status
     */
    public function sendEmail(string $subject, string $message): bool {
        // Simulated email sending
        echo "Sending email to: " . $this->email . "\n";
        echo "Subject: " . $subject . "\n";
        return true;
    }
}

// Test hovering: Place cursor over calculateRectangleArea and press K
$area = calculateRectangleArea(5.0, 10.0);
echo "Rectangle area: " . $area . "\n";

// Test completion: 
// 1. Type "$user = new User(" and check for parameter hints
// 2. Type "$user->" and check for method suggestions
$user = new User("John Doe", "john@example.com");

// Test go to definition:
// Place cursor on User and press gd
$displayName = $user->getDisplayName();
echo $displayName . "\n";

// Test method completion:
// Type "$user->" and see completion options
$user->sendEmail("Test Subject", "Hello, this is a test email");
EOF

# Create JavaScript test file
cat > "$TEST_DIR/javascript_test.js" << 'EOF'
/**
 * Calculate compound interest over time
 * @param {number} principal - Initial investment amount
 * @param {number} rate - Interest rate as a decimal (e.g., 0.05 for 5%)
 * @param {number} time - Time in years
 * @param {number} [compounds=1] - Number of times interest is compounded per year
 * @returns {number} The final amount after compound interest
 */
function calculateCompoundInterest(principal, rate, time, compounds = 1) {
    return principal * Math.pow(1 + rate / compounds, compounds * time);
}

/**
 * A task management class for testing LSP functionality
 */
class TaskManager {
    /**
     * Create a new task manager
     * @param {string} [owner='Admin'] - The owner of this task manager
     */
    constructor(owner = 'Admin') {
        this.owner = owner;
        this.tasks = [];
    }
    
    /**
     * Add a new task to the manager
     * @param {string} title - Task title
     * @param {string} [description=''] - Task description
     * @param {number} [priority=1] - Task priority (1-5)
     * @returns {object} The created task
     */
    addTask(title, description = '', priority = 1) {
        const task = {
            id: this.tasks.length + 1,
            title,
            description,
            priority,
            completed: false,
            createdAt: new Date()
        };
        
        this.tasks.push(task);
        return task;
    }
    
    /**
     * Mark a task as completed
     * @param {number} taskId - ID of the task to complete
     * @returns {boolean} Success status
     */
    completeTask(taskId) {
        const task = this.tasks.find(t => t.id === taskId);
        if (task) {
            task.completed = true;
            return true;
        }
        return false;
    }
    
    /**
     * Get all tasks, optionally filtered by completion status
     * @param {boolean} [onlyCompleted] - Filter to show only completed tasks
     * @returns {Array} List of matching tasks
     */
    getTasks(onlyCompleted) {
        if (onlyCompleted !== undefined) {
            return this.tasks.filter(task => task.completed === onlyCompleted);
        }
        return [...this.tasks];
    }
}

// Test hovering: Place cursor over calculateCompoundInterest and press K
const investment = calculateCompoundInterest(1000, 0.05, 5, 12);
console.log(`Final investment value: ${investment.toFixed(2)}`);

// Test completion: 
// 1. Type "const manager = new TaskManager(" and check for parameter hints
// 2. Type "manager." and check for method suggestions
const manager = new TaskManager("John");

// Test go to definition:
// Place cursor on TaskManager and press gd
const task = manager.addTask("Learn LSP", "Test the Language Server Protocol in Neovim");

// Test method completion:
// Type "manager." and see completion options
manager.completeTask(task.id);
const completedTasks = manager.getTasks(true);

// Test native JS object completion:
// Type "Math." and see completion options
const randomValue = Math.random();
EOF

# Create Go test file
cat > "$TEST_DIR/go_test.go" << 'EOF'
package main

import (
	"fmt"
	"time"
)

// User represents a system user
type User struct {
	ID        int
	Username  string
	Email     string
	CreatedAt time.Time
}

// NewUser creates a new user with the given username and email
func NewUser(username, email string) *User {
	return &User{
		ID:        1,
		Username:  username,
		Email:     email,
		CreatedAt: time.Now(),
	}
}

// FormatUser returns a formatted string representation of the user
func (u *User) FormatUser() string {
	return fmt.Sprintf("User %d: %s <%s>", u.ID, u.Username, u.Email)
}

// IsValid checks if the user has valid data
func (u *User) IsValid() bool {
	return u.Username != "" && u.Email != ""
}

// CalculateAge calculates a person's age based on birthdate
func CalculateAge(birthYear, birthMonth, birthDay int) int {
	now := time.Now()
	currentYear, currentMonth, currentDay := now.Date()
	
	age := currentYear - birthYear
	
	if currentMonth < time.Month(birthMonth) || 
	   (currentMonth == time.Month(birthMonth) && currentDay < birthDay) {
		age--
	}
	
	return age
}

func main() {
	// Test hovering: Place cursor over CalculateAge and press K
	age := CalculateAge(1990, 6, 15)
	fmt.Printf("Age: %d years\n", age)
	
	// Test completion: 
	// 1. Type "user := NewUser(" and check for parameter hints
	// 2. Type "user." and check for method suggestions
	user := NewUser("johndoe", "john@example.com")
	
	// Test go to definition:
	// Place cursor on User or NewUser and press gd
	formatted := user.FormatUser()
	fmt.Println(formatted)
	
	// Test method completion:
	// Type "user." and see completion options
	if user.IsValid() {
		fmt.Println("User is valid!")
	}
	
	// Test standard library completion:
	// Type "time." and see completion options
	currentTime := time.Now()
	fmt.Println("Current time:", currentTime.Format(time.RFC3339))
}
EOF

echo "Test files created successfully!"
echo ""
echo "Instructions to test LSP functionality:"
echo "--------------------------------------"
echo "1. Open any of the test files in Neovim:"
echo "   nvim $TEST_DIR/python_test.py"
echo "   nvim $TEST_DIR/php_test.py"
echo "   nvim $TEST_DIR/javascript_test.js"
echo "   nvim $TEST_DIR/go_test.go"
echo ""
echo "2. Test hover documentation:"
echo "   - Place cursor over a function name and press K"
echo ""
echo "3. Test code completion:"
echo "   - Start typing a function call with parameters"
echo "   - Type object. to see method completion"
echo ""
echo "4. Test go to definition:"
echo "   - Place cursor on a class or function name and press gd"
echo ""
echo "5. Test signature help:"
echo "   - Start typing a function call and check for parameter info"
echo ""
echo "6. Check LSP status:"
echo "   - Run :LspInfo to see active language servers"
echo "   - Run :LspStatus to see client attachments"
echo ""
