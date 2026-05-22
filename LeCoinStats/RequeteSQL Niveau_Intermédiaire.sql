-- Liste des clients dont le nom contient une seule fois la lettre A
SELECT *
FROM Clients
WHERE Nom LIKE "%A%" AND Nom NOT LIKE  "%A%A%";

-- Contient deux occurrences de la lettre A
SELECT *
FROM Clients
WHERE Nom like "%A%A%";



/*==================================================================================
               Maîtriser les expressions régulières en SQL
==================================================================================*/

-- Expressions régulières en SQL permettent de faire des recherches de texte complexes.

/*======================================================
Fonctionnalité 1: Recherche basique avec REGEXP
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE nom_colonne REGEXP 'pattern';
======================================================*/

-- Liste des produits qui contiennent "TV" (deux possibilités avec LIKE)
SELECT NomProduit
FROM Produits
WHERE NomProduit LIKE "%TV%"; 

-- Avec REGEXP
SELECT NomProduit
FROM Produits
WHERE NomProduit REGEXP "TV";  

/*======================================================
Pour indiquer le début d'une chaîne de caractères, utilisez le caractère "^" au début de l'expression.
======================================================*/

-- Liste des produits dont le nom commence par la lettre "D"
SELECT NomProduit
FROM Produits
WHERE NomProduit LIKE "D%"; 


-- Avec une expression régulière
SELECT NomProduit
FROM Produits
WHERE NomProduit REGEXP "^D"; 

/*======================================================
Pour indiquer la fin d'une chaîne de caractères, utilisez le caractère "$" à la fin de l'expression.
======================================================*/

-- Liste des produits qui se terminent par "M"
SELECT NomProduit
FROM Produits
WHERE NomProduit LIKE "%M"; 

-- Avec une expression régulière
SELECT NomProduit
FROM Produits
WHERE NomProduit REGEXP "M$";

/*======================================================
Rechercher plusieurs patterns dans la chaîne de caractères en utilisant le symbole "|"
======================================================*/

-- Liste des clients dont le numéro contient "05" ou "04"
SELECT Nom, NumeroTelephone
FROM Clients
WHERE NumeroTelephone LIKE 05 OR  NumeroTelephone LIKE 04;

-- Avec REGEXP
SELECT Nom, NumeroTelephone
FROM Clients
WHERE NumeroTelephone REGEXP "05|04";

-- Avec REGEXP


/*======================================================================
Exercice 1: Liste des clients dont le numéro commence par "05" ou se termine par "94"
======================================================================*/

-- Avec LIKE
SELECT Nom, NumeroTelephone
FROM Clients
WHERE NumeroTelephone LIKE "05%" OR  NumeroTelephone LIKE "%94";

-- Avec REGEXP
SELECT Nom, NumeroTelephone
FROM Clients
WHERE NumeroTelephone REGEXP "^05|94$";

/*======================================================================
Utilisation des caractères spéciaux "." (n'importe quel caractère)
Syntaxe générale:
SELECT nom_colonne
FROM nom_table
WHERE nom_colonne REGEXP 'pattern';
======================================================================*/

-- Exemple: Sélectionner les clients dont le nom contient 'R' suivi de n'importe quel caractère et ensuite 'a'

-- Avec LIKE (underscore)
SELECT *
FROM Clients
WHERE Nom LIKE "%R_a%";

-- Avec REGEXP
SELECT *
FROM Clients
WHERE Nom REGEXP "R.a";

/*======================================================================
Exercice: Liste des clients dont le nom commence par "R" et se termine par "A"
======================================================================*/

-- Avec LIKE
SELECT Nom
FROM Clients
WHERE Nom LIKE "R%A";
-- Avec REGEXP
SELECT Nom
FROM Clients
WHERE Nom REGEXP "^R.*A$";

/*======================================================================
Astuces: []
======================================================================*/

-- Liste des clients dont le nom contient "it" ou "ie" ou "il" ou "is" 
SELECT Nom
FROM Clients
WHERE Nom LIKE "it" or Nom LIKE "ie" or Nom LIKE "il" or Nom LIKE "is";

