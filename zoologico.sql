CREATE TABLE animal (
  id integer PRIMARY KEY,
  classe varchar(25)
);

CREATE TABLE ave (
  ave_id integer PRIMARY KEY,
  nome varchar(85),
  nome_cientifico varchar(85),
  ordem varchar(85),
  familia varchar(85)
);

CREATE TABLE mamifero (
  mamifero_id integer PRIMARY KEY,
  nome varchar(85),
  nome_cientifico varchar(85),
  ordem varchar(85),
  familia varchar(85)
);

CREATE TABLE reptil (
  reptil_id integer PRIMARY KEY,
  nome varchar(85),
  nome_cientifico varchar(85),
  ordem varchar(85),
  familia varchar(85)
);

ALTER TABLE ave ADD CONSTRAINT ave_fk FOREIGN KEY (ave_id) REFERENCES animal (id);

ALTER TABLE mamifero ADD CONSTRAINT mamifero_fk FOREIGN KEY (mamifero_id) REFERENCES animal (id);

ALTER TABLE reptil ADD CONSTRAINT reptil_fk FOREIGN KEY (reptil_id) REFERENCES animal (id);

-- INSERTS -------------------------------------------- AVES --------------------------------------------------------------

INSERT INTO animal VALUES (6501, 'Aves');
INSERT INTO ave VALUES (6501, 'Arara-canindé', 'Ara ararauna', 'Psittaciformes', 'Psittacidae');

INSERT INTO animal VALUES (6502, 'Aves');
INSERT INTO ave VALUES (6502, 'Ararajuba', 'Guaruba guarouba', 'Psittaciformes', 'Psittacidae');

INSERT INTO animal VALUES (6503, 'Aves');
INSERT INTO ave VALUES (6503, 'Ararinha-de-testa-vermelha', 'Ara rubrogenys', 'Psittaciformes', 'Psittacidae');

INSERT INTO animal VALUES (6504, 'Aves');
INSERT INTO ave VALUES (6504, 'Quero-quero', 'Vanellus chilensis', 'Charadriiformes', 'Charadriidae');

INSERT INTO animal VALUES (6505, 'Aves');
INSERT INTO ave VALUES (6505, 'Maçarico-real', 'Theristicus caerulescens', 'Pelicaniformes', 'Threskiornithidae');

INSERT INTO animal VALUES (6506, 'Aves');
INSERT INTO ave VALUES (6506, 'Harpia', 'Harpia harpyja', 'Accipitriformes', 'Accipitridae');

INSERT INTO animal VALUES (6507, 'Aves');
INSERT INTO ave VALUES (6507, 'Pavão-azul', 'Pavo cristatus', 'Galliformes', 'Phasianidae');

-- INSERTS ------------------------------------------- Mammalia -----------------------------------------------------------

INSERT INTO animal VALUES (7701, 'Mammalia');
INSERT INTO mamifero VALUES (7701, 'Mico-estrela', 'Callithrix penicillata', 'Primates', 'Callitrichidae');

INSERT INTO animal VALUES (7702, 'Mammalia');
INSERT INTO mamifero VALUES (7702, 'Macaco-aranha-de-cara-preta', 'Ateles chamek', 'Primates', 'Atelidae');

INSERT INTO animal VALUES (7703, 'Mammalia');
INSERT INTO mamifero VALUES (7703, 'Cervo-nobre', 'Cervus elaphus', 'Cetartiodactyla', 'Cervidae');

INSERT INTO animal VALUES (7704, 'Mammalia');
INSERT INTO mamifero VALUES (7704, 'Babuíno-sagrado', 'Papio hamadryas', 'Primates', 'Cercopithecidae');

INSERT INTO animal VALUES (7705, 'Mammalia');
INSERT INTO mamifero VALUES (7705, 'Cuxiú-preto', 'Primates', 'Pitheciidae');

INSERT INTO animal VALUES (7706, 'Mammalia');
INSERT INTO mamifero VALUES (7706, 'Guaxinim', 'Procyon cancrivorus', 'Carnivora', 'Procyonidae');

INSERT INTO animal VALUES (7707, 'Mammalia');
INSERT INTO mamifero VALUES (7707, 'Lhama', 'Lama glama', 'Cetartiodactyla', 'Camelidae');

INSERT INTO animal VALUES (7708, 'Mammalia');
INSERT INTO mamifero VALUES (7708, 'Adax', 'Addax nasomaculatus', 'Cetartiodactyla', 'Bovidae');

INSERT INTO animal VALUES (7709, 'Mammalia');
INSERT INTO mamifero VALUES (7709, 'Anta', 'Tapirus terrestris', 'Perissodactyla', 'Tapiridae');

-- INSERTS ------------------------------------------- Reptilia -----------------------------------------------------------

INSERT INTO animal VALUES (8201, 'Reptilia');
INSERT INTO reptil VALUES (8201, 'Aperema', 'Rhinoclemmys punctularia', 'Testudines', 'Geoemydidae');

