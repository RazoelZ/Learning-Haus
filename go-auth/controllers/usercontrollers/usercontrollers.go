// controllers/usercontrollers.go

package usercontrollers

import (
	"fmt"
	"log"

	"github.com/RazoelZ/go-auth/helper"
	"github.com/RazoelZ/go-auth/models"
	"github.com/gofiber/fiber/v2"
)

func Index(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		var users []models.User

		err := r.DB.Find(&users).Error

		if err != nil {
			log.Printf("Error retrieving users: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error retrieving users",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"message": "Successfully retrieved users",
			"data":    users,
		})
	}
}

func Register(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		user := new(models.User)

		if err := c.BodyParser(user); err != nil {
			log.Printf("Error parsing request body: %s", err)
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"message": "Error parsing request body",
				"error":   err.Error(),
			})
		}

		// Uncomment the next line if you want to log the request body
		fmt.Printf("Request Body: %v\n", user)

		err := r.DB.Create(&user).Error

		if err != nil {
			log.Printf("Error creating user: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error creating user",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"message": "User successfully created",
			"data":    user,
		})
	}
}
