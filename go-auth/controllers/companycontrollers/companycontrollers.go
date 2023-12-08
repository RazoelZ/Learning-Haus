package companycontrollers

import (
	"github.com/RazoelZ/go-auth/helper"
	"github.com/RazoelZ/go-auth/models"
	"github.com/gofiber/fiber/v2"
)

func CreateCompany(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		company := new(models.Company)

		if err := c.BodyParser(company); err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"message": "Error parsing request body",
				"error":   err.Error(),
			})
		}

		// fmt.printf("Request Body: %v\n", company)

		err := r.DB.Create(&company).Error

		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error creating company",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"message": "Company successfully created",
			"data":    company,
		})

	}
}
