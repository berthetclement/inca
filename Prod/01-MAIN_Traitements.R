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

# sapply(fonctions_source_balises, source)


#-------------------------------------------------------#
#                                                       #
#              BLOC : PUBMED                            #
#                                                       #
#-------------------------------------------------------#


# 3 - Traitements fichiers XML PUBMED ----
  # debut timer du programme

  # 3.1 on charge l'ensemble des balises
  ## chargement des 70k premiers dossiers car à partir de 77k on a systématiquement une erreur
    ## ==> on fait en 2 fois
  temps <- as.data.frame(Sys.time())
  write.table(temps,file=paste0(chemin_tps_traitment,'01-Chargement_fichiers_XML_PUBMED_heure_debut.txt'), col.names = TRUE, row.names = FALSE)  

  Lancement_PUBMED(stop_index_id = 60000, reprise = FALSE)
  Lancement_PUBMED(stop_index_id = 999999,reprise = TRUE)

  
  # fin timer du programme
  temps <- as.data.frame(Sys.time())
  write.table(temps,file=paste0(chemin_tps_traitment,'01-Chargement_fichiers_XML_PUBMED_heure_fin.txt'), col.names = TRUE, row.names = FALSE) 
  
  # 3.2 on vérifie si on a bien intégrer toutes les publications et si certaines ont "disparu"

    # 3.2.1 : les publications non intégrées
    liste_id_a_charger <- identification_id_a_charger()
    print("Nombre de publications restant à intégrer :")
    print(length(liste_id_a_charger))
    ## si > 0 : on lance le script de relance ci-dessous :
    
    # [ajout] le test et condition si lancement
    if(length(liste_id_a_charger) >0)
      Lancement_PUBMED(stop_index_id = 999999,reprise = TRUE)
  
    # 3.2.2 : les publications qui ne sont plus présentes
    liste_plus_present <- identification_id_plus_present()
    print("Nombre de publications qui ne sont plus présentes :")
    print(length(liste_plus_present))
    ## si > 0 : on lance le script de nettoyage ci-dessous :
    suppression_id_plus_acharger()
  
    ## 3.2.3 : les publications en doublons
    liste_doublons <- identification_id_doublons()
    print("Nombre de publications chargées plusieurs fois:")
    print(nrow(liste_doublons))
    ## si > 0 : on lance le script de nettoyage ci-dessous :
    suppression_en_doublons()
  # 3.3 on sort les informations pour identifier les balises simples ou à retravailler
    comptage_balise (nom_chemin = DIR_OUTPUT_RDS_PUBMED,
                     id_fic =  "id_pubmed",
                     nom_output = "cpt_balises_pubmed")
  # 3.4 on separe les données et on les remonte sous PostGre
    
    ## creation du schema temp + structure de la table
    
    ## 1 - INIT du schema 
    pstgr_init_schema("pubmed_tmp")
    
    ## 2 - Creation tables vides 
      # simple / multiple a partir du referentiel 
    pstgr_write_table_pubmed_vide(ref_comptage = path_ref_cpt_pubmed, nom_schema = "pubmed_tmp", nom_table = "pubmed")
    
    ## crée un pgm/fonction qui test si le schema temp existe et qui crée les tables
    
    
    ## Traitements des fichiers RDS ----
    balisage_RDS(referentiel = path_ref_cpt_pubmed, 
                 name_id = "id_pubmed",
                 repertoire_in = DIR_OUTPUT_RDS_PUBMED, # [TEST] "save_RDS/"
                 repertoire_out = chemin_output_balises, # parametre deprecie
                 nom_schema = "pubmed_tmp", 
                 nom_table = "pubmed") 



            
#-------------------------------------------------------#
#                                                       #
#              BLOC : DESC                              #
#                                                       #
#-------------------------------------------------------#


