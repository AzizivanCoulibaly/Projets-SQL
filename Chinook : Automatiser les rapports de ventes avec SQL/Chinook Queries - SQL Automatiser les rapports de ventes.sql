-- Chinook-queries 
-- AUTOMATISER LES RAPPORTS DE VENTES AVEC SQL

/*====================*/
/* 
Problématique métier

Une entreprise souhaite produire un rapport détaillant les ventes
totales par produit pour le dernier trimestre.
Objectif
Utiliser SQL pour extraire, filtrer et agréger les données nécessaires.

Compétences à acquérir

Requêtes SQL de base : SELECT, WHERE, GROUP BY, HAVING.
Calculs d’agrégats : SOMME, MOYENNE pour des KPI.
Automatisation des rapports avec des vues SQL.
/*====================*/

/*====================*/
/* Requêtes de base
/*====================*/

/* 1. Clients non américains : Fournissez une requête affichant les Clients (leurs noms complets, ID client et pays) qui ne sont pas aux
États-Unis.*/

		-- Avant de repondre à cette question, je prend connaissance de la table concerné, il est donc important d'évaluer la qualité de celle ci.
					/* Doublons : Identifier les clients qui auraient été enregistré plusieurs fois et comprendre pourquoi*/  
								/* Methode 1 Group BY & HAVING */ 
										SELECT CustomerID, FirstName, LastName, Country, COUNT(*) AS Nbre
										FROM Customer
										GROUP BY CustomerID, FirstName, LastName, Country
										HAVING COUNT(*) >1;
								/* Methode 2 ROW_NUMBER*/
										WITH Doublon AS(
												SELECT CustomerID, FirstName, LastName, Country, ROW_NUMBER () 
																								OVER(PARTITION BY CustomerID, FirstName, LastName, Country
																								ORDER BY CustomerID) AS Numbers
												FROM Customer
												GROUP BY CustomerID, FirstName, LastName, Country)
                                        SELECT CustomerID, FirstName, LastName, Country
                                        FROM Doublon
                                        WHERE Numbers > 1;
                                        
					/* Valeur distinctes sur champs pays : Identifier l'uniformiter de la colonne pays (US ; USA; United-State, Etats-Unis) afin d'obtenir une resultats correcte*/
						SELECT DISTINCT Country
						FROM Customer;
					
                    /* Valeur Null sur Pays : Une Valeur NULL sur Pays ne sera ni inclus, ni exclus silencieusement*/
						SELECT Country, COUNT(*)
						FROM Customer
						WHERE Country IS NULL
						GROUP BY Country; 
   
			/* Analyse Qualité : Cette table ne contient ni doublon, ni derivé de l'Anotation USA, ni valeur null sur ma colonne de filtre */
   /* Reponse*/
SELECT CustomerID, FirstName, LastName,Country
FROM Customer
WHERE Country != "USA"
ORDER BY CustomerID;

/* 2. Clients brésiliens : Fournissez une requête affichant uniquement les Clients provenant du Brésil.*/
SELECT CustomerID, FirstName, LastName,Country
FROM Customer
WHERE Country = "Brazil"
ORDER BY CustomerID;

/* 3. Factures des clients brésiliens : Fournissez une requête affichant les factures des clients qui sont du Brésil.
Le tableau résultant doit inclure le nom complet du client, l'ID de la facture, la date de la facture et le pays de facturation.*/
		/* Doublons : s'assurer que le numéro de facture est unique */  
								/* Methode 1 Group BY & HAVING */
											SELECT InvoiceID,  COUNT(*) AS Nbre
																					FROM Invoice
																					GROUP BY InvoiceID
																					HAVING COUNT(*) >1;
									
/* Reponse*/                                  
SELECT InvoiceID, InvoiceDate, FirstName, LastName, BillingCountry, Total
FROM Customer
LEFT JOIN Invoice USING(CustomerID)
WHERE Country = "Brazil";

/* 4. Agents de vente : Fournissez une requête affichant uniquement les employés qui sont des Agents de Vente*/
SELECT EmployeeID, LastName, FirstName, Title
FROM Employee
WHERE Title = "Sales Support Agent";

/*====================*/
/* Agrégations et relations
/*====================*/

		/* Note : J'utilise "USING" pour les jointures afin d'avoir une écriture simplifiée de mes requêtes; Cependant il est important de noter que pour ce faire 
        les clés de jointures doivent avoir la même dénomination dans chacune des tables, et qu'il n'y ai pas de filtre à effectuer dans la jointures*/  

/* 5. Pays uniques dans les factures : Fournissez une requête affichant une liste unique des pays de facturation présents dans la table Invoice.*/
SELECT DISTINCT BillingCountry
FROM Invoice;

/* 6. Factures par agent de vente : Fournissez une requête affichant les factures associées à chaque agent de vente.
Le tableau résultant doit inclure le nom complet de l'agent de
vente.*/

			/* Cette premiere requête nous évite d'avoir un LEFT JOIN qui se transforme en Inner Join, lorsque la condition de filtre est appliquè sur la table de droite; 
			le filtre est appliqué directement dans la jointure */
