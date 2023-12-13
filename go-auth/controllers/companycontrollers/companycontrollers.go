package companycontrollers

import (
	"strconv"

	"github.com/RazoelZ/Learning-Haus/go-auth/helper"
	"github.com/RazoelZ/Learning-Haus/go-auth/models"

	"github.com/gofiber/fiber/v2"
)

func GetAllCompanies(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		var companies []models.Company

		err := r.DB.Find(&companies).Error

		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error getting companies",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "All companies",
			"data":    companies,
		})
	}
}

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
			"status":  "success",
			"message": "Company successfully created",
			"data":    company,
		})

	}
}

// INI COBA WKWKWKKWKW
func GetFilterCompanies(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		var companies []models.Company
		var companiesFilter models.Company

		// Get the "id" query parameter
		id := c.Query("id")
		if id == "" {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"message": "Missing required 'id' parameter",
			})
		}

		// Convert the "id" to uint64
		companyId, err := strconv.ParseUint(id, 10, 64)
		if err != nil {
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"message": "Error parsing 'id'",
				"error":   err.Error(),
			})
		}
		companiesFilter.CompanyID = uint(companyId)

		// Get companies from the database based on the filtered ID
		err = r.DB.Where("company_id = ?", companyId).Find(&companies).Error
		if err != nil {
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error getting companies",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "Filtered companies",
			"data":    companies,
		})
	}
}
