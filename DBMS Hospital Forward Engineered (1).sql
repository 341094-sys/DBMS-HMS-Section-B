-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema apollo_hospital17
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema apollo_hospital17
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `apollo_hospital17` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `apollo_hospital17` ;

-- -----------------------------------------------------
-- Table `apollo_hospital17`.`patient`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`patient` (
  `patient_id` BIGINT NOT NULL AUTO_INCREMENT,
  `mrn` VARCHAR(40) NULL DEFAULT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `dob` DATE NULL DEFAULT NULL,
  `gender` ENUM('Male', 'Female', 'Other') NULL DEFAULT NULL,
  `phone` VARCHAR(15) NULL DEFAULT NULL,
  `email` VARCHAR(80) NULL DEFAULT NULL,
  `address` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`patient_id`),
  UNIQUE INDEX `mrn` (`mrn` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`hospitalbranch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`hospitalbranch` (
  `branch_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `city` VARCHAR(60) NULL DEFAULT NULL,
  `phone` VARCHAR(15) NULL DEFAULT NULL,
  `established_year` YEAR NULL DEFAULT NULL,
  PRIMARY KEY (`branch_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`department`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`department` (
  `department_id` SMALLINT NOT NULL AUTO_INCREMENT,
  `branch_id` INT NOT NULL,
  `name` VARCHAR(80) NOT NULL,
  `floor` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`department_id`),
  INDEX `branch_id` (`branch_id` ASC) VISIBLE,
  CONSTRAINT `department_ibfk_1`
    FOREIGN KEY (`branch_id`)
    REFERENCES `apollo_hospital17`.`hospitalbranch` (`branch_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`doctor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`doctor` (
  `doctor_id` INT NOT NULL AUTO_INCREMENT,
  `branch_id` INT NOT NULL,
  `department_id` SMALLINT NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `reg_no` VARCHAR(30) NULL DEFAULT NULL,
  `phone` VARCHAR(15) NULL DEFAULT NULL,
  `email` VARCHAR(80) NULL DEFAULT NULL,
  `experience_years` TINYINT NULL DEFAULT NULL,
  PRIMARY KEY (`doctor_id`),
  UNIQUE INDEX `reg_no` (`reg_no` ASC) VISIBLE,
  INDEX `branch_id` (`branch_id` ASC) VISIBLE,
  INDEX `department_id` (`department_id` ASC) VISIBLE,
  CONSTRAINT `doctor_ibfk_1`
    FOREIGN KEY (`branch_id`)
    REFERENCES `apollo_hospital17`.`hospitalbranch` (`branch_id`),
  CONSTRAINT `doctor_ibfk_2`
    FOREIGN KEY (`department_id`)
    REFERENCES `apollo_hospital17`.`department` (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`appointment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`appointment` (
  `appointment_id` BIGINT NOT NULL AUTO_INCREMENT,
  `patient_id` BIGINT NOT NULL,
  `doctor_id` INT NOT NULL,
  `appointment_datetime` DATETIME NOT NULL,
  `status` ENUM('Scheduled', 'Completed', 'Cancelled', 'NoShow') NULL DEFAULT 'Scheduled',
  `reason` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`appointment_id`),
  INDEX `patient_id` (`patient_id` ASC) VISIBLE,
  INDEX `doctor_id` (`doctor_id` ASC) VISIBLE,
  CONSTRAINT `appointment_ibfk_1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `apollo_hospital17`.`patient` (`patient_id`),
  CONSTRAINT `appointment_ibfk_2`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `apollo_hospital17`.`doctor` (`doctor_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`visit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`visit` (
  `visit_id` BIGINT NOT NULL AUTO_INCREMENT,
  `appointment_id` BIGINT NULL DEFAULT NULL,
  `patient_id` BIGINT NOT NULL,
  `doctor_id` INT NOT NULL,
  `branch_id` INT NOT NULL,
  `visit_datetime` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `visit_type` ENUM('Outpatient', 'Emergency', 'FollowUp') NULL DEFAULT 'Outpatient',
  `notes` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`visit_id`),
  INDEX `appointment_id` (`appointment_id` ASC) VISIBLE,
  INDEX `patient_id` (`patient_id` ASC) VISIBLE,
  INDEX `doctor_id` (`doctor_id` ASC) VISIBLE,
  INDEX `branch_id` (`branch_id` ASC) VISIBLE,
  CONSTRAINT `visit_ibfk_1`
    FOREIGN KEY (`appointment_id`)
    REFERENCES `apollo_hospital17`.`appointment` (`appointment_id`),
  CONSTRAINT `visit_ibfk_2`
    FOREIGN KEY (`patient_id`)
    REFERENCES `apollo_hospital17`.`patient` (`patient_id`),
  CONSTRAINT `visit_ibfk_3`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `apollo_hospital17`.`doctor` (`doctor_id`),
  CONSTRAINT `visit_ibfk_4`
    FOREIGN KEY (`branch_id`)
    REFERENCES `apollo_hospital17`.`hospitalbranch` (`branch_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`room`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`room` (
  `room_id` INT NOT NULL AUTO_INCREMENT,
  `branch_id` INT NOT NULL,
  `room_number` VARCHAR(10) NOT NULL,
  `room_type` ENUM('General', 'SemiPrivate', 'Private', 'ICU') NULL DEFAULT NULL,
  `is_occupied` TINYINT(1) NULL DEFAULT '0',
  PRIMARY KEY (`room_id`),
  UNIQUE INDEX `branch_id` (`branch_id` ASC, `room_number` ASC) VISIBLE,
  CONSTRAINT `room_ibfk_1`
    FOREIGN KEY (`branch_id`)
    REFERENCES `apollo_hospital17`.`hospitalbranch` (`branch_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`admission`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`admission` (
  `admission_id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `patient_id` BIGINT NOT NULL,
  `room_id` INT NOT NULL,
  `admitted_on` DATETIME NOT NULL,
  `discharged_on` DATETIME NULL DEFAULT NULL,
  `status` ENUM('Admitted', 'Discharged', 'Transferred') NULL DEFAULT 'Admitted',
  `admitting_doctor_id` INT NOT NULL,
  `reason` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`admission_id`),
  INDEX `visit_id` (`visit_id` ASC) VISIBLE,
  INDEX `patient_id` (`patient_id` ASC) VISIBLE,
  INDEX `room_id` (`room_id` ASC) VISIBLE,
  INDEX `admitting_doctor_id` (`admitting_doctor_id` ASC) VISIBLE,
  CONSTRAINT `admission_ibfk_1`
    FOREIGN KEY (`visit_id`)
    REFERENCES `apollo_hospital17`.`visit` (`visit_id`),
  CONSTRAINT `admission_ibfk_2`
    FOREIGN KEY (`patient_id`)
    REFERENCES `apollo_hospital17`.`patient` (`patient_id`),
  CONSTRAINT `admission_ibfk_3`
    FOREIGN KEY (`room_id`)
    REFERENCES `apollo_hospital17`.`room` (`room_id`),
  CONSTRAINT `admission_ibfk_4`
    FOREIGN KEY (`admitting_doctor_id`)
    REFERENCES `apollo_hospital17`.`doctor` (`doctor_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`invoice` (
  `invoice_id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `patient_id` BIGINT NOT NULL,
  `created_on` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `total_amount` DECIMAL(12,2) NULL DEFAULT NULL,
  `status` ENUM('Unpaid', 'Paid', 'PartiallyPaid') NULL DEFAULT 'Unpaid',
  PRIMARY KEY (`invoice_id`),
  INDEX `visit_id` (`visit_id` ASC) VISIBLE,
  INDEX `patient_id` (`patient_id` ASC) VISIBLE,
  CONSTRAINT `invoice_ibfk_1`
    FOREIGN KEY (`visit_id`)
    REFERENCES `apollo_hospital17`.`visit` (`visit_id`),
  CONSTRAINT `invoice_ibfk_2`
    FOREIGN KEY (`patient_id`)
    REFERENCES `apollo_hospital17`.`patient` (`patient_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`laborder`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`laborder` (
  `laborder_id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `ordered_by` INT NOT NULL,
  `ordered_on` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('Pending', 'Completed', 'Cancelled') NULL DEFAULT 'Pending',
  PRIMARY KEY (`laborder_id`),
  INDEX `visit_id` (`visit_id` ASC) VISIBLE,
  INDEX `ordered_by` (`ordered_by` ASC) VISIBLE,
  CONSTRAINT `laborder_ibfk_1`
    FOREIGN KEY (`visit_id`)
    REFERENCES `apollo_hospital17`.`visit` (`visit_id`),
  CONSTRAINT `laborder_ibfk_2`
    FOREIGN KEY (`ordered_by`)
    REFERENCES `apollo_hospital17`.`doctor` (`doctor_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`labtest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`labtest` (
  `labtest_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `department_id` SMALLINT NULL DEFAULT NULL,
  `price` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`labtest_id`),
  INDEX `department_id` (`department_id` ASC) VISIBLE,
  CONSTRAINT `labtest_ibfk_1`
    FOREIGN KEY (`department_id`)
    REFERENCES `apollo_hospital17`.`department` (`department_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`laborderitem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`laborderitem` (
  `lab_item_id` BIGINT NOT NULL AUTO_INCREMENT,
  `laborder_id` BIGINT NOT NULL,
  `labtest_id` INT NOT NULL,
  `result_text` VARCHAR(500) NULL DEFAULT NULL,
  `result_date` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`lab_item_id`),
  INDEX `laborder_id` (`laborder_id` ASC) VISIBLE,
  INDEX `labtest_id` (`labtest_id` ASC) VISIBLE,
  CONSTRAINT `laborderitem_ibfk_1`
    FOREIGN KEY (`laborder_id`)
    REFERENCES `apollo_hospital17`.`laborder` (`laborder_id`),
  CONSTRAINT `laborderitem_ibfk_2`
    FOREIGN KEY (`labtest_id`)
    REFERENCES `apollo_hospital17`.`labtest` (`labtest_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`medication`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`medication` (
  `medication_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `form` VARCHAR(30) NULL DEFAULT NULL,
  `strength` VARCHAR(30) NULL DEFAULT NULL,
  `unit_price` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`medication_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`payment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`payment` (
  `payment_id` BIGINT NOT NULL AUTO_INCREMENT,
  `invoice_id` BIGINT NOT NULL,
  `amount` DECIMAL(12,2) NOT NULL,
  `method` ENUM('Cash', 'Card', 'UPI', 'Insurance') NULL DEFAULT 'Cash',
  `payment_date` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `reference_no` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  INDEX `invoice_id` (`invoice_id` ASC) VISIBLE,
  CONSTRAINT `payment_ibfk_1`
    FOREIGN KEY (`invoice_id`)
    REFERENCES `apollo_hospital17`.`invoice` (`invoice_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`prescription`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`prescription` (
  `prescription_id` BIGINT NOT NULL AUTO_INCREMENT,
  `visit_id` BIGINT NOT NULL,
  `doctor_id` INT NOT NULL,
  `prescribed_on` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `notes` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`prescription_id`),
  INDEX `visit_id` (`visit_id` ASC) VISIBLE,
  INDEX `doctor_id` (`doctor_id` ASC) VISIBLE,
  CONSTRAINT `prescription_ibfk_1`
    FOREIGN KEY (`visit_id`)
    REFERENCES `apollo_hospital17`.`visit` (`visit_id`),
  CONSTRAINT `prescription_ibfk_2`
    FOREIGN KEY (`doctor_id`)
    REFERENCES `apollo_hospital17`.`doctor` (`doctor_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `apollo_hospital17`.`prescriptionitem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `apollo_hospital17`.`prescriptionitem` (
  `presc_item_id` BIGINT NOT NULL AUTO_INCREMENT,
  `prescription_id` BIGINT NOT NULL,
  `medication_id` INT NOT NULL,
  `dosage` VARCHAR(100) NULL DEFAULT NULL,
  `frequency` VARCHAR(50) NULL DEFAULT NULL,
  `duration_days` SMALLINT NULL DEFAULT NULL,
  `quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`presc_item_id`),
  INDEX `prescription_id` (`prescription_id` ASC) VISIBLE,
  INDEX `medication_id` (`medication_id` ASC) VISIBLE,
  CONSTRAINT `prescriptionitem_ibfk_1`
    FOREIGN KEY (`prescription_id`)
    REFERENCES `apollo_hospital17`.`prescription` (`prescription_id`),
  CONSTRAINT `prescriptionitem_ibfk_2`
    FOREIGN KEY (`medication_id`)
    REFERENCES `apollo_hospital17`.`medication` (`medication_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
