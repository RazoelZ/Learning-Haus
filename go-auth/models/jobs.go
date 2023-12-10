package models

import (
	"time"

	"gorm.io/gorm"
)

type Job struct {
	JobID       uint      `gorm:"primaryKey;autoIncrement:true" json:"job_id"`
	Position    string    `json:"position"`
	Salary      string    `json:"salary"`
	Description string    `json:"description"`
	CreatedAt   time.Time `json:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt"`
}

func MigrateJob(db *gorm.DB) error {
	if err := db.AutoMigrate(&Job{}); err != nil {
		return err
	}
	return nil
}
