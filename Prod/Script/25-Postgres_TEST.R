#-------------------------------------------------------#
#                                                       #
#              25-Postgres_TEST.R                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


# generer tables simples / multples
balisage_RDS(referentiel = read.csv2("Prod/Output/ref_comptage/cpt_balises_pubmed.csv"), 
             name_id = "id_pubmed", 
             repertoire_in = "save_RDS/", 
             repertoire_out = "Prod/Output/balises_rds/")   



#### 00 Definition des paramètres ----

chemin_configuration <- "Prod/Config/"
config <- read.table(file = paste0(chemin_configuration,"config.txt"), sep = ";", header = TRUE, stringsAsFactors = FALSE)
drv_generic <- dbDriver("PostgreSQL")
con <- dbConnect(drv_generic, config$conn, port=config$port, user=config$user, password=config$password, dbname=config$dbname)



## 1 - INIT TABLES ----
# requete
Creation_Schema_NCT_Tampon <- " CREATE SCHEMA IF NOT EXISTS \"pubmed_tmp\" 
                                  AUTHORIZATION \"INC_U_PRI_A\" ;
                                  GRANT USAGE ON SCHEMA \"pubmed_tmp\" TO \"INC_U_PRI\" ;
                                  GRANT ALL ON SCHEMA \"pubmed_tmp\" TO \"INC_U_DSI\" ;"

# execution
dbGetQuery(con, Creation_Schema_NCT_Tampon)


##########################################################################
# La creation des tables vides implique de creer avec le nb max de champs#
##########################################################################


# Création sur le serveur des deux tables à alimenter, vides (nécessaires pour que l'alimentation dbWriteTable qui va suivre se fasse avec append=TRUE et puisse donc reprendre, par exemple, à n=414e groupe )

## TABLES SIMPLES ----
  
# prendre un RDS comme modele
tab_simples_model <- readRDS("Prod/Output/balises_rds/lot_1_simple.RDS")

  # a tester PB : 2 PMID dans des publications 
  # ID A TESTER : 34935127, 34934978, 34932836, 34932828

# creation d'une table vide
tableau_NCT_vide <- tab_simples_model %>% 
  slice(0)

names(tableau_NCT_vide) <- tolower(names(tableau_NCT_vide))

tableau_NCT_vide$articledate <- as.Date(tableau_NCT_vide$articledate)

# for(i in seq(1, ncol(tableau_NCT_vide))) {
#   tableau_NCT_vide[,i] <- as.character(tableau_NCT_vide[,i])
# }

# creation de requetes
requete_des_droits <- 'GRANT SELECT ON TABLE "pubmed_tmp"."pubmed" TO "INC_U_PRI";'
requete_creation_index <- "CREATE INDEX IF NOT EXISTS \"cle_id_pubmed\" ON \"pubmed_tmp\".\"pubmed\" (\"id_pubmed\") ;"
requete_cle_primaire <- "ALTER TABLE \"pubmed_tmp\".\"pubmed\" ADD CONSTRAINT pk_id_pubmed PRIMARY KEY (\"id_pubmed\");   "

# Execution des requetes
dbWriteTable(con, name=c("pubmed_tmp","pubmed"), value = tableau_NCT_vide, overwrite = TRUE, row.names=FALSE)

dbGetQuery(con, requete_des_droits)
dbGetQuery(con, requete_creation_index)
dbGetQuery(con,requete_cle_primaire)



## TABLES MULTIPLES ----

# table modele
tab_multiples_model <- readRDS("Prod/Output/balises_rds/lot_1_multiple.RDS")

tableau_NCT_Mult_vide <- tab_multiples_model %>% 
  slice(0)

names(tableau_NCT_Mult_vide) <- tolower(names(tableau_NCT_Mult_vide))

# Ecriture requetes
requete_des_droits <- 'GRANT SELECT ON TABLE "pubmed_tmp"."pubmed_mult" TO "INC_U_PRI";'
requete_creation_index <- "CREATE INDEX IF NOT EXISTS \"cle_id_pubmed_mult\" ON \"pubmed_tmp\".\"pubmed_mult\" (\"id_pubmed\",\"chemin\") ;"
requete_creation_index_bis <- "CREATE INDEX IF NOT EXISTS \"cle_id_pubmed_mult_id\" ON \"pubmed_tmp\".\"pubmed_mult\" (\"id_pubmed\") ;"
requete_cle_primaire <- "ALTER TABLE \"pubmed_tmp\".\"pubmed_mult\" ADD CONSTRAINT pk_pubmed_mult PRIMARY KEY (\"id_pubmed\",\"chemin\");"

# Execution requetes
dbWriteTable(con, name=c("pubmed_tmp","pubmed_mult"), overwrite=TRUE, value = tableau_NCT_Mult_vide,row.names=FALSE)

dbGetQuery(con, requete_des_droits)
dbGetQuery(con, requete_creation_index)
dbGetQuery(con, requete_creation_index_bis)
dbGetQuery(con,requete_cle_primaire)



#-------------------------------#
#          CHARGEMENT           #
#-------------------------------#

# Chargement tables simples ----
table_simple <- readRDS("Prod/Output/balises_rds/lot_1_simple.RDS")

names(table_simple) <- tolower(names(table_simple))

RPostgreSQL::dbWriteTable(con, name=c("pubmed_tmp","pubmed"), value = table_simple, append = TRUE, row.names=FALSE)

requete_des_droits <- 'GRANT SELECT ON TABLE "pubmed_tmp"."pubmed" TO "INC_U_PRI";'
dbGetQuery(con, requete_des_droits)



# Chargement tables multiples ----
table_mult <- readRDS("Prod/Output/balises_rds/lot_1_multiple.RDS")
names(table_mult) <- tolower(names(table_mult))

RPostgreSQL::dbWriteTable(con, name=c("pubmed_tmp","pubmed_mult"), value=table_mult, append=TRUE, row.names=FALSE)

requete_des_droits <- 'GRANT SELECT ON TABLE "pubmed_tmp"."pubmed_mult" TO "INC_U_PRI";'
dbGetQuery(con, requete_des_droits)