-- Liste des clients dont le nom contient n'importe quelle lettre de 'a' à 'g' suivie de 'l'
SELECT Nom
FROM Clients
WHERE Nom REGEXP "i[tels]";



/*======================================================================
Limitation des résultats d'une requête avec LIMIT
SELECT nom_colonnes
FROM nom_table
WHERE conditions 
LIMIT nombre_de_lignes;

======================================================================*/

-- Donner la liste des 10 premiers clients par ordre alphabétique
SELECT Nom,Prenom
FROM Clients
ORDER BY Nom 
LIMIT 10;


-- Donner la liste des 10 produits les plus chers
SELECT NomProduit, PrixUnitaire
FROM Produits
ORDER BY PrixUnitaire DESC 
LIMIT 10;

-- Donner la liste des 10 produits les plus moins
SELECT NomProduit, PrixUnitaire
FROM Produits
ORDER BY PrixUnitaire ASC 
LIMIT 10;


/*==================================================================================
               Maîtriser les fonctions d'agrégation en SQL
==================================================================================*/

/*======================================================
Fonctions d'agrégation en SQL
======================================================*/

-- Les fonctions d'agrégation en SQL sont utilisées pour effectuer des calculs sur un ensemble de valeurs dans une colonne. Elles sont couramment utilisées pour obtenir des statistiques résumées à partir des données.

/*======================================================
Fonction COUNT()
======================================================*/

-- La fonction COUNT() permet de compter le nombre de lignes dans un ensemble de données.

-- Question: Combien y a-t-il de clients dans la base de données ?
SELECT COUNT(ClientID) AS NBRE_Client
FROM Clients;

/*======================================================
Fonction SUM()
======================================================*/

-- Exemple: Calculer la somme totale des ventes dans la table "Ventes".
SELECT SUM(MontantTotal) AS CA
FROM Ventes;

/*======================================================
Fonction AVG()
======================================================*/
SELECT AVG(MontantTotal) AS MoyenneVte
FROM Ventes;

/*======================================================
Fonction MIN() et MAX()
======================================================*/

-- Les fonctions MIN() et MAX() permettent de trouver la valeur minimale et maximale dans une colonne, respectivement.


-- Exemple: Quel est le produit le moins cher ? Quel est le produit le plus cher ?
SELECT NomProduit, PrixUnitaire
FROM Produits
ORDER BY PrixUnitaire DESC
LIMIT 1;

SELECT MAX(PrixUnitaire)
FROM Produits;


/*======================================================
Fonction SUM(DISTINCT)
======================================================*/

-- La fonction SUM(DISTINCT) permet de calculer la somme des valeurs uniques dans une colonne.

-- Exemple: Calculer la somme totale des ventes uniques dans la table "Ventes".
SELECT SUM(DISTINCT MontantTotal)
FROM Ventes;
/*======================================================
Fonction AVG(DISTINCT)
======================================================*/

-- La fonction AVG(DISTINCT) permet de calculer la moyenne des valeurs uniques dans une colonne.

-- Exemple: Calculer la moyenne des ventes uniques.
SELECT AVG(DISTINCT MontantTotal)
FROM Ventes;
/*==================================================================================
              Maîtriser le REGROUPEMENT des Données (GROUP BY) en SQL
==================================================================================*/

-- Introduction au Regroupement des Données
-- Le regroupement des données est une fonctionnalité essentielle en SQL qui permet de regrouper les lignes de données en fonction des valeurs d'une ou plusieurs colonnes. Cette opération est souvent utilisée pour effectuer des calculs agrégés sur des groupes de données plutôt que sur l'ensemble des données.

/*Syntaxe de la Clause GROUP BY
-- La clause `GROUP BY` est utilisée pour spécifier les colonnes par lesquelles vous souhaitez regrouper vos données. La syntaxe générale est la suivante :
SELECT colonne1, colonne2, ..., fonction_agrégation(colonne)
FROM nom_table
GROUP BY colonne1, colonne2, ...; */