# 4 - Traitements fichiers XML DESC (referentiel) ----
# 4.1 on charge l'ensemble des fichiers mesh (par paquet définit dans les paramètres)
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'02-Traitements_fichiers_XML_DESC_heure_debut.txt'), col.names = TRUE, row.names = FALSE)
    
## ouverture de la log
journal("02-Traitements_fichiers_XML_DESC"," 02-Traitements_fichiers_XML_DESC")
    
print("Programme: 02-Traitements_fichiers_XML_DESC")
print("Heure lancement: ")
print(as.character(Sys.time()))
    
#splitter_en bloc _de 1000
traitements_xml_by_type("desc",FILE_INPUT_DESC)
    
## fermeture de la log
sink()
    
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'02-Traitements_fichiers_XML_DESC_heure_fin.txt'), col.names = TRUE, row.names = FALSE)

# 4.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 4.3 on sort les informations pour identifier les balises simples ou à retravailler
comptage_balise (nom_chemin = DIR_OUTPUT_RDS_DESC,
                 id_fic = "id_desc",
                 nom_output = "cpt_balises_desc")


# 4.4 on sépare les données et on les remonte sous PostGre

## 1 - INIT du schema 
pstgr_init_schema("pubmed_tmp")

## 2 - Creation tables vides 
  # simple / multiple a partir du referentiel 
pstgr_write_table_desc_vide(ref_comptage = path_ref_cpt_desc, nom_schema = "pubmed_tmp", nom_table = "desc")

## Traitements des fichiers RDS ----
balisage_RDS(referentiel = path_ref_cpt_desc, 
             name_id = "id_desc", 
             repertoire_in = DIR_OUTPUT_RDS_DESC, 
             repertoire_out = "Prod/Output/balises_rds/desc/",
             nom_schema = "pubmed_tmp", 
             nom_table = "desc")


    #-------------------------------------------------------#
    #                                                       #
    #              BLOC : SUPP                              #
    #                                                       #
    #-------------------------------------------------------#
    
    
# 5 - Traitements fichiers XML SUPP (referentiel) ----

    
# 5.1 on charge l'ensemble des fichiers mesh (par paquet définit dans les paramètres)
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'05-Traitements_fichiers_XML_SUPP_heure_debut.txt'), col.names = TRUE, row.names = FALSE)

## ouverture de la log
journal("05-Traitements_fichiers_XML_SUPP"," 05-Traitements_fichiers_XML_SUPP")

print("Programme: 05-Traitements_fichiers_XML_SUPP")
print("Heure lancement: ")
print(as.character(Sys.time()))
    
traitements_xml_by_type("supp", FILE_INPUT_SUPP)
    
## fermeture de la log
sink()

# 5.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 5.3 on sort les informations pour identifier les balises simples ou à retravailler
comptage_balise (nom_chemin = DIR_OUTPUT_RDS_SUPP, id_fic = "id_supp", nom_output = "cpt_balises_Supp")
    
# 5.4 on sépare les données et on les remonte sous PostGre

## 1 - INIT du schema 
pstgr_init_schema("pubmed_tmp")

## 2 - Creation tables vides 
# simple / multiple a partir du referentiel 
pstgr_write_table_supp_vide(ref_comptage = path_ref_cpt_supp, nom_schema = "pubmed_tmp", nom_table = "supp")

    
## Traitements des fichiers RDS ----
balisage_RDS(referentiel = path_ref_cpt_supp, 
             name_id = "id_supp", 
             repertoire_in = DIR_OUTPUT_RDS_SUPP, 
             repertoire_out = "Prod/Output/balises_rds/supp/",
             nom_schema = "pubmed_tmp", 
             nom_table = "supp")    
    
    

    
    #-------------------------------------------------------#
    #                                                       #
    #              BLOC : PA                                #
    #                                                       #
    #-------------------------------------------------------#
    
    
# 6 - Traitements fichiers XML PA (referentiel) ----
    
    
# 6.1 on charge l'ensemble des fichiers PA (par paquet définit dans les paramètres)
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'06-Traitements_fichiers_XML_PA_heure_debut.txt'), col.names = TRUE, row.names = FALSE)

