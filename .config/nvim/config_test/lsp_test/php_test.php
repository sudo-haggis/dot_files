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
