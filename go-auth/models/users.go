package models

import (
	"time"

	"gorm.io/gorm"
)

type User struct {
	ID        uint      `gorm:"primaryKey;autoIncrement:true" json:"id"`
	Name      string    `json:"name"`
	Email     string    `gorm:"unique" json:"email"`
	Role      int       `json:"role"`
	Password  string    `json:"password"`
	JobID     uint      `json:"job_id" gorm:"foreignKey:job_id"`
	CompanyID uint      `json:"company_id" gorm:"foreignKey:company_id"`
	CreatedAt time.Time `json:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt"`
}

func MigrateUser(db *gorm.DB) error {
	if err := db.AutoMigrate(&User{}); err != nil {
		return err
	}
	return nil
}
