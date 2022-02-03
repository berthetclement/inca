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
sapply(fonctions_source_balises, source)


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
    comptage_balise (nom_chemin = chemin_pubmed_rds,
                     id_fic =  "id_pubmed",
                     nom_output = "cpt_balises_pubmed")
  # 3.4 on separe les données et on les remonte sous PostGre
    
    ## creation du schema temp + structure de la table
    
    # parametres de connexion
    chemin_configuration <- "Prod/Config/"
    config <- read.table(file = paste0(chemin_configuration,"config.txt"), sep = ";", header = TRUE, stringsAsFactors = FALSE)
    drv_generic <- dbDriver("PostgreSQL")
    con <- dbConnect(drv_generic, config$conn, port=config$port, user=config$user, password=config$password, dbname=config$dbname)
    
    ## INIT du schema 
    # requete
    Creation_Schema_NCT_Tampon <- " CREATE SCHEMA IF NOT EXISTS \"pubmed_tmp\" 
                                  AUTHORIZATION \"INC_U_PRI_A\" ;
                                  GRANT USAGE ON SCHEMA \"pubmed_tmp\" TO \"INC_U_PRI\" ;
                                  GRANT ALL ON SCHEMA \"pubmed_tmp\" TO \"INC_U_DSI\" ;"
    
    # execution
    dbGetQuery(con, Creation_Schema_NCT_Tampon)
    
    ## crée un pgm/fonction qui test si le schema temp existe et qui crée les tables
    ## simple et mult pour DESC
    
    # lecture referentiel valide en INPUT
    ref_balises <- read.csv2(paste0(chemin_output_ref_comptage, 'cpt_balises_pubmed.csv'))
    
    ## Traitements des fichiers RDS ----
    balisage_RDS(referentiel = ref_balises, 
                 name_id = "id_pubmed",
                 repertoire_in = "Prod/Output/pubmed_rds/", 
                 repertoire_out = chemin_output_balises)



            
#-------------------------------------------------------#
#                                                       #
#              BLOC : DESC                              #
#                                                       #
#-------------------------------------------------------#


# 4 - Traitements fichiers XML DESC (referentiel) ----
# 4.1 on charge l'ensemble des fichiers mesh (par paquet définit dans les paramètres)
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'02-Traitements_fichiers_XML_MESH_heure_debut.txt'), col.names = TRUE, row.names = FALSE)
    
## ouverture de la log
journal("02-Traitements_fichiers_XML_MESH"," 02-Traitements_fichiers_XML_MESH")
    
print("Programme: 02-Traitements_fichiers_XML_MESH")
print("Heure lancement: ")
print(as.character(Sys.time()))
    
#splitter_en bloc _de 1000
traitements_xml_by_type("desc","desc2022.xml")
    
## fermeture de la log
sink()
    
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'02-Traitements_fichiers_XML_MESH_heure_fin.txt'), col.names = TRUE, row.names = FALSE)

# 4.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 4.3 on sort les informations pour identifier les balises simples ou à retravailler
comptage_balise (nom_chemin = DIR_OUTPUT_RDS_DESC, id_fic = "id_desc", nom_output = "cpt_balises_desc")


# 4.4 on sépare les données et on les remonte sous PostGre

## création du schema temp + structure de la table

## crée un pgm/fonction qui test si le schema temp existe et qui crée les tables
## simple et mult pour DESC



# lecture referentiel valide en INPUT
ref_balises_desc <- read.csv2(paste0(chemin_output_ref_comptage, 'cpt_balises_desc.csv'))
    
## Traitements des fichiers RDS ----
balisage_RDS(referentiel = ref_balises_desc, 
             name_id = "id_desc", 
             repertoire_in = DIR_OUTPUT_RDS_DESC, 
             repertoire_out = "Prod/Output/balises_rds/desc/")


    #-------------------------------------------------------#
    #                                                       #
    #              BLOC : SUPP                              #
    #                                                       #
    #-------------------------------------------------------#
    
    
# 4 - Traitements fichiers XML SUPP (referentiel) ----

    
# 4.1 on charge l'ensemble des fichiers mesh (par paquet définit dans les paramètres)
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'02-Traitements_fichiers_XML_MESH_heure_debut.txt'), col.names = TRUE, row.names = FALSE)

## ouverture de la log
journal("02-Traitements_fichiers_XML_MESH"," 02-Traitements_fichiers_XML_MESH")

print("Programme: 02-Traitements_fichiers_XML_MESH")
print("Heure lancement: ")
print(as.character(Sys.time()))
    
traitements_xml_by_type("supp", "supp2022.xml")
    
## fermeture de la log
sink()

