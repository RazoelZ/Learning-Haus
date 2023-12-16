// controllers/usercontrollers.go

package usercontrollers

import (
	"log"
	"os"
	"strconv"
	"time"

	"github.com/RazoelZ/Learning-Haus/go-auth/helper"
	"github.com/RazoelZ/Learning-Haus/go-auth/models"
	"github.com/gofiber/fiber/v2"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
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
			"status":  "success",
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

		// Hash the user's password before storing it
		hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), 8)
		if err != nil {
			log.Printf("Error hashing password: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error hashing password",
				"error":   err.Error(),
			})
		}

		user.Password = string(hashedPassword)

		err = r.DB.Create(&user).Error

		if err != nil {
			log.Printf("Error creating user: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error creating user",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "User successfully created",
			"data":    user,
		})
	}
}

func Login(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		user := new(models.User)
		reqBody := new(models.User)

		if err := c.BodyParser(reqBody); err != nil {
			log.Printf("Error parsing request body: %s", err)
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"status":  "failed",
				"message": "Error parsing request body",
				"error":   err.Error(),
			})
		}

		err := r.DB.Where("email = ?", reqBody.Email).First(&user).Error

		if err != nil {
			log.Printf("Error retrieving user: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"status":  "failed",
				"message": "Error retrieving user",
				"error":   err.Error(),
			})
		}

		// Check if the password is correct
		err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(reqBody.Password))
		if err != nil {
			log.Printf("Error comparing passwords: %s", err)
			return c.Status(fiber.StatusUnauthorized).JSON(fiber.Map{
				"status":  "failed",
				"message": "Invalid credentials",
				"error":   err.Error(),
			})
		}

		// Generate JWT token
		token := jwt.New(jwt.SigningMethodHS256)
		claim := token.Claims.(jwt.MapClaims)
		claim["id"] = user.ID
		claim["name"] = user.Name
		claim["email"] = user.Email
		claim["role"] = user.Role
		claim["job_id"] = user.JobID
		claim["company_id"] = user.CompanyID

		claim["exp"] = time.Now().Add(time.Hour * 72).Unix() // Token expires after 72 hours

		signedToken, err := token.SignedString([]byte(os.Getenv("JWT_SECRET_KEY")))

		if err != nil {
			log.Printf("Error signing token: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"status":  "failed",
				"message": "Error signing token",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"error":   false,
			"message": "Successfully logged in",
			"data":    signedToken,
		})
	}
}

func ChangeJob(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		reqBody := new(models.User)
		params := c.Params("id")

		if err := c.BodyParser(reqBody); err != nil {
			log.Printf("Error parsing request body: %s", err)
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"message": "Error parsing request body",
				"error":   err.Error(),
			})
		}

		// Use the Struct function to update only the "job" field
		err := r.DB.Model(&models.User{}).Where("id = ?", params).Updates(map[string]interface{}{"job_id": reqBody.JobID}).Error

		if err != nil {
			log.Printf("Error updating user: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error updating user",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "User successfully updated",
			"data":    map[string]interface{}{"job_id": reqBody.JobID},
		})
	}
}

func ChangeCompany(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		reqBody := new(models.User)
		params := c.Params("id")

		if err := c.BodyParser(reqBody); err != nil {
			log.Printf("Error parsing request body: %s", err)
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"message": "Error parsing request body",
				"error":   err.Error(),
			})
		}

		// Use the Struct function to update only the "company" field
		err := r.DB.Model(&models.User{}).Where("id = ?", params).Updates(map[string]interface{}{"company_id": reqBody.CompanyID}).Error

		if err != nil {
			log.Printf("Error updating user: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error updating user",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "User successfully updated",
			"data":    map[string]interface{}{"company_id": reqBody.CompanyID},
		})
	}
}

func UpdateUser(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		user := new(models.User)
		params := c.Params("id")

		if err := c.BodyParser(user); err != nil {
			log.Printf("Error parsing request body: %s", err)
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"message": "Error parsing request body",
				"error":   err.Error(),
			})
		}

		err := r.DB.Model(&models.User{}).Where("id = ?", params).Updates(user).Error

		if err != nil {
			log.Printf("Error updating user: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error updating user",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "User successfully updated",
			"data":    user,
		})
	}
}

func DeleteUser(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		user := new(models.User)
		params := c.Params("id")

		err := r.DB.Where("id = ?", params).Delete(&user).Error

		if err != nil {
			log.Printf("Error deleting user: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error deleting user",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "User successfully deleted",
			"data":    map[string]interface{}{"id": params},
		})
	}
}

func GetUserById(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		user := new(models.User)
		company := new(models.Company)
		job := new(models.Job)
		params := c.Params("id")

		err := r.DB.Where("id = ?", params).First(&user).Error
		if err != nil {
			log.Printf("Error retrieving user: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error retrieving user",
				"error":   err.Error(),
			})
		}

		// Retrieve company data if CompanyID is not nil
		if user.CompanyID != 0 {
			errCompany := r.DB.Where("company_id = ?", user.CompanyID).First(&company).Error
			if errCompany != nil {
				log.Printf("Error retrieving company: %s", errCompany)
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"message": "Error retrieving company",
					"error":   errCompany.Error(),
				})
			}
		}

		// Retrieve job data if JobID is not nil
		if user.JobID != 0 {
			errJob := r.DB.Where("job_id = ?", user.JobID).First(&job).Error
			if errJob != nil {
				log.Printf("Error retrieving job: %s", errJob)
				return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
					"message": "Error retrieving job",
					"error":   errJob.Error(),
				})
			}
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "Successfully retrieved user",
			"data": fiber.Map{
				"id":            user.ID,
				"name":          user.Name,
				"email":         user.Email,
				"tanggal_masuk": user.CreatedAt,
				"job":           job.Position,
				"salary":        job.Salary,
				"company":       company.Name,
			},
		})
	}
}

func GetFilterUserbyJobs(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		var users []models.User
		var userFilter models.User

		id := c.Query("id")
		if id != "" {
			ID, err := strconv.ParseUint(id, 10, 64)
			if err != nil {
				log.Printf("Error parsing 'id' parameter: %s", err)
				return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
					"message": "Error parsing 'id' parameter",
					"error":   err.Error(),
				})
			}
			userFilter.ID = uint(ID)
		}

		err := r.DB.Where("job_id = ?", id).Find(&users).Error

		if err != nil {
			log.Printf("Error getting users: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error getting users",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "Filtered users",
			"data":    users,
		})

	}
}

func GetFilterUserbyCompanies(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		var users []models.User
		var userFilter models.User

		id := c.Query("id")
		if id != "" {
			ID, err := strconv.ParseUint(id, 10, 64)
			if err != nil {
				log.Printf("Error parsing 'id' parameter: %s", err)
				return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
					"message": "Error parsing 'id' parameter",
					"error":   err.Error(),
				})
			}
			userFilter.ID = uint(ID)
		}

		err := r.DB.Where("company_id = ?", id).Find(&users).Error

		if err != nil {
			log.Printf("Error getting users: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error getting users",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "Filtered users",
			"data":    users,
		})

	}
}
