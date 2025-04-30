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
