-- Création de la table "Clients"
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY,
    Nom VARCHAR(200),
    Prenom VARCHAR(200),
    Adresse VARCHAR(200),
    Email VARCHAR(200),
    NumeroTelephone VARCHAR(30)
);




-- Création de la table Fournisseurs
CREATE TABLE Fournisseurs (
	FournisseurID INT PRIMARY KEY,
    NomFournisseur VARCHAR(200),
    Adresse VARCHAR(100),
    Email VARCHAR(200),
    NumeroTelephone VARCHAR(200)
    ) ;
    
-- Creation de la table employe
CREATE TABLE Employes (
	EmployeID INT PRIMARY KEY,
    Nom VARCHAR(200),
    Prenom VARCHAR(200),
    Fonction VARCHAR(200),
    Email VARCHAR(200),
    NuméroTelephone VARCHAR(200)
    ) ;
    
 -- Création de la table "Produits"
CREATE TABLE Produits (
    ProduitID INT PRIMARY KEY,
    NomProduit VARCHAR(200),
    Description TEXT,
    PrixUnitaire DECIMAL(10, 2),
   FournisseurID INT,
   FOREIGN KEY(FournisseurID)  REFERENCES Fournisseurs(FournisseurID)
);


 -- Création de la table vente 
CREATE TABLE Ventes (
    VenteID INT PRIMARY KEY,
    DateVente DATE,
    ClientID INT,
    ProduitID INT,
    EmployeID INT,
    FOREIGN KEY(ClientID) REFERENCES Clients(ClientID),
    FOREIGN KEY(ProduitID)  REFERENCES Produits(ProduitID),
    FOREIGN KEY(EmployeID) REFERENCES Employes(EmployeID),
    QuantiteVendue INT,
    MontantTotal DECIMAL(10, 2)
);
-- Integration des données CSV

-- Lire des informations dans la base

/*======================================================*/
/*                 Maîtriser la clause SELECT           */
/*======================================================*/

/*======================================================*/
/* Fonctionnalité 1: Sélectionner toutes les informations d'une table 
Syntaxe générale:
SELECT *
FROM nom_table;
*/
/*======================================================*/

-- QUESTION 1: Donner la table complète des produits vendus par l'entreprise 
SELECT *
FROM Produits;

-- QUESTION 2: Donner la table complète des clients de l'entreprise
SELECT *
FROM Clients;

/*======================================================*/
/* Fonctionnalité 2: Sélectionner une seule colonne
Syntaxe générale:
SELECT nom_colonne
FROM nom_table;
*/
/*======================================================*/

-- QUESTION 3: Donner le nom de tous les produits de la base de données
SELECT NomProduit
FROM Produits;

-- QUESTION 4: Donner le nom de tous les fournisseurs de la base de données
SELECT NomFournisseur
FROM Fournisseurs;

 
/*======================================================*/
/* Fonctionnalité 3: Sélectionner deux ou plusieurs colonnes
Syntaxe générale:
SELECT nom_colonne1, nom_colonne2,..., nom_colonne3
FROM nom_table;
======================================================*/

-- QUESTION 5: Donner le nom et le prénom des employés de l'entreprise
SELECT Nom, Prenom
FROM Employes;

-- QUESTION 6: Donner le nom, le prix et la description de tous les produits
SELECT NomProduit, PrixUnitaire, DescProduit
FROM Produits;
 
/*======================================================*/
/* Fonctionnalité 4: Sélectionner des valeurs distinctes
Syntaxe générale:
SELECT DISTINCT nom_colonne
FROM nom_table;
======================================================*/

-- QUESTION 7: Donner les différentes dates auxquelles des ventes ont été réalisées
SELECT Distinct DateVente
FROM Ventes;

-- QUESTION 8: Donner les noms et prénoms distincts des employés de l'entreprise
SELECT DISTINCT Nom, Prenom
FROM Employes;

/*==========================================================================================*/
/*                 Maîtriser la clause WHERE POUR FILTRER suivant des conditions           */
/*==========================================================================================*/

/*======================================================*/
/* Fonctionnalité 6: Filtrer suivant une condition
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE condition;
======================================================*/
-- Liste produit vendu dont le prix est 50
SELECT NomProduit
FROM Produits
WHERE PrixUnitaire = 50;

-- Liste produit vendu est à > 200
SELECT NomProduit, PrixUnitaire
FROM Produits
WHERE PrixUnitaire > 200;

-- Liste produit vendu est à <= 200
SELECT NomProduit, PrixUnitaire
FROM Produits
WHERE PrixUnitaire <= 200;

-- Liste produit vendu compris et 50 et 100
SELECT NomProduit, PrixUnitaire
FROM Produits
WHERE PrixUnitaire BETWEEN 50 AND 100;