SELECT i.InvoiceID, em.EmployeeID, em.LastName, em.FirstName, i.Total
FROM Invoice i
LEFT JOIN Customer cu ON i.CustomerID = cu.CustomerID
LEFT JOIN Employee em ON cu.SupportRepId = em.EmployeeID
AND Title = "Sales Support Agent";
	/* Cette requête applique le filtre sur la table source, nous évitons que les donnée soit tronquer.*/
SELECT em.EmployeeID, em.LastName, em.FirstName, i.InvoiceId, i.Total
FROM Employee em
LEFT JOIN Customer cu ON em.EmployeeID = cu.SupportRepId
LEFT JOIN Invoice i ON cu.CustomerID = i.CustomerID
WHERE Title = "Sales Support Agent";

/* 7. Détails des factures : Fournissez une requête affichant le total de chaque facture, le nom du client, le pays et le nom de l'agent de vente.*/

SELECT i.InvoiceID,  cu.CustomerID, cu.FirstName, cu.LastName, cu.Country, em.EmployeeID, em.LastName, em.FirstName, i.Total
FROM Invoice i
LEFT JOIN Customer cu ON i.CustomerID = cu.CustomerID
LEFT JOIN Employee em ON cu.SupportRepId = em.EmployeeID
AND Title = "Sales Support Agent";

/*====================*/
/* Analyse par année et lignes de facture
/*====================*/


/* 8. Ventes par année : Combien de factures y a-t-il eu en 2021 et 2025 ? Quels sont les montants totaux des ventes pour chacune de ces années ?*/

SELECT YEAR(InvoiceDate), Count(*) AS NbreFacture, SUM(Total) AS MontantTotal
FROM Invoice
WHERE YEAR(InvoiceDate) IN (2021,2025)
GROUP BY YEAR(InvoiceDate);

/* 9. Articles pour une facture donnée : Fournissez une requête comptant le nombre d'articles (line items) pour l'ID de facture 37.*/
SELECT InvoiceID, Count(InvoicelineID) AS LineItems
FROM InvoiceLine
WHERE InvoiceID = 37;

/* 10. Articles par facture : Fournissez une requête comptant le nombre d'articles (line items) pour chaque facture.*/
SELECT InvoiceID, Count(InvoicelineID) AS LineItems
FROM InvoiceLine
GROUP BY InvoiceID;

/*====================*/
/*Détails des morceaux
/*====================*/
/* 11. Nom des morceaux : Fournissez une requête incluant le nom du morceau pour chaque ligne de facture.*/
SELECT il.InvoiceLineID, t.Name AS Nom_morceau
FROM InvoiceLine il
LEFT JOIN Track t USING(TrackId)
ORDER BY il.InvoiceLineID ;

/* 12. Morceaux et artistes : Fournissez une requête incluant le nom du morceau acheté ET le nom de l'artiste pour chaque ligne de facture.*/
SELECT il.InvoiceLineID, 
		t.Name AS Nom_morceau, 
        Ar.Name AS Nom_Artiste
FROM InvoiceLine il
LEFT JOIN Track t USING(TrackId)
LEFT JOIN Album Al USING(AlbumID)
LEFT JOIN Artist Ar USING(ArtistID)
ORDER BY il.InvoiceLineID ;

/*====================*/
/*Comptages et regroupements
/*====================*/
/* 13. Nombre de factures par pays : Fournissez une requête affichant le nombre de factures par pays.*/
SELECT Cu.Country, 
		COUNT(i.InvoiceID) AS Nbre_Facture,
        DENSE_RANK() OVER (ORDER BY COUNT(i.InvoiceID) DESC)AS Classement
FROM Customer Cu
LEFT JOIN Invoice i USING(CustomerID)
GROUP BY Cu.Country
ORDER BY Nbre_Facture DESC;

/* 14. Nombre de morceaux par playlist : Fournissez une requête affichant le nombre total de morceaux dans chaque playlist.
		Le nom de la playlist doit être inclus dans le tableau résultant.*/ 
SELECT P.PlaylistID, 
		P.Name AS Nom_Playlist, 
        COUNT(t.TrackID) AS Nbre_morceaux
FROM Playlist P
LEFT JOIN PlaylistTrack Pt USING(PlaylistID)
LEFT JOIN Track t USING(TrackID)
GROUP BY P.PlaylistID, Nom_Playlist;

/* 15. Liste des morceaux : Fournissez une requête affichant tous les morceaux (Tracks), mais sans afficher les IDs.
Le tableau résultant doit inclure le nom de l'album, le type de média et le genre.*/
SELECT DISTINCT t.Name AS Nom_morceau, 
		Al.Title AS Nom_Album,
        m.Name AS Type_media,
        ge.Name AS Genre
FROM Track t
LEFT JOIN Album Al USING (AlbumID)
LEFT JOIN MediaType m USING (MediaTypeID)
LEFT JOIN Genre ge USING (GenreID);

/*====================*/
/*Analyse des ventes
/*====================*/
/* 16. Factures et articles : Fournissez une requête affichant toutes les factures, avec le nombre d'articles par facture.*/
		/*Article considérer comme identifiant produit*/
