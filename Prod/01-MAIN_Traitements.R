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
    
    ## creation du schema temp + structure de la table
    
    ## 1 - INIT du schema 
    #pstgr_init_schema("pubmed_tmp")
    
    ## 2 - Creation tables vides 
      # simple / multiple a partir du referentiel 
    #pstgr_write_table_pubmed_vide(ref_comptage = PATH_REF_CPT_PUBMED, nom_schema = "pubmed_tmp", nom_table = "pubmed")
    
    ## crée un pgm/fonction qui test si le schema temp existe et qui crée les tables
    
    
    ## Traitements des fichiers RDS ----
    #balisage_RDS(referentiel = PATH_REF_CPT_PUBMED, 
     #            name_id = "id_pubmed",
      ##           repertoire_in = DIR_OUTPUT_RDS_PUBMED, # [TEST] "save_RDS/"
        #         repertoire_out = chemin_output_balises, # parametre deprecie
         #        nom_schema = "pubmed_tmp", 
          #       nom_table = "pubmed") 
    balisage_RDS_candidate("pubmed_tmp", "pubmed")


            
#-------------------------------------------------------#
#                                                       #
#              BLOC : DESC                              #
#                                                       #
#-------------------------------------------------------#


# 4 - Traitements fichiers XML DESC (referentiel) ----
# 4.1 on charge l'ensemble des fichiers DESC (par paquet définit dans les paramètres)

#splitter_en bloc _de 1000
traitements_xml_by_type("desc",FILE_INPUT_DESC)

# 4.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 4.3 on sort les informations pour identifier les balises simples ou à retravailler
comptage_balise (nom_chemin = DIR_OUTPUT_RDS_DESC,
                 id_fic = "id_desc",
                 nom_output = "cpt_balises_desc")


# 4.4 on sépare les données et on les remonte sous PostGre

## 1 - INIT du schema 
#pstgr_init_schema("pubmed_tmp")

## 2 - Creation tables vides 
  # simple / multiple a partir du referentiel 
#pstgr_write_table_ref_vide(nom_schema = "pubmed_tmp", nom_table = "desc")

## Traitements des fichiers RDS ----
#balisage_RDS(referentiel = PATH_REF_CPT_DESC, 
#             name_id = "id_desc", 
#             repertoire_in = DIR_OUTPUT_RDS_DESC, 
#             repertoire_out = "Prod/Output/balises_rds/desc/",
#             nom_schema = "pubmed_tmp", 
#             nom_table = "desc")
balisage_RDS_candidate("pubmed_tmp", "desc")

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

## 1 - INIT du schema 
#pstgr_init_schema("pubmed_tmp")

## 2 - Creation tables vides 
# simple / multiple a partir du referentiel 
#pstgr_write_table_ref_vide(nom_schema = "pubmed_tmp", nom_table = "supp")

    
## Traitements des fichiers RDS ----
#balisage_RDS(referentiel = PATH_REF_CPT_SUPP, 
#             name_id = "id_supp", 
#             repertoire_in = DIR_OUTPUT_RDS_SUPP, 
#             repertoire_out = "Prod/Output/balises_rds/supp/",
#             nom_schema = "pubmed_tmp", 
#             nom_table = "supp")    
balisage_RDS_candidate("pubmed_tmp", "supp")    
    

    
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

## 1 - INIT du schema 
#pstgr_init_schema("pubmed_tmp")

## 2 - Creation tables vides 
# simple / multiple a partir du referentiel 
#pstgr_write_table_ref_vide(nom_schema = "pubmed_tmp",
#                          nom_table = "pa")


## Traitements des fichiers RDS ----
#balisage_RDS(referentiel = PATH_REF_CPT_PA, 
#             name_id = "id_pa", 
#             repertoire_in = DIR_OUTPUT_RDS_PA, 
#             repertoire_out = "Prod/Output/balises_rds/Pa/",
#             nom_schema = "pubmed_tmp", 
#             nom_table = "pa")    
balisage_RDS_candidate("pubmed_tmp", "pa")


    
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

## 1 - INIT du schema 
#pstgr_init_schema("pubmed_tmp")

## 2 - Creation tables vides 
# simple / multiple a partir du referentiel 
#pstgr_write_table_ref_vide(nom_schema = "pubmed_tmp",
#                            nom_table = "qual")


## Traitements des fichiers RDS ----
#balisage_RDS(referentiel = PATH_REF_CPT_QUAL, 
 #            name_id = "id_qual", 
  #           repertoire_in = DIR_OUTPUT_RDS_QUAL, 
  #           repertoire_out = "Prod/Output/balises_rds/qual/",
  #           nom_schema = "pubmed_tmp", 
  #           nom_table = "qual")  
balisage_RDS_candidate("pubmed_tmp", "qual")
     
#-------------------------------------------------------#
#                                                       #
#              BLOC : MESH TREES                        #
#                                                       #
#-------------------------------------------------------#

# 8 - Traitements MESH TREES ----
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'08-Traitements_MESH_TREES_heure_debut.txt'), col.names = TRUE, row.names = FALSE)  

source(paste0(chemin_script, "03-Traitements_MESH_TREES.R"))

## test SLE
RPostgreSQL::dbWriteTable(con, 
                          name=c("pubmed_tmp", "tree"), 
                          value = fic_mesh_tree, 
                          append = TRUE, 
                          row.names=FALSE)

temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'08-Traitements_MESH_TREES_heure_fin.txt'), col.names = TRUE, row.names = FALSE)





# reset output log ----
sink()