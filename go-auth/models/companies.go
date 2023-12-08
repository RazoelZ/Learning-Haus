package models

import (
	"time"

	"gorm.io/gorm"
)

type Company struct {
	CompanyID uint      `gorm:"primaryKey;autoIncrement:true" json:"idcompany"`
	Name      string    `json:"name"`
	UserID    uint      `json:"id"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

func MigrateCompany(db *gorm.DB) error {
	if err := db.AutoMigrate(&Company{}); err != nil {
		return err
	}
	return nil
}