-- Exemple Pratique : Calculer la somme des ventes par employé.
SELECT EmployeID, SUM(MontantTotal) AS CA
FROM Ventes
Group by EmployeID;
		/*Avec leur nom */
SELECT EmployeID, Nom, SUM(MontantTotal) AS CA
FROM Employes
LEFT JOIN Ventes USING(EmployeID)
GROUP BY EmployeID, Nom;


-- Exemple Pratique : Compter le nombre de ventes par employé.
SELECT EmployeID, count(venteID) AS NbreVentes
FROM Ventes
Group by EmployeID;
			/*Avec leur nom */
SELECT EmployeID, Nom, COUNT(VenteID) AS CA
FROM Employes
LEFT JOIN Ventes USING(EmployeID)
GROUP BY EmployeID, Nom;

-- Exemple pratique: Déterminer la somme des ventes par année.
SELECT VenteID, YEAR(DateVente) AS Annee, SUM(MontantTotal) AS CA
FROM Ventes
GROUP BY VenteID, YEAR(DateVente);



-- Exemple Pratique : Quelle est la moyenne des ventes par année et par employé
SELECT YEAR(DateVente) AS Annee, EmployeID, AVG(MontantTotal) AS Myn_Vente
FROM Ventes
GROUP BY EmployeID, Annee; 

-- Utilisation de Fonctions d'Agrégation
-- En combinaison avec la clause `GROUP BY`, vous pouvez utiliser des fonctions d'agrégation telles que SUM(), COUNT(), AVG(), MIN(), MAX(), etc., pour effectuer des calculs sur les groupes de données résultants. Cela vous permet d'obtenir des statistiques résumées par groupe.

/*======================================================
Fonction HAVING
======================================================*/

-- La clause HAVING est utilisée avec GROUP BY pour filtrer les groupes de résultats basés sur une condition agrégée.

-- Exemple: Donner la liste des employés dont la moyenne des ventes est supérieure à 1000 euros.
SELECT EmployeID, AVG(MontantTotal) AS Moynne_Vente
FROM Ventes
GROUP BY EmployeID
HAVING AVG(MontantTotal) > 1000; 
			/*Avec leur nom */
SELECT EmployeID, Nom, AVG(MontantTotal) AS Moynne_Vente
FROM Employes
LEFT JOIN Ventes USING(EmployeID)
GROUP BY EmployeID
HAVING AVG(MontantTotal) > 1000; 

-- Exercice: Donner la liste des 5 employés ayant la somme des ventes la plus élevée.
SELECT EmployeID, SUM(MontantTotal) AS CA
FROM Ventes
GROUP BY EmployeID
ORDER BY CA DESC
LIMIT 5;
			/*Avec leur nom */
SELECT EmployeID, Nom, SUM(MontantTotal) AS CA
FROM Employes
LEFT JOIN Ventes USING(EmployeID)
GROUP BY EmployeID, Nom
ORDER BY CA DESC
LIMIT 5;
/*==================================================================================
               Maîtriser les Jointures en SQL
==================================================================================*/

/*======================================================
Introduction aux Jointures en SQL
======================================================*/

-- Les jointures en SQL sont utilisées pour combiner des données de deux ou plusieurs tables en fonction d'une relation entre les colonnes de ces tables. Elles permettent de récupérer des informations provenant de plusieurs tables dans une seule requête.

/*======================================================
Jointure Interne (INNER JOIN) avec USING
======================================================*/

-- La jointure interne combine les lignes de deux tables en utilisant une condition de correspondance spécifiée, et seules les lignes qui satisfont cette condition sont incluses dans le résultat. La clause USING permet de spécifier la colonne de correspondance commune.

-- Exemple :Pour chaque vente donner le nom, le prénom et l'adresse de l'employé ayant réalisé la vent
SELECT VenteID, Nom, Prenom, Email
FROM Ventes
JOIN Employes USING(EMPLOYEID);




