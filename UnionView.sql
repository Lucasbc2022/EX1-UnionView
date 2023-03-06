CREATE DATABASE View_Exercicio
GO

USE View_Exercicio
GO

CREATE TABLE Motorista (
Codigo                  INT               NOT NULL,
Nome                    VARCHAR(30)       NOT NULL,
Naturalidade            VARCHAR(30)       NOT NULL
PRIMARY KEY(Codigo)
)
GO


CREATE TABLE Onibus (
Placa                   VARCHAR(7)        NOT NULL,
Marca                   VARCHAR(20)       NOT NULL,
Ano                     INT               NOT NULL,
Descricao               VARCHAR(30)       NOT NULL
PRIMARY KEY(Placa)
)
GO


CREATE TABLE Viagem (
Codigo_Viagem           INT                                       NOT NULL,
Placa_Onibus            VARCHAR(7)                                NOT NULL,
Codigo_Motorista        INT                                       NOT NULL,
Hora_de_Saida           INT           CHECK(Hora_de_Saida >=0)    NOT NULL,
Hora_de_Chegada         INT           CHECK(Hora_de_Chegada >=0)  NOT NULL,
Partida                 VARCHAR(30)                               NOT NULL,
Destino                 VARCHAR(30)                               NOT NULL
PRIMARY KEY(Codigo_Viagem)
FOREIGN KEY(Placa_Onibus)  REFERENCES Onibus(Placa),
FOREIGN KEY(Codigo_Motorista)  REFERENCES Motorista(Codigo)   
)
GO




--Exercício:
/*1) Criar um Union das tabelas Motorista e ônibus, com as colunas ID 
  (Código e Placa) e Nome (Nome e Marca)
 */


SELECT CONVERT(VARCHAR(10), Codigo) AS ID,
       Nome AS Nome
FROM Motorista
UNION
SELECT Placa AS ID,
       Marca AS Nome
FROM Onibus

--2) Criar uma View (Chamada v_motorista_onibus) do Union acima


CREATE VIEW v_motorista_onibus
AS
   SELECT CONVERT(VARCHAR(10), Codigo) AS ID,
          Nome AS Nome
   FROM Motorista

   UNION

   SELECT Placa AS ID,
          Marca AS Nome
   FROM Onibus

   SELECT * FROM v_motorista_onibus

   
/*3) Criar uma View (Chamada v_descricao_onibus) que mostre o Código da Viagem,
  o Nome do motorista, a placa do ônibus (Formato XXX-0000), a Marca do ônibus, 
  o Ano do ônibus e a descrição do onibus
 */


CREATE VIEW v_descricao_onibus
AS
   SELECT v.Codigo_Viagem,
          m.Nome AS Nome_do_motorista,
		  SUBSTRING(oni.Placa, 1, 3) +'-'+ SUBSTRING(oni.Placa, 4, 4) AS placa_do_onibus,
		  oni.Marca AS Marca_do_ônibus,
		  oni.Ano AS Ano_do_ônibus,
		  oni.Descricao
   FROM Motorista m, Onibus oni, Viagem v
   WHERE m.Codigo = v.Codigo_Motorista
         AND v.Placa_Onibus = oni.Placa


SELECT * FROM v_descricao_onibus
  

/*4) Criar uma View (Chamada v_descricao_viagem) que mostre o Código da viagem, 
  a placa do ônibus(Formato XXX-0000), a Hora da Saída da viagem (Formato HH:00), 
  a Hora da Chegada da viagem (Formato HH:00), partida e destino
 */

SELECT * FROM Motorista
SELECT * FROM Onibus
SELECT * FROM Viagem

CREATE VIEW v_descricao_viagem
AS
   SELECT v.Codigo_Viagem,
          SUBSTRING(oni.Placa, 1, 3) +'-'+SUBSTRING(oni.Placa, 4, 4) AS Placa,
		  CONVERT(VARCHAR(5), CONVERT(TIME, CAST(Hora_de_Saida AS VARCHAR(10)) + ':00')) AS Hora_de_Saida,
		  CONVERT(VARCHAR(5), CONVERT(TIME, CAST(Hora_de_Chegada AS VARCHAR(10)) + ':00')) AS Hora_de_Chegada,
		  v.Partida,
		  v.destino
   FROM Viagem v, Onibus oni
   WHERE v.Placa_Onibus = oni.Placa




SELECT * FROM v_descricao_viagem 
