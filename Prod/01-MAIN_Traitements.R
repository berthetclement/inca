#-------------------------------------------------------#
#                                                       #
#              01-MAIN_Traitements.R                    #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#



#-------------------------------------------------------#
#                                                       #
#              BLOC : INIT                              #
#                                                       #
#-------------------------------------------------------#

# 1 - Chargement des variables globales (parametres) ----
source("Prod/Param/01-00-Definitions_parametres_globaux.R")

# 2 - Chargement des fonctions externes ----
sapply(file_sources,source)


#-------------------------------------------------------#
#                                                       #
#              BLOC : PUBMED                            #
#                                                       #
#-------------------------------------------------------#


# 3 - Traitements fichiers XML PUBMED ----

  # 3.1 on charge l'ensemble des balises
  ## chargement des 70k premiers dossiers car à partir de 77k on a systématiquement une erreur
    ## ==> on fait en 2 fois

  Lancement_PUBMED(stop_index_id = 60000, reprise = FALSE)
  Lancement_PUBMED(stop_index_id = 999999,reprise = TRUE)

   
  # 3.2 on vérifie si on a bien intégrer toutes les publications et si certaines ont "disparu"

    # 3.2.1 : les publications non intégrées
    liste_id_a_charger <- identification_id_a_charger()

    ## si > 0 : on lance le script de relance ci-dessous :
    if(length(liste_id_a_charger) >0)
      Lancement_PUBMED(stop_index_id = 999999,reprise = TRUE)
  
    # 3.2.2 : les publications qui ne sont plus présentes
      liste_plus_present <- identification_id_plus_present()

    ## si > 0 : on lance le script de nettoyage ci-dessous :
      suppression_id_plus_acharger()
  
    ## 3.2.3 : les publications en doublons
      liste_doublons <- identification_id_doublons()

    ## si > 0 : on lance le script de nettoyage ci-dessous :
      suppression_en_doublons()
      
  # 3.3 on sort les informations pour identifier les balises simples ou à retravailler
    comptage_balise (nom_chemin = DIR_OUTPUT_RDS_PUBMED,
                     id_fic =  "id_pubmed",
                     nom_output = "cpt_balises_pubmed")
  # 3.4 on separe les données et on les remonte sous PostGre
    
    balisage_RDS("pubmed_tmp", "pubmed")


            
#-------------------------------------------------------#
#                                                       #
#              BLOC : DESC                              #
#                                                       #
#-------------------------------------------------------#


# 4 - Traitements fichiers XML DESC (referentiel) ----
# 4.1 on charge l'ensemble des fichiers DESC (par paquet définit dans les paramètres)

  traitements_xml_by_type("desc",FILE_INPUT_DESC)

# 4.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 4.3 on sort les informations pour identifier les balises simples ou à retravailler
  comptage_balise (nom_chemin = DIR_OUTPUT_RDS_DESC,
                   id_fic = "id_desc",
                   nom_output = "cpt_balises_desc")


# 4.4 on sépare les données et on les remonte sous PostGre

  balisage_RDS("pubmed_tmp", "desc")

#-------------------------------------------------------#
#                                                       #
#              BLOC : SUPP                              #
#                                                       #
#-------------------------------------------------------#
    
    
# 5 - Traitements fichiers XML SUPP (referentiel) ----

    
# 5.1 on charge l'ensemble des fichiers SUPP (par paquet définit dans les paramètres)

    
  traitements_xml_by_type("supp", FILE_INPUT_SUPP)
    


# 5.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 5.3 on sort les informations pour identifier les balises simples ou à retravailler
  comptage_balise (nom_chemin = DIR_OUTPUT_RDS_SUPP,
                   id_fic = "id_supp",
                   nom_output = "cpt_balises_Supp")
    
# 5.4 on sépare les données et on les remonte sous PostGre
   
  balisage_RDS("pubmed_tmp", "supp")    
    

    
    #-------------------------------------------------------#
    #                                                       #
    #              BLOC : PA                                #
    #                                                       #
    #-------------------------------------------------------#
    
    
# 6 - Traitements fichiers XML PA (referentiel) ----
    
    
# # 6.1 on charge l'ensemble des fichiers PA (par paquet définit dans les paramètres)

  traitements_xml_by_type("pa",FILE_INPUT_PA)
    
# 6.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 6.3 on sort les informations pour identifier les balises simples ou à retravailler
  comptage_balise (nom_chemin = DIR_OUTPUT_RDS_PA,
                   id_fic = "id_pa",                     
                   nom_output = "cpt_balises_Pa")

# 6.4 on sépare les données et on les remonte sous PostGre

  balisage_RDS("pubmed_tmp", "pa")


    
    #-------------------------------------------------------#
    #                                                       #
    #              BLOC : QUAL                              #
    #                                                       #
    #-------------------------------------------------------#
    
    
# 7 - Traitements fichiers XML PA (referentiel) ----
    
    
# # 7.1 on charge l'ensemble des fichiers QUAL (par paquet définit dans les paramètres)
  
  traitements_xml_by_type("qual",FILE_INPUT_QUAL)
    

# 7.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 7.3 on sort les informations pour identifier les balises simples ou à retravailler
  comptage_balise (nom_chemin = DIR_OUTPUT_RDS_QUAL,
                   id_fic = "id_qual",
                   nom_output = "cpt_balises_qual")
    
    
# 7.4 on sépare les données et on les remonte sous PostGre

  balisage_RDS("pubmed_tmp", "qual")
     
#-------------------------------------------------------#
#                                                       #
#              BLOC : MESH TREES                        #
#                                                       #
#-------------------------------------------------------#

# 8 - chargement des donnees tree

  Lancement_tree()

  #-------------------------------------------------------#
  #                                                       #
  #              BLOC : GESTION DES SCHEMAS               #
  #                                                       #
  #-------------------------------------------------------#
  
  # 9 - gestion des schemas
  
  gestion_schema()
  