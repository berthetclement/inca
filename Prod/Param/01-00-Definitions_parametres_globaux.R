
#-------------------------------------------------------#
#                                                       #
#    01-00-Definitions_parametres_globaux.r             #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#



# LIBRAIRIES ----
library(rentrez)
library(XML)
library(xml2)
library(data.table)
library(dplyr)
library(tidyr)
# library(glue)
library(stringr)
library(lubridate)


# LIBRAIRIES POSTGRES----
library("odbc")
library("DBI")
library("RPostgreSQL")


##
# GLOBAL PATH ----
##

# chemin LOG ----
#chemin_log <- "Prod/Log/"
CHEMIN_LOG <- "Prod/Log/"

# chemin fonctions ----
#chemin_fonctions <- "Prod/Fonctions/"
CHEMIN_FONCTIONS <- "Prod/Fonctions/"

# pour chargement des fonctions en memoire
file_sources = list.files(pattern="*\\.R", 
                          path = CHEMIN_FONCTIONS, 
                          full.names = TRUE, 
                          recursive = TRUE)

#  chemin OUTPUT  ----
#chemin_output <- "Prod/Output/"
DIR_OUTPUT = "./Prod/Output/"


# chemin suivi
DIR_OUTPUT_SUIVI = DIR_OUTPUT


# chemin temps traitement ----
#chemin_tps_traitment <- paste0(DIR_OUTPUT, "temps_traitement/")
CHEMIN_TPS_TRAITEMENT <- paste0(DIR_OUTPUT, "temps_traitement/")
FILE_TPS_TRAITEMENT <- "temps_trt.csv"

# chemin INPUT ----
DIR_INPUT_DATA = "./Prod/Input/"
#  chemin scripts ----
#chemin_script <- "Prod/Script/"

# chemin refs comptage balises ----
CHEMIN_OUTPUT_REF_COMPTAGE <- paste0(DIR_OUTPUT, "ref_comptage/")

#-------------------------------------------------------#
#                                                       #
#                    PUBMED                             #
#                                                       #
#-------------------------------------------------------#

# PUBMED ----

NOM_BALISE_ID_PUBMED = "PMID"
NOM_PARENT_ID_PUBMED = "MedlineCitation"
DIR_OUTPUT_RDS_PUBMED = paste0(DIR_OUTPUT, "pubmed_rds/")
FILE_SUIVI_PUBMED = "suivi_pubmed.csv"
nom_ref_cpt_pubmed <- "cpt_balises_pubmed"
PATH_REF_CPT_PUBMED <- paste0(CHEMIN_OUTPUT_REF_COMPTAGE, nom_ref_cpt_pubmed, '.csv')


#  03-definition_fonction_fetchAPI ----
  # nombre de publications xml par fichier en sortie (le pas)
step_by_id = 499# 999


#-------------------------------------------------------#
#                                                       #
#                    BALISES                            #
#                                                       #
#-------------------------------------------------------#

# BALISES ----

# chemin_fonctions_balises <-  paste0(chemin_fonctions, "balises/")
# 
# # pour chargement des fonctions en memoire
# fonctions_source_balises = list.files(pattern="*\\.R", path = chemin_fonctions_balises, full.names = TRUE)

# chemin output balises RDS
chemin_output_balises <- paste0(DIR_OUTPUT, "balises_rds/")

## on definit le taux de présence pour que la balise soient significatives
tx_balise_NS <- 0.001

## on définit la liste des balises erronnées
liste_balises_erronnees <- c("b","i","sub","sup","u","math","mi","mn","mo","mrow","msub","mspace","mtext")

## regroupement des types de balises en liste

LST_SIMPLE_DATE_BDD_DATE = c("simple_date")
LST_SIMPLE_DATE_BDD_CHARACTER = c("simple_PubDate")
LST_SIMPLE_TAG = c("simple_chemin")
LST_ERRONEE = c("simple_erronnee", "multiple_erronnee")
LST_MULT = c("multiple","simple_non_significative") 
LST_SIMPLE_CALC = c("balises_error")
LST_COLS_MULT = c("Nom_balise", "Parent", "Chemin", "Profondeur", "Valeur", "Attribut")



##
# DECOUPAGE FICHIER XML
##