SELECT InvoiceID, COUNT(TrackID) AS NbrArticle
FROM InvoiceLine
GROUP BY InvoiceID;

/* 17. Ventes par agent de vente : Fournissez une requête affichant les ventes totales réalisées par chaque agent de vente.*/
SELECT em.EmployeeID, em.LastName, em.FirstName, em.Title, SUM(i.Total) AS VenteTotal
FROM Employee em
LEFT JOIN Customer cu ON em.EmployeeID = cu.SupportRepID
LEFT JOIN Invoice i ON cu.CustomerID = i.CustomerID
WHERE Title = "Sales Support Agent"
GROUP BY em.EmployeeID, em.LastName, em.FirstName;

/* 18. Meilleur agent de 2009 : Quel agent de vente a réalisé le plus de ventes en 2021 ?*/
SELECT 
		YEAR(i.Invoicedate), 
		em.EmployeeID, 
		em.LastName, 
		em.FirstName, 
		em.Title, 
        SUM(i.Total) AS VenteTotal
FROM Employee em
LEFT JOIN Customer cu ON em.EmployeeID = cu.SupportRepID
LEFT JOIN Invoice i ON cu.CustomerID = i.CustomerID AND YEAR(i.Invoicedate) = 2021
WHERE Title = "Sales Support Agent" 
GROUP BY YEAR(i.Invoicedate), em.EmployeeID, em.LastName, em.FirstName
ORDER BY VenteTotal DESC
LIMIT 1;
		/* Classement Dense_rank() + conservation des valeurs null LEFT JOIN*/
SELECT 
		YEAR(i.Invoicedate), 
		em.EmployeeID, 
		em.LastName, 
		em.FirstName, 
		em.Title, 
        SUM(i.Total) AS VenteTotal,
        DENSE_RANK () OVER(ORDER BY SUM(i.Total) DESC) AS Classement
FROM Employee em
LEFT JOIN Customer cu ON em.EmployeeID = cu.SupportRepID
LEFT JOIN Invoice i ON cu.CustomerID = i.CustomerID AND YEAR(i.Invoicedate) = 2021
WHERE Title = "Sales Support Agent" 
GROUP BY YEAR(i.Invoicedate), em.EmployeeID, em.LastName, em.FirstName
ORDER BY VenteTotal DESC;

/*19. Meilleur agent global : Quel agent de vente a réalisé le plus de ventes en tout ?*/
SELECT 
		em.EmployeeID, 
		em.LastName, 
		em.FirstName, 
		em.Title, 
        SUM(i.Total) AS VenteTotal
FROM Employee em
LEFT JOIN Customer cu ON em.EmployeeID = cu.SupportRepID
LEFT JOIN Invoice i ON cu.CustomerID = i.CustomerID
WHERE Title = "Sales Support Agent" 
GROUP BY em.EmployeeID, em.LastName, em.FirstName
ORDER BY VenteTotal DESC
LIMIT 1;
		/* Classement Dense_rank() + conservation des valeurs null LEFT JOIN*/
SELECT 
		em.EmployeeID, 
		em.LastName, 
		em.FirstName, 
		em.Title, 
        SUM(i.Total) AS VenteTotal,
        DENSE_RANK () OVER(ORDER BY SUM(i.Total) DESC) AS Classement
FROM Employee em
LEFT JOIN Customer cu ON em.EmployeeID = cu.SupportRepID
LEFT JOIN Invoice i ON cu.CustomerID = i.CustomerID
WHERE Title = "Sales Support Agent" 
GROUP BY em.EmployeeID, em.LastName, em.FirstName
ORDER BY VenteTotal DESC;

/*====================*/
/*Analyse des clients et des pays
/*====================*/

/*20. Clients par agent de vente : Fournissez une requête affichant le nombre de clients attribués à chaque agent de vente.*/
SELECT 
		em.EmployeeID, 
		em.LastName, 
		em.FirstName,
        em.Title,
        COUNT(cu.CustomerID) AS NbreClient
FROM Employee em 
LEFT JOIN Customer cu ON em.EmployeeID = cu.SupportRepID
WHERE Title = "Sales Support Agent"
GROUP BY em.EmployeeID, em.LastName, em.FirstName, em.Title;

/*21. Ventes totales par pays : Fournissez une requête affichant les ventes totales par pays.
Quel pays a dépensé le plus ? = USA */ 

SELECT cu.Country, SUM(i.Total) AS VenteTotal
FROM Customer cu
LEFT JOIN Invoice i ON cu.CustomerID = i.CustomerID
GROUP BY cu.Country
ORDER BY VenteTotal DESC;

/*====================*/
/*Analyse des morceaux et des artistes
/*====================*/
/*22. Morceau le plus acheté : Fournissez une requête affichant les morceaux le plus acheté */

SELECT il.TrackID, t.Name,SUM(il.Quantity) AS QteVendu
FROM invoiceLine il 
LEFT JOIN Track t ON il.TrackID = t.TrackID
LEFT JOIN invoice i ON il.invoiceID = i.invoiceID
GROUP BY il.TrackID, t.Name
ORDER BY QteVendu DESC;


