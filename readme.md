readme
================
clement
06/01/2022

## Introduction

Ce document a pour but de présentater le projet et le code en mode
macro. Egalement il présentera un résumé des dernieres actions
accomplies et des actions restantes.

## Concaténation des codes

Les derniers changements au niveau du code :

  - Les MAJ de codes sont tagees avec `[ajout]`  
  - Une modif dans le **main** (juste pour executer le script plus
    facilement)  
  - Modif des parametres partie PUBMED pour lancement \[test\]

Modifications FONCTIONS :

  - Fonction “comptage\_balise” : ligne 46, \# \[ajout\] “NA” au lieu de
    NA
      - Ne renvoyait pas d’erreur avec NA mais le code ne s’excutait pas
        (comme un `break` pour sortir d’une fonction)  
  - Fonction “traitements\_xml\_fic” : ligne 124, remplacement de “id”
    par \!\!var\_id (gestion dynamique du nom de l’id)  
  - Fonction “Lancement\_PUBMED” : ligne 79 pour lecture du fichier de
    suivi id\_pubmed

## Ajout partie “BALISES”

  - Ajout d’un repertoire “Prod/Fonctions/balises”  
  - Ajout du bloc “Traitements\_BALISES”  
  - Ajout des parametres pour la partie balises

## Les points restants

  - La gestion des balises erronnes  
  - Gestion de la date pubDate  
  - Reprendre la fonction balisage pour sortie avoir une liste de data
    frame (simple+multiple)  
  - Ajouter un test (si referentiel existe a l’etape initiale)  
  - Vider le repertoire des RDS si option reprise = FALSE  
  - Ecrire script d’installation de package + version a lancement du
    programme

## Faits marquants

Certaines publications peuvent causer des lenteurs dans le traitement :

  - L’id pubmed 34800427 est long à tratier (+ de 10 min en local)  
  - Dans le code du Lot 1 des balises “children” sont générées et pour
    ce document cela provoque une boucle de \~ 18000 itérations la ou
    l’on trouve normalement \~30 à \~150 itérations.

Lien INCA :

  - <https://portaild.e-cancer.fr/wabam/institut?domain=INCA>