INSERT INTO animal VALUES (8202, 'Reptilia');
INSERT INTO reptil VALUES (8202, 'Gecko-leopardo', 'Eublepharis macularius', 'Squamata', 'Gekkonidae');

INSERT INTO animal VALUES (8203, 'Reptilia');
INSERT INTO reptil VALUES (8203, 'Jacaré-tinga', 'Caiman crocodilus', 'Crocodylia', 'Alligatoridae');

INSERT INTO animal VALUES (8204, 'Reptilia');
INSERT INTO reptil VALUES (8204, 'Jiboia-arco-íris', 'Epicrates crassus', 'Squamata', 'Boidae');

INSERT INTO animal VALUES (8205, 'Reptilia');
INSERT INTO reptil VALUES (8205, 'Salamanta', 'Epicrates cenchria', 'Squamata', 'Boidae');

INSERT INTO animal VALUES (8206, 'Reptilia');
INSERT INTO reptil VALUES (8206, 'Teiú', 'Salvator merianae', 'Squamata', 'Teiidae');

INSERT INTO animal VALUES (8207, 'Reptilia');
INSERT INTO reptil VALUES (8207, 'Tracajá', 'Podocnemis unifilis', 'Testudines', 'Emydidae');

-- Tabela de Backup para Aves ---------------------------------------------------------------------------------------------

CREATE TABLE backup_ave (
	ave_id int,
	nome varchar(85),
	nome_cientifico varchar(85),
	ordem varchar(85),
	familia varchar(85),
	horario timestamp,
	usuario varchar(25)
);

-- Função e Trigger Backup ------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION backup_ave() RETURNS TRIGGER
AS $$ BEGIN
  INSERT INTO backup_ave VALUES (OLD.ave_id, OLD.nome, OLD.nome_cientifico, OLD.ordem, OLD.familia,
                                CURRENT_TIMESTAMP, (SELECT current_user));
  RETURN OLD;
END; $$ LANGUAGE PLPGSQL;


CREATE TRIGGER trigg_backup_ave BEFORE DELETE ON
ave FOR EACH ROW EXECUTE PROCEDURE backup_ave();

-- Índices ----------------------------------------------------------------------------------------------------------------

CREATE INDEX idx_animal_id ON animal (id);
CREATE INDEX idx_ave_nome ON ave (nome);
CREATE INDEX idx_mamifero_nome ON mamifero (nome);
CREATE INDEX idx_reptil_nome ON reptil (nome);

-- Criação Usuário --------------------------------------------------------------------------------------------------------

CREATE ROLE pesquisador WITH login password 'pesquisador';
GRANT SELECT ON animal, ave, backup_ave, mamifero, reptil TO pesquisador;

-- Criação Visão ----------------------------------------------------------------------------------------------------------

CREATE VIEW animais_a AS
  SELECT id, classe, nome, nome_cientifico, ordem, familia FROM animal JOIN ave ON ave.ave_id=animal.id WHERE nome LIKE 'A%'

  UNION

  SELECT id, classe, nome, nome_cientifico, ordem, familia FROM animal JOIN mamifero ON mamifero.mamifero_id=animal.id WHERE NOME LIKE 'A%'

  UNION

  SELECT id, classe, nome, nome_cientifico, ordem, familia FROM animal JOIN reptil ON reptil.reptil_id=animal.id WHERE NOME LIKE 'A%';

-- Trigger insere Visão ---------------------------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION animais_a() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.classe='Aves' THEN
    INSERT INTO animal VALUES (NEW.id, NEW.classe);
    INSERT INTO ave VALUES (NEW.id, NEW.nome, NEW.nome_cientifico, NEW.ordem, NEW.familia);

  ELSIF NEW.classe='Mammalia' THEN
    INSERT INTO animal VALUES (NEW.id, NEW.classe);
    INSERT INTO mamifero VALUES (NEW.id, NEW.nome, NEW.nome_cientifico, NEW.ordem, NEW.familia);

  ELSE
    INSERT INTO animal VALUES (NEW.id, NEW.classe);
    INSERT INTO reptil VALUES (NEW.id, NEW.nome, NEW.nome_cientifico, NEW.ordem, NEW.familia);

  END IF;

  RETURN NEW;
END; $$ LANGUAGE PLPGSQL SECURITY DEFINER;

CREATE TRIGGER trigg_animais_a INSTEAD OF INSERT ON animais_a
FOR EACH ROW EXECUTE PROCEDURE animais_a();

-- PARA TESTE: INSERT INTO animais_a VALUES (8208, 'Reptilia', 'Suaçuboia', 'Corallus hortulanus', 'Squamata', 'Boidae');

-- Permissão Usuário -------------------------------------------------------------------------------------------------------

GRANT SELECT, INSERT ON animais_a TO pesquisador;