# 4.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 4.3 on sort les informations pour identifier les balises simples ou à retravailler
comptage_balise (nom_chemin = DIR_OUTPUT_RDS_SUPP, id_fic = "id_supp", nom_output = "cpt_balises_Supp")
    
# 4.4 on sépare les données et on les remonte sous PostGre

# lecture referentiel valide en INPUT
ref_balises_Supp <- read.csv2(paste0(chemin_output_ref_comptage, 'cpt_balises_Supp.csv'))
    
## Traitements des fichiers RDS ----
balisage_RDS(referentiel = ref_balises_Supp, 
             name_id = "id_supp", 
             repertoire_in = DIR_OUTPUT_RDS_SUPP, 
             repertoire_out = "Prod/Output/balises_rds/supp/")    
    
    

    
    #-------------------------------------------------------#
    #                                                       #
    #              BLOC : PA                                #
    #                                                       #
    #-------------------------------------------------------#
    
    
# 4 - Traitements fichiers XML PA (referentiel) ----
    
    
# 4.1 on charge l'ensemble des fichiers mesh (par paquet définit dans les paramètres)
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'02-Traitements_fichiers_XML_MESH_heure_debut.txt'), col.names = TRUE, row.names = FALSE)

## ouverture de la log
journal("02-Traitements_fichiers_XML_MESH"," 02-Traitements_fichiers_XML_MESH")
    
print("Programme: 02-Traitements_fichiers_XML_MESH")
print("Heure lancement: ")
print(as.character(Sys.time()))

## la fonction de découpage ne fonctionne pas ici
    
traitements_xml_by_type("pa","pa2022.xml")
    
## fermeture de la log
sink()
# 4.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 4.3 on sort les informations pour identifier les balises simples ou à retravailler
comptage_balise (nom_chemin = DIR_OUTPUT_RDS_PA,
                 id_fic = "id_pa",                     
                 nom_output = "cpt_balises_Pa")

    
# 4.4 on sépare les données et on les remonte sous PostGre
    
# lecture referentiel valide en INPUT
ref_balises_Pa <- read.csv2(paste0(chemin_output_ref_comptage, 'cpt_balises_Pa.csv'))

## Traitements des fichiers RDS ----
balisage_RDS(referentiel = ref_balises_Pa, 
             name_id = "id_pa", 
             repertoire_in = DIR_OUTPUT_RDS_PA, 
             repertoire_out = "Prod/Output/balises_rds/Pa/")        
    

    
    #-------------------------------------------------------#
    #                                                       #
    #              BLOC : QUAL                              #
    #                                                       #
    #-------------------------------------------------------#
    
    
# 4 - Traitements fichiers XML PA (referentiel) ----
    
    
# 4.1 on charge l'ensemble des fichiers mesh (par paquet définit dans les paramètres)
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'02-Traitements_fichiers_XML_MESH_heure_debut.txt'), col.names = TRUE, row.names = FALSE)
    
## ouverture de la log
journal("02-Traitements_fichiers_XML_MESH"," 02-Traitements_fichiers_XML_MESH")
    
print("Programme: 02-Traitements_fichiers_XML_MESH")
print("Heure lancement: ")
print(as.character(Sys.time()))
  
    
traitements_xml_by_type("qual","qual2022.xml")
    
## fermeture de la log
sink()

# 4.2 on vérifie si on a bien intégrer tous les mesh
# à écrire
    
# 4.3 on sort les informations pour identifier les balises simples ou à retravailler
comptage_balise (nom_chemin = DIR_OUTPUT_RDS_QUAL, id_fic = "id_qual", nom_output = "cpt_balises_qual")
    
    
# 4.4 on sépare les données et on les remonte sous PostGre

# lecture referentiel valide en INPUT
ref_balises_Qual <- read.csv2(paste0(chemin_output_ref_comptage, 'cpt_balises_qual.csv'))



## Traitements des fichiers RDS ----
balisage_RDS(referentiel = ref_balises_Qual, 
             name_id = "id_qual", 
             repertoire_in = DIR_OUTPUT_RDS_QUAL, 
             repertoire_out = "Prod/Output/balises_rds/qual/")      
                

#-------------------------------------------------------#
#                                                       #
#              BLOC : MESH TREES                        #
#                                                       #
#-------------------------------------------------------#

# 5 - Traitements MESH TREES ----
temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'03-Traitements_MESH_TREES_heure_debut.txt'), col.names = TRUE, row.names = FALSE)  

source(paste0(chemin_script, "03-Traitements_MESH_TREES.R"))

temps <- as.data.frame(Sys.time())
write.table(temps,file=paste0(chemin_tps_traitment,'03-Traitements_MESH_TREES_heure_fin.txt'), col.names = TRUE, row.names = FALSE)





# reset output log ----
sink()