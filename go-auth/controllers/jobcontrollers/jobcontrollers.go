package jobcontrollers

import (
	"log"
	"strconv"

	"github.com/RazoelZ/Learning-Haus/go-auth/helper"
	"github.com/RazoelZ/Learning-Haus/go-auth/models"
	"github.com/gofiber/fiber/v2"
)

func GetAllJobs(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		var jobs []models.Job

		err := r.DB.Find(&jobs).Error

		if err != nil {
			log.Printf("Error getting jobs: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error getting jobs",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "All jobs",
			"data":    jobs,
		})
	}
}

func CreateJob(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		job := new(models.Job)

		if err := c.BodyParser(job); err != nil {
			log.Printf("Error parsing request body: %s", err)
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"message": "Error parsing request body",
				"error":   err.Error(),
			})
		}

		// Uncomment the next line if you want to log the request body
		// fmt.Printf("Request Body: %v\n", job)

		err := r.DB.Create(&job).Error

		if err != nil {
			log.Printf("Error creating job: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error creating job",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "Job successfully created",
			"data":    job,
		})
	}
}

// belom masuk router
// ini coba WKWKWKWKWK
func GetFilterJob(r *helper.Repository) func(*fiber.Ctx) error {
	return func(c *fiber.Ctx) error {
		var jobs []models.Job
		var jobFilter models.Job

		// Extract the "id" query parameter from the URL
		id := c.Query("id")
		if id != "" {
			// Convert the string "id" to uint
			jobID, err := strconv.ParseUint(id, 10, 64)
			if err != nil {
				log.Printf("Error parsing 'id' parameter: %s", err)
				return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
					"message": "Error parsing 'id' parameter",
					"error":   err.Error(),
				})
			}
			jobFilter.JobID = uint(jobID)
		}

		// Apply the filter condition in the database query
		idInt, err := strconv.Atoi(id)
		if err != nil {
			log.Printf("Error converting 'id' to integer: %s", err)
			return c.Status(fiber.StatusBadRequest).JSON(fiber.Map{
				"message": "Error converting 'id' to integer",
				"error":   err.Error(),
			})
		}
		log.Printf("Filtered job ID: %d", idInt)

		err = r.DB.Where("job_id = ?", idInt).Find(&jobs).Error

		if err != nil {
			log.Printf("Error getting jobs: %s", err)
			return c.Status(fiber.StatusInternalServerError).JSON(fiber.Map{
				"message": "Error getting jobs",
				"error":   err.Error(),
			})
		}

		return c.JSON(fiber.Map{
			"status":  "success",
			"message": "Filtered jobs",
			"data":    jobs,
		})
	}
}
