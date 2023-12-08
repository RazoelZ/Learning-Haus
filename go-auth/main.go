// main.go

package main

import (
	"log"

	"github.com/RazoelZ/go-auth/controllers/companycontrollers"
	"github.com/RazoelZ/go-auth/controllers/jobcontrollers"
	usercontrollers "github.com/RazoelZ/go-auth/controllers/usercontrollers"
	"github.com/RazoelZ/go-auth/database"
	"github.com/RazoelZ/go-auth/helper"
	"github.com/RazoelZ/go-auth/models"
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
	api := app.Group("/api")
	api.Get("/hello", usercontrollers.Index(&helper.Repository{
		DB: db,
	}))
	api.Post("/register", usercontrollers.Register(&helper.Repository{
		DB: db,
	}))
	api.Post("/createjob", jobcontrollers.CreateJob(&helper.Repository{
		DB: db,
	}))
	api.Post("/createcompany", companycontrollers.CreateCompany(&helper.Repository{
		DB: db,
	}))

	// Set ports
	err = app.Listen(":8888")
	if err != nil {
		log.Fatalf("Error starting the server: %v", err)
	}
}
