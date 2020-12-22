-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema dbsistema
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema dbsistema
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dbsistema` DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci ;
USE `dbsistema` ;

-- -----------------------------------------------------
-- Table `dbsistema`.`categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbsistema`.`categoria` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(20) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `activo` BIT NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsistema`.`articulo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbsistema`.`articulo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `categoria_id` INT NOT NULL,
  `codigo` VARCHAR(50) NOT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `precio_venta` DECIMAL(11,2) NOT NULL,
  `stock` INT NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  `imagen` VARCHAR(50) NULL,
  `activo` BIT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `nombre_UNIQUE` (`nombre` ASC) VISIBLE,
  INDEX `fk_articulo_categoria_idx` (`categoria_id` ASC) VISIBLE,
  CONSTRAINT `fk_articulo_categoria`
    FOREIGN KEY (`categoria_id`)
    REFERENCES `dbsistema`.`categoria` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsistema`.`rol`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbsistema`.`rol` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(20) NOT NULL,
  `descripcion` VARCHAR(255) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsistema`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbsistema`.`usuario` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `id_rol` INT NOT NULL,
  `nombre` VARCHAR(70) NOT NULL,
  `tipo_documento` VARCHAR(20) NOT NULL,
  `num_documento` VARCHAR(20) NOT NULL,
  `direccion` VARCHAR(70) NULL,
  `telefono` VARCHAR(15) NULL,
  `email` VARCHAR(50) NULL,
  `clave` VARCHAR(128) NULL,
  `activo` BIT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `fk_usuario_rol_idx` (`id_rol` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_rol`
    FOREIGN KEY (`id_rol`)
    REFERENCES `dbsistema`.`rol` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsistema`.`persona`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbsistema`.`persona` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tipo_persona` VARCHAR(20) NOT NULL,
  `id_rol` INT NOT NULL,
  `nombre` VARCHAR(70) NOT NULL,
  `tipo_documento` VARCHAR(20) NOT NULL,
  `num_documento` VARCHAR(20) NOT NULL,
  `direccion` VARCHAR(70) NULL,
  `telefono` VARCHAR(15) NULL,
  `email` VARCHAR(50) NULL,
  `activo` BIT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsistema`.`ingreso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbsistema`.`ingreso` (
  `id` INT NOT NULL,
  `persona_id` INT NOT NULL,
  `usuario_id` INT NOT NULL,
  `tipo_comprobante` VARCHAR(20) NOT NULL,
  `tim_comprobante` VARCHAR(10) NOT NULL,
  `num_comprobante` VARCHAR(10) NOT NULL,
  `fecha` DATETIME NOT NULL,
  `impuesto` DECIMAL(4,2) NOT NULL,
  `total` DECIMAL(11,2) NOT NULL,
  `estado` BIT(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `fk_ingreso_persona_idx` (`persona_id` ASC) VISIBLE,
  INDEX `fk_ingreso_usuario_idx` (`usuario_id` ASC) VISIBLE,
  CONSTRAINT `fk_ingreso_persona`
    FOREIGN KEY (`persona_id`)
    REFERENCES `dbsistema`.`persona` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ingreso_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `dbsistema`.`usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsistema`.`detalle_ingreso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbsistema`.`detalle_ingreso` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `ingreso_id` INT NOT NULL,
  `articulo_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio` DECIMAL(11,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_detalle_ingreso_ingreso_idx` (`ingreso_id` ASC) VISIBLE,
  INDEX `fk_detalle_ingreso_articulo_idx` (`articulo_id` ASC) VISIBLE,
  CONSTRAINT `fk_detalle_ingreso_ingreso`
    FOREIGN KEY (`ingreso_id`)
    REFERENCES `dbsistema`.`ingreso` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_ingreso_articulo`
    FOREIGN KEY (`articulo_id`)
    REFERENCES `dbsistema`.`articulo` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsistema`.`venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbsistema`.`venta` (
  `id` INT NOT NULL,
  `persona_id` INT NOT NULL,
  `usuario_id` INT NOT NULL,
  `tipo_comprobante` VARCHAR(20) NOT NULL,
  `tim_comprobante` VARCHAR(10) NOT NULL,
  `num_comprobante` VARCHAR(10) NOT NULL,
  `fecha` DATETIME NOT NULL,
  `impuesto` DECIMAL(4,2) NOT NULL,
  `total` DECIMAL(11,2) NOT NULL,
  `estado` VARCHAR(20) NOT NULL DEFAULT 'ACEPTADO',
  PRIMARY KEY (`id`),
  INDEX `fk_venta_persona_idx` (`persona_id` ASC) VISIBLE,
  INDEX `fk_venta_usuario_idx` (`usuario_id` ASC) VISIBLE,
  CONSTRAINT `fk_venta_persona`
    FOREIGN KEY (`persona_id`)
    REFERENCES `dbsistema`.`persona` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_venta_usuario`
    FOREIGN KEY (`usuario_id`)
    REFERENCES `dbsistema`.`usuario` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `dbsistema`.`detalle_venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbsistema`.`detalle_venta` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `venta_id` INT NOT NULL,
  `articulo_id` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `precio` DECIMAL(11,2) NOT NULL,
  `descuento` DECIMAL(11,2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_detalle_venta_venta_idx` (`venta_id` ASC) VISIBLE,
  INDEX `fk_detalle_venta_articulo_idx` (`articulo_id` ASC) VISIBLE,
  CONSTRAINT `fk_detalle_venta_venta`
    FOREIGN KEY (`venta_id`)
    REFERENCES `dbsistema`.`detalle_venta` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_detalle_venta_articulo`
    FOREIGN KEY (`articulo_id`)
    REFERENCES `dbsistema`.`articulo` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