-- QUESTION 9: Information sur le produit "Nike Air Max" 
SELECT *
FROM Produits
WHERE NomProduit = "Nike Air Max";

-- QUESTION 10: Donner la liste des produits du fournisseur numéro 13
SELECT NomProduit, FournisseurID
FROM Produits
WHERE FournisseurID = 13;

-- Description des produits du fournisseur numéro 13
SELECT NomProduit, DescProduit, FournisseurID
FROM Produits
WHERE FournisseurID = 13;


/*======================================================*/
/* Fonctionnalité 7: Utilisation de plusieurs conditions avec AND et OR
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE condition1 AND/OR condition2;
======================================================*/
-- Liste des produits vendu par le fournisseur 13 ou par le fournisseur 11
SELECT NomProduit, DescProduit, FournisseurID
FROM Produits
WHERE FournisseurID = 13 OR 11;

/*======================================================*/
/* Fonctionnalité 8: Utilisation de IN dans la clause WHERE
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE nom_colonne IN (valeur1, valeur2, ...);
======================================================*/


/*======================================================*/
/* Fonctionnalité 9: Utilisation de BETWEEN dans la clause WHERE
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE nom_colonne BETWEEN valeur1 AND valeur2;
======================================================*/

-- Sélectionner les ventes réalisées entre le 1er janvier 2021 et le 31 décembre 2023
SELECT *
FROM Ventes
WHERE DateVente BETWEEN "2021-01-01" AND "2023-12-31";


/*======================================================*/
/* Fonctionnalité 10: Utilisation de LIKE dans la clause WHERE
Syntaxe générale:
SELECT nom_colonne 
FROM nom_table 
WHERE nom_colonne LIKE 'motif';
======================================================*/
-- Nom des clients qui commencent par la lettre c
SELECT Nom, Prenom
FROM Clients
WHERE Nom LIKE "C%";
			/*Avec REGEXP */
SELECT Nom, Prenom
FROM Clients
WHERE Nom REGEXP "^C";

-- Nom des clients qui commencent par la lettre c et qui se termine par a
SELECT Nom, Prenom
FROM Clients
WHERE Nom LIKE "C%A";
			/*Avec REGEXP */
SELECT Nom, Prenom
FROM Clients
WHERE Nom REGEXP "^C.*A$";

-- Le nom contient la lettre n
SELECT Nom, Prenom
FROM Clients
WHERE Nom LIKE "%n%";
			/*Avec REGEXP */
SELECT Nom, Prenom
FROM Clients
WHERE Nom REGEXP "n";

-- Le nom contient  "on"
SELECT Nom
FROM Clients
WHERE Nom LIKE "%on%";
		/*Avec REGEXP */
SELECT Nom
From Clients
WHERE Nom REGEXP "on"; 

-- Donner la liste des produits qui commencent par 'a'
SELECT NomProduit
FROM Produits
WHERE NomProduit LIKE "A%";
			/*Avec REGEXP */
SELECT NomProduit
FROM Produits
WHERE NomProduit REGEXP "^A";

-- Donner la liste des produits qui contiennent la lettre 'a'
SELECT NomProduit
FROM Produits
WHERE NomProduit LIKE "%A%";
				/*Avec REGEXP */
SELECT NomProduit
FROM Produits
WHERE NomProduit REGEXP "A";
-- Donner la liste des produits commençant par 'N' et finissant par 'x'
SELECT NomProduit
FROM Produits
WHERE NomProduit LIKE "%N%X";
				/*Avec REGEXP */
SELECT NomProduit
FROM Produits
WHERE NomProduit REGEXP "^N.*X$";
/*==========================================================================================
                 Maîtriser la clause ORDER BY POUR CLASSER
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE condition
ORDER BY nom_colonne [ASC | DESC], autre_nom_colonne [ASC | DESC], ...;
==========================================================================================*/

-- Donner la liste des produits du moins coûteux au plus coûteux
SELECT NomProduit, PrixUnitaire
FROM Produits
ORDER BY PrixUnitaire ;

-- Donner la liste des produits du prix le plus élevé au prix le moins élevé
SELECT NomProduit, PrixUnitaire
FROM Produits
ORDER BY PrixUnitaire DESC;

-- Liste des employés ordre alphabétique le nom  décroissant Prenom
SELECT Nom, Prenom
FROM Employes
ORDER BY nom ASC, Prenom DESC;

-- La liste des produits dont le prix est supérieur à 200, résultat par alphabétqiue suivant le nom du produit
SELECT NomProduit, PrixUnitaire
FROM Produits
WHERE PrixUnitaire > 200
ORDER BY PrixUnitaire DESC;

