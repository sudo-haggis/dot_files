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