# Nombre d'enfants par fichier
BLOCK_SIZE <- 1000
#-------------------------------------------------------#
#                                                       #
#                    DESC                               #
#                                                       #
#-------------------------------------------------------#


  # DESC ----
  DIR_INPUT_XML_DESC = paste0(DIR_INPUT_DATA, "XML_Desc_Splitted/")
  NOM_BALISE_ID_DESC = "DescriptorUI"
  NOM_PARENT_ID_DESC = "DescriptorRecord"
  DIR_OUTPUT_RDS_DESC = paste0(DIR_OUTPUT, "desc_rds/")
  FILE_SUIVI_DESC = "suivi_desc.csv"
  FILE_INPUT_DESC = "desc2022.xml"
  #nom_ref_cpt_desc <- "cpt_balises_desc"
  NOM_REF_CPT_DESC <- "cpt_balises_desc"
  PATH_REF_CPT_DESC <- paste0(CHEMIN_OUTPUT_REF_COMPTAGE, NOM_REF_CPT_DESC, '.csv')
  
    
 


#-------------------------------------------------------#
#                                                       #
#                    SUPP                               #
#                                                       #
#-------------------------------------------------------#

  # SUPP ----
  DIR_INPUT_XML_SUPP = paste0(DIR_INPUT_DATA, "XML_Supp_Splitted/")
  NOM_BALISE_ID_SUPP = "SupplementalRecordUI"
  NOM_PARENT_ID_SUPP = "SupplementalRecord"
  DIR_OUTPUT_RDS_SUPP = paste0(DIR_OUTPUT, "supp_rds/")
  FILE_SUIVI_SUPP = "suivi_supp.csv"
  FILE_INPUT_SUPP = "supp2022.xml"
  nom_ref_cpt_supp <- "cpt_balises_Supp"
  PATH_REF_CPT_SUPP <- paste0(CHEMIN_OUTPUT_REF_COMPTAGE, nom_ref_cpt_supp, '.csv') 


#-------------------------------------------------------#
#                                                       #
#                    PA                                 #
#                                                       #
#-------------------------------------------------------#

  # PA ----
  DIR_INPUT_XML_PA = paste0(DIR_INPUT_DATA, "XML_Pa_Splitted/")
  NOM_BALISE_ID_PA = "DescriptorUI"
  NOM_PARENT_ID_PA = "DescriptorReferredTo"
  DIR_OUTPUT_RDS_PA = paste0(DIR_OUTPUT, "pa_rds/")
  FILE_SUIVI_PA = "suivi_pa.csv"
  FILE_INPUT_PA = "pa2022.xml"
  nom_ref_cpt_pa <- "cpt_balises_Pa"
  PATH_REF_CPT_PA <- paste0(CHEMIN_OUTPUT_REF_COMPTAGE, nom_ref_cpt_pa, '.csv')

#-------------------------------------------------------#
#                                                       #
#                    QUAL                               #
#                                                       #
#-------------------------------------------------------#

  # QUAL ----
  DIR_INPUT_XML_QUAL = paste0(DIR_INPUT_DATA, "XML_Qual_Splitted/")
  NOM_BALISE_ID_QUAL = "QualifierUI"
  NOM_PARENT_ID_QUAL = "QualifierRecord"
  DIR_OUTPUT_RDS_QUAL = paste0(DIR_OUTPUT, "qual_rds/")
  FILE_SUIVI_QUAL = "suivi_qual.csv"
  FILE_INPUT_QUAL = "qual2022.xml"
  nom_ref_cpt_qual <- "cpt_balises_qual"
  PATH_REF_CPT_QUAL <- paste0(CHEMIN_OUTPUT_REF_COMPTAGE, nom_ref_cpt_qual, '.csv')


#-------------------------------------------------------#
#                                                       #
#                    MESH TREES                         #
#                                                       #
#-------------------------------------------------------#


  #nom_fichier_mesh_trees <- "mtrees2022.bin"
  NOM_FICHIER_MESH_TREES <- "mtrees2022.bin" 

  # chemin output mesh trees ----
  #chemin_output_trees <- paste0(DIR_OUTPUT, "mesh_trees/")
  CHEMIN_OUPUT_TREES <- paste0(DIR_OUTPUT, "mesh_trees/")



#-------------------------------------------------------#
#                                                       #
#                    POSTGRES                           #
#                                                       #
#-------------------------------------------------------#

# POSTGRES ----

## INIT CONNEXION
# parametres de connexion
chemin_configuration <- "Prod/Config/"
config <- read.table(file = paste0(chemin_configuration,"config.txt"), sep = ";", header = TRUE, stringsAsFactors = FALSE)
drv_generic <- dbDriver("PostgreSQL")
con <- dbConnect(drv_generic, config$conn, port=config$port, user=config$user, password=config$password, dbname=config$dbname)




