-- ----------------------------------------------------------------------------
-- MySQL Workbench Migration
-- Migrated Schemata: image_board_m
-- Source Schemata: image_board
-- Created: Sat Mar 12 14:22:19 2022
-- Workbench Version: 8.0.28
-- ----------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- Schema image_board_m
-- ----------------------------------------------------------------------------
DROP SCHEMA IF EXISTS `image_board_m` ;
CREATE SCHEMA IF NOT EXISTS `image_board_m` ;

-- ----------------------------------------------------------------------------
-- Table image_board_m.category
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `image_board_m`.`category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- ----------------------------------------------------------------------------
-- Table image_board_m.commentary
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `image_board_m`.`commentary` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `message` VARCHAR(10000) NOT NULL,
  `date` DATETIME NULL DEFAULT NULL,
  `post_id` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- ----------------------------------------------------------------------------
-- Table image_board_m.content
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `image_board_m`.`content` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NOT NULL,
  `type` VARCHAR(8) NULL DEFAULT NULL,
  `name` VARCHAR(256) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- ----------------------------------------------------------------------------
-- Table image_board_m.meta
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `image_board_m`.`meta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- ----------------------------------------------------------------------------
-- Table image_board_m.post
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `image_board_m`.`post` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `name` VARCHAR(300) NOT NULL,
  `message` VARCHAR(13000) NOT NULL,
  `date` DATETIME NULL DEFAULT NULL,
  `content_id` INT NULL DEFAULT NULL,
  `category_id` JSON NULL DEFAULT NULL,
  `meta_id` JSON NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- ----------------------------------------------------------------------------
-- Table image_board_m.score
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `image_board_m`.`score` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `post_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `count` INT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- ----------------------------------------------------------------------------
-- Table image_board_m.user
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `image_board_m`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NULL DEFAULT NULL,
  `password` VARCHAR(64) NULL DEFAULT NULL,
  `signup_date` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
SET FOREIGN_KEY_CHECKS = 1;
