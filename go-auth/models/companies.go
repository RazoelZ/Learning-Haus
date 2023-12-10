package models

import (
	"time"

	"gorm.io/gorm"
)

type Company struct {
	CompanyID uint      `gorm:"primaryKey;autoIncrement:true" json:"company_id"`
	Name      string    `json:"name"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

func MigrateCompany(db *gorm.DB) error {
	if err := db.AutoMigrate(&Company{}); err != nil {
		return err
	}
	return nil
}
