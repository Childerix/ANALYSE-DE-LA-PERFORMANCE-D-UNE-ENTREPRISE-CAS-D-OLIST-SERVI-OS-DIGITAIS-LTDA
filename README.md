### **_Présentation du Projet_**

Ce projet consiste en une analyse complète de la performance de la plateforme e-commerce Olist, marketplace brésilienne spécialisée dans la vente de produits en ligne. L'objectif est d'évaluer la performance globale de l'entreprise à travers 4 dimensions clés : Commercial, Satisfaction Client, Logistique et Marketing.

**_Structure du Notebook_**

1. Chargement et Exploration des Données
   Importation des 11 datasets Olist :
   Données clients, vendeurs, produits
   Commandes, paiements, avis
   Géolocalisation, marketing, leads
   Exploration réalisée :
   Affichage des premières lignes (.head())
   Informations générales (.info())
   Statistiques descriptives (.describe())
   Identification des valeurs manquantes

2. Nettoyage des Données avec SQL
   Utilisation de SQL en amont pour :
   Suppression des doublons
   Traitement des valeurs NULL
   Standardisation des formats de date
   Correction des types de données
   Création de vues pour les analyses

3. Analyse des KPI par Dimension
   Dimension Commerciale (40%)
   Indicateur Résultat
   Chiffre d'affaires total 15 739 137 €
   Meilleur mois Mai (1 728 675 €)
   Meilleur jour 24 (595 655 €)
   Meilleur trimestre T2 (4 811 289 €)
   Nombre de commandes 113 514
   Panier moyen 153 €
   Dimension Satisfaction Client (30%)
   Indicateur Résultat
   Clients uniques 96 096
   Taux de fidélisation 7,5%
   Taux de churn 90,39%
   Note moyenne 4,09/5
   Avis positifs 77,07%
   Avis négatifs 14,68%
   Dimension Logistique (20%)
   Indicateur Résultat
   Catégorie la plus vendue cama_mesa_banho (12 718)
   Frais d'expédition moyen 19,99 €
   Délai max de livraison 61 jours
   Commandes annulées 664
   Commandes indisponibles 649
   Dimension Marketing (10%)
   Indicateur Résultat
   Leads générés 5 589
   Taux de qualification 99,25%
   Taux de conversion 36,79%
   CA généré par leads 375 047 € (2,38% du CA total) 4. Analyse des Vendeurs
   117 601 vendeurs actifs

   Meilleur vendeur : 507 167 € de CA (1452 ventes)

   Nombre moyen de ventes : 38 ventes par vendeur

4. Prédiction du Churn avec Régression Logistique

Variables utilisées :
Mois de vente
Année de vente
Trimestre

Résultats :
Variables les plus influentes : Annee_Vente et Trimestre
Précision du modèle : 90.49%
Interprétation : plus la vente est récente, plus le churn est élevé

Synthèse des Résultats
Performance globale : 69,69% (performance moyenne)

    Dimension	Score	Appréciation
    Commercial	37,34/40	Très bonne
    Satisfaction Client	20,30/30	Moyenne
    Logistique	6,52/20	Critique
    Marketing	5,54/10	À améliorer
    Points d'Amélioration Identifiés

Logistique (priorité absolue)

    Réduire les délais de livraison
    Ouvrir des centres de distribution
    Optimiser les frais d'expédition

Satisfaction Client

    Mettre en place un programme de fidélisation
    Lancer des campagnes de réactivation
    Améliorer la gestion des avis négatifs

Marketing

    Cibler les segments rentables (health_beauty, watches)
    Optimiser les sources en ligne
    Améliorer le taux de conversion

Gestion des stocks

    Utiliser le dropshipping
    Mettre en place des alertes de stock minimum

Visualisations Produites

    Évolution du chiffre d'affaires mensuel
    Distribution des notes d'avis
    Panier moyen par trimestre
    Top 10 des catégories de produits
    CA par catégorie de produits
    Radar de performance globale
    Tunnel de conversion des leads
    Matrice de corrélation
    Distribution du churn par année/trimestre/mois
    Courbe ROC et matrice de confusion

Outils et Technologies Utilisés
Python 3.12 : Langage de programmation
Pandas : Manipulation et analyse de données
Matplotlib / Seaborn : Visualisation de données
Scikit-learn : Modélisation (Régression Logistique)
SQL : Nettoyage et prétraitement des données
Jupyter Notebook : Environnement interactif

Limites de l'Analyse

Limite Explication

    Données manquantes	>98% pour certaines colonnes
    Période limitée	Données jusqu'à 2018 seulement
    Analyse quantitative	Pas d'analyse NLP des avis
    Modélisation basique	Pas de modèles avancés (Random Forest, XGBoost)

Pistes d'Amélioration Futures
Développer un modèle de prédiction du churn avec plus de variables
Réaliser une analyse NLP des commentaires clients
Mettre en place un tableau de bord temps réel
Effectuer une analyse RFM pour la segmentation client
Optimiser la localisation des centres de distribution

Conclusion

Olist est une entreprise avec un fort potentiel commercial mais des faiblesses logistiques critiques. La priorité absolue est l'amélioration de la chaîne logistique pour réduire les délais de livraison et les annulations de commandes. Cela permettra d'augmenter la satisfaction client, de réduire le taux de churn et de valoriser les efforts marketing.

