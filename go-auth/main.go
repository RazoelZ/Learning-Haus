// main.go

package main

import (
	"log"

	"github.com/RazoelZ/Learning-Haus/go-auth/controllers/companycontrollers"
	"github.com/RazoelZ/Learning-Haus/go-auth/controllers/jobcontrollers"
	usercontrollers "github.com/RazoelZ/Learning-Haus/go-auth/controllers/usercontrollers"
	"github.com/RazoelZ/Learning-Haus/go-auth/database"
	"github.com/RazoelZ/Learning-Haus/go-auth/helper"
	middleware "github.com/RazoelZ/Learning-Haus/go-auth/middleware"
	"github.com/RazoelZ/Learning-Haus/go-auth/models"
	"github.com/gofiber/fiber/v2"
)

func main() {
	// use Fiber GO
	app := fiber.New()

	// Connection to DB POSTGRES
	db, err := database.NewConnection()
	if err != nil {
		log.Fatalf("Error connecting to the database: %v", err)
	}

	// Migrate DB
	err = models.MigrateUser(db)
	if err != nil {
		log.Fatalf("Error migrating user because %v", err)
	} else {
		log.Println("User table migration successful")
	}
	err = models.MigrateJob(db)
	if err != nil {
		log.Fatalf("Error migrating job because %v", err)
	} else {
		log.Println("Job table migration successful")
	}
	err = models.MigrateCompany(db)
	if err != nil {
		log.Fatalf("Error migrating company because %v", err)
	} else {
		log.Println("Company table migration successful")
	}

	// API routing
	r := &helper.Repository{
		DB: db,
	}
	SetupRoutes(app, r)

	// Set up CORS
	app.Use(func(c *fiber.Ctx) error {
		c.Set("Access-Control-Allow-Origin", "*")
		c.Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")
		c.Set("Access-Control-Allow-Headers", "Content-Type")
		return c.Next()
	})

	// Set ports
	err = app.Listen(":8888")
	if err != nil {
		log.Fatalf("Error starting the server: %v", err)
	}
}

// SetupRoutes defines API routes
func SetupRoutes(app *fiber.App, r *helper.Repository) {
	api := app.Group("/api")
	api.Get("/users", middleware.AuthorizedAPI(), usercontrollers.Index(r))
	api.Post("/register", usercontrollers.Register(r))
	api.Post("/createjob", jobcontrollers.CreateJob(r))
	api.Post("/createcompany", companycontrollers.CreateCompany(r))
	api.Post("/login", usercontrollers.Login(r))
	api.Put("/user/changejob/:id", middleware.AuthorizedAPI(), usercontrollers.ChangeJob(r))
	api.Put("/user/changecompany/:id", middleware.AuthorizedAPI(), usercontrollers.ChangeCompany(r))
	api.Get("/user/:id", middleware.AuthorizedAPI(), usercontrollers.GetUserById(r))
	api.Put("/user/:id", middleware.AuthorizedAPI(), usercontrollers.UpdateUser(r))
	api.Delete("/user/:id", middleware.AuthorizedAPI(), usercontrollers.DeleteUser(r))
	api.Get("/jobs", jobcontrollers.GetAllJobs(r))
	api.Get("/companies", companycontrollers.GetAllCompanies(r))
	api.Get("/job", jobcontrollers.GetFilterJob(r))
	api.Get("/employeebyjobs", usercontrollers.GetFilterUserbyJobs(r))
	api.Get("/employeebycompanies", usercontrollers.GetFilterUserbyCompanies(r))
}
