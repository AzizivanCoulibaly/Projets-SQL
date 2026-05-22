/*======================================================================
Maîtriser CASE WHEN
======================================================================*/

/*======================================================================
Utilisation de CASE WHEN pour appliquer une logique conditionnelle
SELECT colonnes,
       CASE
           WHEN condition THEN resultat1
           ELSE resultat2
       END AS nom_colonne_resultat
FROM table;

Explication:
- SELECT colonnes : spécifie les colonnes à récupérer dans le résultat final, ainsi que la colonne conditionnelle.
- CASE WHEN condition THEN resultat1 ELSE resultat2 END : applique une logique conditionnelle sur les données récupérées. Si la condition est vraie, alors le 'resultat1' est retourné. Sinon, le 'resultat2' est utilisé.
- AS nom_colonne_resultat : attribue un nom à la colonne résultante de l'expression CASE.

Cette instruction est utile pour transformer des données en fonction de conditions spécifiques directement dans la requête SQL, permettant de simplifier la logique de traitement des données et de réduire le besoin de logique conditionnelle dans l'application cliente.
======================================================================*/

-- Écrire une requête SQL permettant de classifier pour chaque produit sa catégorie "Petit Budget" 
-- si le prixUnitaire est <200 euros
-- "Moyen Budget" si le prixUnitaire est compris entre 200 et 500
-- "Grand Budget" si le prix unitaire est supérieur à 500 

SELECT NomProduit, PrixUnitaire, CASE 
									WHEN PrixUnitaire < 200 THEN "Petit Budget"
                                    WHEN PrixUnitaire BETWEEN 200 AND 500 THEN "Moyen Budget"
                                    ELSE "Grand Budget" END AS Classification
FROM Produits;

-- le nombre de ventes et une étiquette qui indique si le nombre de ventes est inférieur à 50, compris entre 50 et 100 ou supérieur à 100

SELECT Nom, Prenom, COUNT(VenteID) AS NbreVte, CASE
												WHEN COUNT(VenteID)< 50 THEN "< 50"
												WHEN COUNT(VenteID) BETWEEN 50 AND 100 THEN "Compris entre 50 et 100"
												ELSE ">50" END AS Ettiquette
FROM Clients
LEFT JOIN Ventes USING (ClientID)
GROUP BY Nom, Prenom;

-- Créer une requête qui donne le nom, le prénom et sa catégorie :
-- Silver si les achats sont inférieurs à 1000, GOLD entre 1000 et 5000, premium > 5000

SELECT Nom, Prenom, SUM(MontantTotal) AS SmAchat, CASE 
														WHEN SUM(MontantTotal) < 1000 THEN "Silver"
                                                        WHEN SUM(MontantTotal) is null THEN "Sleeping"
                                                        WHEN SUM(MontantTotal) BETWEEN 1000 AND 5000 THEN "Gold"
                                                        ELSE "Premium" END AS Categorie
 FROM Clients
 LEFT JOIN Ventes USING (ClientID)
 GROUP BY Nom, Prenom;
													
/* Comprendre les sous-requêtes */

/* Utilisation des sous-requêtes dans la clause WHERE */

/*======================================================================
Utilisation de sous-requêtes dans la clause WHERE pour des filtres avancés
SELECT colonne1, colonne2, ...
FROM table1
WHERE colonneX [NOT] IN (SELECT colonneY FROM table2 WHERE condition);

Explication:
- La clause WHERE avec sous-requête permet de filtrer les enregistrements de la requête principale en fonction des résultats de la sous-requête.
- L'opérateur [NOT] IN est utilisé pour inclure ou exclure les enregistrements correspondant aux valeurs retournées par la sous-requête.

Conseil :
- Utilisez des sous-requêtes dans WHERE pour des comparaisons qui nécessitent des ensembles de valeurs ou des conditions complexes.
- Assurez-vous que les sous-requêtes sont bien indexées pour éviter les performances lentes sur de grandes bases de données.
======================================================================*/

-- Donner la liste des produits qui n'ont pas été vendus en 2023
SELECT ProduitID, NomProduit, YEAR(DateVente)
FROM Produits
LEFT JOIN Ventes USING(ProduitID)
WHERE ProduitID NOT IN (SELECT ProduitID
FROM Ventes
WHERE YEAR(DateVente) = 2023);

-- Quels clients ont un historique d'achat supérieur à la moyenne des achats ?
SELECT *, Nom, Prenom
FROM Ventes
LEFT JOIN Clients USING(ClientID)
WHERE MontantTotal > (SELECT AVG(MontantTotal) AS MynAchat
FROM Ventes);

-- Quels sont les noms des produits qui ont un prix unitaire supérieur à la moyenne des prix de tous les produits ?
SELECT NomProduit
FROM Produits
WHERE PrixUnitaire >( SELECT AVG(PrixUnitaire)
FROM Produits);

-- Exercice : Écrire une requête qui permet de lister les clients qui n'ont jamais réalisé d'achat
SELECT ClientID, Nom, Prenom
FROM Clients
WHERE ClientID NOT IN (
SELECT ClientID
FROM Ventes);

/* Utilisation des sous-requêtes dans la clause FROM */

