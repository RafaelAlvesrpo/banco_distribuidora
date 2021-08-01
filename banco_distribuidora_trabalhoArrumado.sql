-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema db_info
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema db_info
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db_info` DEFAULT CHARACTER SET utf8 ;
USE `db_info` ;

-- -----------------------------------------------------
-- Table `db_info`.`tb_cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`tb_cliente` (
  `CPF` VARCHAR(11) NOT NULL,
  `nome_completo` VARCHAR(100) NOT NULL,
  `email` VARCHAR(80) NOT NULL,
  `senha` VARCHAR(300) NOT NULL,
  `celular` VARCHAR(12) NOT NULL,
  `tele_fixo` VARCHAR(12) NULL,
  PRIMARY KEY (`CPF`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`tb_estado`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`tb_estado` (
  `id_estado` INT NOT NULL,
  `nome_estado` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id_estado`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`tb_municipio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`tb_municipio` (
  `id_municipio` INT NOT NULL,
  `nome_municipio` VARCHAR(100) NOT NULL,
  `id_estado` INT NOT NULL,
  PRIMARY KEY (`id_municipio`),
  INDEX `fk_tb_municipio_tb_estado1_idx` (`id_estado` ASC) VISIBLE,
  CONSTRAINT `fk_tb_municipio_tb_estado1`
    FOREIGN KEY (`id_estado`)
    REFERENCES `db_info`.`tb_estado` (`id_estado`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`tb_endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`tb_endereco` (
  `id_endereco` INT NOT NULL,
  `rua_ave_` VARCHAR(120) NOT NULL,
  `numero_casa` INT NOT NULL,
  `complemento` VARCHAR(90) NULL,
  `cep` VARCHAR(8) NOT NULL,
  `CPF` VARCHAR(11) NOT NULL,
  `id_municipio` INT NOT NULL,
  PRIMARY KEY (`id_endereco`),
  INDEX `fk_tb_endereco_tb_cliente_idx` (`CPF` ASC) VISIBLE,
  INDEX `fk_tb_endereco_tb_municipio1_idx` (`id_municipio` ASC) VISIBLE,
  CONSTRAINT `fk_tb_endereco_tb_cliente`
    FOREIGN KEY (`CPF`)
    REFERENCES `db_info`.`tb_cliente` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_endereco_tb_municipio1`
    FOREIGN KEY (`id_municipio`)
    REFERENCES `db_info`.`tb_municipio` (`id_municipio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`tb_pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`tb_pagamento` (
  `id_pagamento` INT NOT NULL,
  `forma_pgto` ENUM('Dinheiro', 'Cartao_credito', 'PIX') NOT NULL,
  `valor_a_pagar` DECIMAL(10,2) NOT NULL,
  `descricao` TEXT NULL,
  `data_pgto` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_pagamento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`tb_pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`tb_pedido` (
  `cod_pedido` INT NOT NULL,
  `hora_pedido` TIME NOT NULL,
  `data_pedido` DATE NOT NULL,
  `forma_entrega` ENUM('Retirar', 'Entregar', 'Frete') NULL,
  `tb_pedidocol` VARCHAR(45) NULL,
  `CPF` VARCHAR(11) NOT NULL,
  `id_pagamento` INT NOT NULL,
  PRIMARY KEY (`cod_pedido`),
  INDEX `fk_tb_pedido_tb_cliente1_idx` (`CPF` ASC) VISIBLE,
  INDEX `fk_tb_pedido_tb_pagamento1_idx` (`id_pagamento` ASC) VISIBLE,
  CONSTRAINT `fk_tb_pedido_tb_cliente1`
    FOREIGN KEY (`CPF`)
    REFERENCES `db_info`.`tb_cliente` (`CPF`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_pedido_tb_pagamento1`
    FOREIGN KEY (`id_pagamento`)
    REFERENCES `db_info`.`tb_pagamento` (`id_pagamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`tb_produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`tb_produto` (
  `id_produto` INT NOT NULL,
  `nome_produto` VARCHAR(90) NOT NULL,
  `preco_venda` DECIMAL(10,2) NOT NULL,
  `total_estoque` INT NOT NULL,
  `forma_unitária` ENUM('ml', 'litro', 'gramas', 'kg', 'unitário', 'peca', 'pedaco', 'fatia') NULL,
  `imagem_foto` BLOB NULL,
  PRIMARY KEY (`id_produto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`rl_pedido_produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`rl_pedido_produto` (
  `id_produto` INT NOT NULL,
  `cod_pedido` INT NOT NULL,
  `quantidade_produto` INT NOT NULL,
  PRIMARY KEY (`id_produto`, `cod_pedido`),
  INDEX `fk_tb_produto_has_tb_pedido_tb_pedido1_idx` (`cod_pedido` ASC) VISIBLE,
  INDEX `fk_tb_produto_has_tb_pedido_tb_produto1_idx` (`id_produto` ASC) VISIBLE,
  CONSTRAINT `fk_tb_produto_has_tb_pedido_tb_produto1`
    FOREIGN KEY (`id_produto`)
    REFERENCES `db_info`.`tb_produto` (`id_produto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_produto_has_tb_pedido_tb_pedido1`
    FOREIGN KEY (`cod_pedido`)
    REFERENCES `db_info`.`tb_pedido` (`cod_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`tb_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`tb_status` (
  `id_status` INT NOT NULL,
  `descricao` TEXT NULL,
  PRIMARY KEY (`id_status`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`rl_status_pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`rl_status_pedido` (
  `id_status` INT NOT NULL,
  `cod_pedido` INT NOT NULL,
  `hora_status` TIME NOT NULL,
  `data_status` DATE NOT NULL,
  `observacao` TEXT NULL,
  PRIMARY KEY (`id_status`, `cod_pedido`),
  INDEX `fk_tb_status_has_tb_pedido_tb_pedido1_idx` (`cod_pedido` ASC) VISIBLE,
  INDEX `fk_tb_status_has_tb_pedido_tb_status1_idx` (`id_status` ASC) VISIBLE,
  CONSTRAINT `fk_tb_status_has_tb_pedido_tb_status1`
    FOREIGN KEY (`id_status`)
    REFERENCES `db_info`.`tb_status` (`id_status`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_status_has_tb_pedido_tb_pedido1`
    FOREIGN KEY (`cod_pedido`)
    REFERENCES `db_info`.`tb_pedido` (`cod_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`tb_categoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`tb_categoria` (
  `id_categoria` INT NOT NULL,
  `nome_categoria` VARCHAR(80) NOT NULL,
  `orgiem` ENUM('Nacional', 'Importado', 'Artesanal') NOT NULL,
  PRIMARY KEY (`id_categoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`rl_categoria_produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`rl_categoria_produto` (
  `id_categoria` INT NOT NULL,
  `id_produto` INT NOT NULL,
  PRIMARY KEY (`id_categoria`, `id_produto`),
  INDEX `fk_tb_categoria_has_tb_produto_tb_produto1_idx` (`id_produto` ASC) VISIBLE,
  INDEX `fk_tb_categoria_has_tb_produto_tb_categoria1_idx` (`id_categoria` ASC) VISIBLE,
  CONSTRAINT `fk_tb_categoria_has_tb_produto_tb_categoria1`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `db_info`.`tb_categoria` (`id_categoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_categoria_has_tb_produto_tb_produto1`
    FOREIGN KEY (`id_produto`)
    REFERENCES `db_info`.`tb_produto` (`id_produto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_info`.`rl_status_pedido_produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_info`.`rl_status_pedido_produto` (
  `id_status` INT NOT NULL,
  `id_produto` INT NOT NULL,
  `cod_pedido` INT NOT NULL,
  `hora_saida` TIME NOT NULL,
  `hora_entrega` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_status`, `id_produto`, `cod_pedido`),
  INDEX `fk_tb_status_has_rl_pedido_produto_rl_pedido_produto1_idx` (`id_produto` ASC, `cod_pedido` ASC) VISIBLE,
  INDEX `fk_tb_status_has_rl_pedido_produto_tb_status1_idx` (`id_status` ASC) VISIBLE,
  CONSTRAINT `fk_tb_status_has_rl_pedido_produto_tb_status1`
    FOREIGN KEY (`id_status`)
    REFERENCES `db_info`.`tb_status` (`id_status`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tb_status_has_rl_pedido_produto_rl_pedido_produto1`
    FOREIGN KEY (`id_produto` , `cod_pedido`)
    REFERENCES `db_info`.`rl_pedido_produto` (`id_produto` , `cod_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

show tables;
desc tb_produto;