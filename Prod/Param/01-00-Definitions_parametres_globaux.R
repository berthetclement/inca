
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
  CHEMIN_LOG <- "Prod/Log/"

# chemin fonctions ----
  CHEMIN_FONCTIONS <- "Prod/Fonctions/"

# pour chargement des fonctions en memoire
  FILE_SOURCES = list.files(pattern="*\\.R", 
                            path = CHEMIN_FONCTIONS, 
                            full.names = TRUE, 
                            recursive = TRUE)

#  chemin OUTPUT  ----
  DIR_OUTPUT = "./Prod/Output/"


# chemin suivi
  DIR_OUTPUT_SUIVI = DIR_OUTPUT


# chemin temps traitement ----
  CHEMIN_TPS_TRAITEMENT <- paste0(DIR_OUTPUT, "temps_traitement/")
  FILE_TPS_TRAITEMENT <- "temps_trt.csv"

# chemin INPUT ----
  DIR_INPUT_DATA = "./Prod/Input/"



##
# DECOUPAGE FICHIER XML
##

# Nombre d'enfants par fichier
  BLOCK_SIZE <- 1000

#-------------------------------------------------------#
#                                                       #
#                    POSTGRES                           #
#                                                       #
#-------------------------------------------------------#

# POSTGRES ----

## INIT CONNEXION
# parametres de connexion
#chemin_configuration <- "Prod/Config/"
  CHEMIN_CONFIGURATION <- "Prod/Config/"
  config <- read.table(file = paste0(CHEMIN_CONFIGURATION,"config.txt"), sep = ";", header = TRUE, stringsAsFactors = FALSE)
  drv_generic <- dbDriver("PostgreSQL")
  con <- dbConnect(drv_generic, config$conn, port=config$port, user=config$user, password=config$password, dbname=config$dbname)


#-------------------------------------------------------#
#                                                       #
#                    BALISES                            #
#                                                       #
#-------------------------------------------------------#

# BALISES ----

## on definit le taux de présence pour que la balise soient significatives
  TX_BALISE_NS <- 0.001

## on définit la liste des balises erronnées
  LISTE_BALISE_ERRONNEES <- c("b","i","sub","sup","u","math","mi","mn","mo","mrow","msub","mspace","mtext")

# chemin refs comptage balises ----
  CHEMIN_OUTPUT_REF_COMPTAGE <- paste0(DIR_OUTPUT, "ref_comptage/")

## regroupement des types de balises en liste

  LST_SIMPLE_DATE_BDD_DATE = c("simple_date")
  LST_SIMPLE_DATE_BDD_CHARACTER = c("simple_PubDate")
  LST_SIMPLE_TAG = c("simple_chemin")
  LST_ERRONEE = c("simple_erronnee", "multiple_erronnee")
  LST_MULT = c("multiple","simple_non_significative") 
  LST_SIMPLE_CALC = c("balises_error")
  LST_COLS_MULT = c("Nom_balise", "Parent", "Chemin", "Profondeur", "Valeur", "Attribut")


#-------------------------------------------------------#
#                                                       #
#                    PUBMED                             #
#                                                       #
#-------------------------------------------------------#

# PUBMED ----

  # requete de recherche des NCT avec publication
  REQUETE_NCT_PUBLI <- "(ClinicalTrials.gov[Secondary Source ID])"
  
  # nombre de publications xml ramenees a chaque lot
  STEP_BY_ID = 499
  
  NOM_BALISE_ID_PUBMED = "PMID"
  NOM_PARENT_ID_PUBMED = "MedlineCitation"
  DIR_OUTPUT_RDS_PUBMED = paste0(DIR_OUTPUT, "pubmed_rds/")
  FILE_SUIVI_PUBMED = "suivi_pubmed.csv"
  NOM_REF_CPT_PUBMED <- "cpt_balises_pubmed"
  PATH_REF_CPT_PUBMED <- paste0(CHEMIN_OUTPUT_REF_COMPTAGE, NOM_REF_CPT_PUBMED, '.csv')
  LST_TEST_PUBMED <- c("fetch_id")  

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
  NOM_REF_CPT_DESC <- "cpt_balises_desc"
  PATH_REF_CPT_DESC <- paste0(CHEMIN_OUTPUT_REF_COMPTAGE, NOM_REF_CPT_DESC, '.csv')
  LST_TEST_DESC <- c("Test_Nbrows")  
    
 


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
  NOM_REF_CPT_SUPP <- "cpt_balises_Supp"
  PATH_REF_CPT_SUPP <- paste0(CHEMIN_OUTPUT_REF_COMPTAGE, NOM_REF_CPT_SUPP, '.csv')
  LST_TEST_SUPP <- c("Test_Min_depth")


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
  NOM_REF_CPT_PA <- "cpt_balises_Pa"
  PATH_REF_CPT_PA <- paste0(CHEMIN_OUTPUT_REF_COMPTAGE, NOM_REF_CPT_PA, '.csv')
  LST_TEST_PA <- c("Test_Nbrows")  

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
  NOM_REF_CPT_QUAL <- "cpt_balises_qual"
  PATH_REF_CPT_QUAL <- paste0(CHEMIN_OUTPUT_REF_COMPTAGE, NOM_REF_CPT_QUAL, '.csv')
  LST_TEST_QUAL <- c("Test_Nbrows")  

#-------------------------------------------------------#
#                                                       #
#                    MESH TREES                         #
#                                                       #
#-------------------------------------------------------#

  NOM_FICHIER_MESH_TREES <- "mtrees2022.bin" 
  CHEMIN_OUPUT_TREES <- paste0(DIR_OUTPUT, "mesh_trees/")