/*======================================================================
Utilisation de sous-requêtes dans la clause FROM pour créer des tables temporaires
SELECT colonne1, colonne2, ...
FROM (SELECT colonneA, colonneB FROM table2 WHERE condition) AS sub_table
WHERE sub_table.colonneA = condition;

Explication:
- La clause FROM avec sous-requête crée une vue temporaire 'sub_table' qui peut être utilisée comme n'importe quelle autre table dans la requête principale.
- La sous-requête dans FROM est souvent utilisée pour simplifier des requêtes complexes ou pour effectuer des pré-filtrages.

Conseil :
- Donnez des alias clairs aux sous-tables pour améliorer la lisibilité de vos requêtes.
- Préfiltrez autant que possible dans la sous-requête pour réduire la charge de traitement dans la requête principale.
======================================================================*/

-- Donner pour chaque employé, le nom, le prénom et la moyenne des ventes annuelle
SELECT Nom, Prenom
FROM (
		SELECT EmployeID,YEAR(DateVente), AVG(MontantTotal) As MynVte
		FROM Ventes
		GROUP BY EmployeID,YEAR(DateVente))AS mytAnnee
RIGHT JOIN Employes USING (EmployeID); 


SELECT Nom, Prenom, AVG(MontantTotal) AS MynVte
FROM Employes
LEFT JOIN Ventes USING(EmployeID)
GROUP BY Nom, Prenom;

-- Quel est le taux de croissance du chiffre d'affaires entre 2021 et 2022 ?
WITH CA2021 AS(
SELECT SUM(MontantTotal) AS CA_2021
FROM Ventes
WHERE YEAR(DateVente) = 2021),

CA2022 AS(
SELECT SUM(MontantTotal) AS CA_2022
FROM Ventes
WHERE YEAR(DateVente) = 2022)

SELECT (CA_2022-CA_2021)/NULLIF(CA_2021,0)*100 AS TxCroissant
FROM CA2021, CA2022;



-- Exercice : Donner la liste des 10 clients dont la moyenne du nombre d'achats annuelle est le plus élevé
WITH AnneNbre AS(
SELECT ClientID, YEAR(DateVente)AS Annee, COUNT(VenteID) AS NbreAchat
FROM Ventes
GROUP BY ClientID,YEAR(DateVente)
)

SELECT Nom, Prenom, Annee, AVG(NbreAchat)
FROM AnneNbre
LEFT JOIN Clients USING (ClientID)
GROUP BY Nom, Prenom, Annee
ORDER BY AVG(NbreAchat) DESC
LIMIT 10;

/* Utilisation des sous-requêtes dans la clause SELECT */

/*======================================================================
Utilisation de sous-requêtes dans la clause SELECT pour des calculs par ligne
SELECT colonne1, (SELECT COUNT(*) FROM table2 WHERE table2.colonneY = table1.colonneX) AS count_colonne
FROM table1;

Explication:
- La sous-requête dans SELECT permet de retourner des valeurs calculées pour chaque ligne de la table principale, idéal pour des agrégations ou des calculs conditionnels.
- Ces sous-requêtes sont souvent corrélées, c'est-à-dire qu'elles font référence à des colonnes de la requête principale.

Conseil :
- Utilisez les sous-requêtes dans SELECT pour des calculs détaillés ou des conditions qui varient par ligne.
- Veillez à ce que les requêtes soient optimisées pour éviter un impact négatif sur les performances, surtout avec des sous-requêtes corrélées dans des tables volumineuses.
======================================================================*/

-- Quels sont les produits qui ont un prix unitaire supérieur à la moyenne des prix unitaires 
-- de tous les produits vendus, et combien de fois ont-ils été vendus ?

SELECT AVG(PrixUnitaire) AS moyenne_des_prix_unitaires
FROM Produits;


SELECT NomProduit,PrixUnitaire, (SELECT COUNT(*) 
									FROM Ventes
									)AS NbreAchat
FROM Produits
WHERE PrixUnitaire > (SELECT AVG(PrixUnitaire) AS moyenne_des_prix_unitaires
FROM Produits)
GROUP BY NomProduit,PrixUnitaire ;


/* Multijointure */
-- Lister les noms des employés avec le détail des produits et les informations sur les clients ayant réalisé la vente

SELECT 
		v.VenteID,
        v.MontantTotal
		EmployeID, 
		em.Nom AS NomEmploye, 
		em.Prenom AS PrenomEmploye, 
		p.NomProduit, 
		p.DescProduit, 
		p.PrixUnitaire,
        c.Nom AS NomClient,
        c.Prenom AS PrenomClient,
        c.Adresse,
        c.Email,
        c.NumeroTelephone
FROM Ventes v
JOIN Employes em USING(EmployeID)
JOIN Produits p USING (ProduitID)
JOIN Clients c USING(ClientID);

-- Donner la liste des noms de fournisseur, le nom de produit et les noms des clients pour tous les produits qui ont été achetés plus de 50 fois
SELECT 
		f.NomFournisseur,
        p.NomProduit,
        c.Nom AS NomClient,
        c.Prenom AS PrenomClient,
        COUNT(*) AS NbreAchat
FROM Ventes v
JOIN Produits p USING (ProduitID)
JOIN Fournisseurs f USING (FournisseurID)
JOIN Clients c USING (ClientID)
GROUP BY 	
		f.NomFournisseur,
        p.NomProduit,
        NomClient,
        PrenomClient
HAVING COUNT(*) > 50;
			/* Reponse : Aucun, le maximum de nombre d'achat est 1 du à la nature des données*/	
            