## ouverture de la log
journal("06-Traitements_fichiers_XML_PA"," 06-Traitements_fichiers_XML_PA")
    
print("Programme: 06-Traitements_fichiers_XML_PA")
print("Heure lancement: ")
print(as.character(Sys.time()))


traitements_xml_by_type("pa",FILE_INPUT_PA)
    
## fermeture de la log
sink()
# 6.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 6.3 on sort les informations pour identifier les balises simples ou à retravailler
comptage_balise (nom_chemin = DIR_OUTPUT_RDS_PA,
                 id_fic = "id_pa",                     
                 nom_output = "cpt_balises_Pa")

    
# 6.4 on sépare les données et on les remonte sous PostGre

## 1 - INIT du schema 
pstgr_init_schema("pubmed_tmp")

## 2 - Creation tables vides 
# simple / multiple a partir du referentiel 
pstgr_write_table_pa_vide(ref_comptage = path_ref_cpt_pa, nom_schema = "pubmed_tmp", nom_table = "pa")


## Traitements des fichiers RDS ----
balisage_RDS(referentiel = path_ref_cpt_pa, 
             name_id = "id_pa", 
             repertoire_in = DIR_OUTPUT_RDS_PA, 
             repertoire_out = "Prod/Output/balises_rds/Pa/",
             nom_schema = "pubmed_tmp", 
             nom_table = "pa")    



    
    #-------------------------------------------------------#
    #                                                       #
    #              BLOC : QUAL                              #
    #                                                       #
    #-------------------------------------------------------#
    
    
# 7 - Traitements fichiers XML PA (referentiel) ----
    
    
# 7.1 on charge l'ensemble des fichiers QUAL (par paquet définit dans les paramètres)
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'07-Traitements_fichiers_XML_QUAL_heure_debut.txt'), col.names = TRUE, row.names = FALSE)
    
## ouverture de la log
journal("07-Traitements_fichiers_XML_QUAL"," 07-Traitements_fichiers_XML_QUAL")
    
print("Programme: 07-Traitements_fichiers_XML_MESH")
print("Heure lancement: ")
print(as.character(Sys.time()))
  
    
traitements_xml_by_type("qual",FILE_INPUT_QUAL)
    
## fermeture de la log
sink()

# 7.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 7.3 on sort les informations pour identifier les balises simples ou à retravailler
comptage_balise (nom_chemin = DIR_OUTPUT_RDS_QUAL, id_fic = "id_qual", nom_output = "cpt_balises_qual")
    
    
# 7.4 on sépare les données et on les remonte sous PostGre

## 1 - INIT du schema 
pstgr_init_schema("pubmed_tmp")

## 2 - Creation tables vides 
# simple / multiple a partir du referentiel 
pstgr_write_table_qual_vide(ref_comptage = path_ref_cpt_qual, nom_schema = "pubmed_tmp", nom_table = "qual")


## Traitements des fichiers RDS ----
balisage_RDS(referentiel = path_ref_cpt_qual, 
             name_id = "id_qual", 
             repertoire_in = DIR_OUTPUT_RDS_QUAL, 
             repertoire_out = "Prod/Output/balises_rds/qual/",
             nom_schema = "pubmed_tmp", 
             nom_table = "qual")  

     
#-------------------------------------------------------#
#                                                       #
#              BLOC : MESH TREES                        #
#                                                       #
#-------------------------------------------------------#

# 8 - Traitements MESH TREES ----
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'08-Traitements_MESH_TREES_heure_debut.txt'), col.names = TRUE, row.names = FALSE)  

source(paste0(chemin_script, "03-Traitements_MESH_TREES.R"))

temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'08-Traitements_MESH_TREES_heure_fin.txt'), col.names = TRUE, row.names = FALSE)





# reset output log ----
sink()