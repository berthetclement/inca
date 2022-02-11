#-------------------------------------------------------#
#                                                       #
#     pstgr_write_table_ref_vide.R                      #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

## Description parameters : 
# ref_comptage : chemin complet du referentiel de comptage (ex: "file.csv") 
# nom_schema : nom du schema en caracteres
# nom_table : nom de la table en caracteres

pstgr_write_table_ref_vide <- function(nom_schema, nom_table){
  # lecture referentiel valide en INPUT
  file_comptage = get(paste("PATH_REF_CPT", toupper(nom_table), sep = "_"))
  
  ref_comptage <- read.csv2(file_comptage)
  
  ###
  ## tables simples
  ###
  
  # recuperation de "Nom_balise"
  list_nom_variables_simples <- ref_comptage %>% 
    filter(grepl("simple", type_balise) & !grepl("date|Date", type_balise)) %>% 
    pull(Nom_balise) %>% 
    unique
  
  # recuperation de "Parent" (traitement specifique sur les dates)
  list_nom_variables_simples_dates <- ref_comptage %>% 
    filter(grepl("simple", type_balise) & grepl("date|Date", type_balise)) %>% 
    pull(Parent) %>% 
    unique
  
  # noms de colonnes post traitements 
  id_ref <- paste("id", nom_table, sep= "_")
  list_nom_variables_simples_traite <- c(id_ref, "balises_error")
  
  # structure du data frame
  list_nom_variables_simples <- c(list_nom_variables_simples_traite, 
                                  list_nom_variables_simples_dates, 
                                  list_nom_variables_simples)
  
  # data frame vide
  nb_col <- length(list_nom_variables_simples)
  df = data.frame(matrix(
    character(), 0, nb_col, dimnames=list(c(), list_nom_variables_simples)),
    stringsAsFactors=F)
  
  # noms en minuscule
  names(df) <- tolower(names(df))
  
  # application date pour certaines dates
  index <- grep("date", names(df))
  for(i in index){
    df[,i] <- as.Date(df[,i])
  }
  
  
  # creation de requetes
  cle_id_ref <- paste("cle", "id", nom_table, sep="_")
  cle_prim_id_ref <- paste("pk", "id", nom_table, sep="_")
  
  
  
  requete_des_droits <- paste0("GRANT SELECT ON TABLE ", 
                               "\"", 
                               nom_schema, 
                               "\"", 
                               ".", 
                               "\"",
                               nom_table, 
                               "\"",
                               ' TO "INC_U_PRI";')
  
  requete_creation_index <- paste0("CREATE INDEX IF NOT EXISTS ",
                                   "\"",
                                   cle_id_ref,
                                   "\"",
                                   " ON ",
                                   "\"",
                                   nom_schema,
                                   "\"",
                                   ".",
                                   "\"",
                                   nom_table,
                                   "\"",
                                   " (",
                                   "\"",
                                   id_ref,
                                   "\"",
                                   ") ;")
  requete_cle_primaire <- paste0("ALTER TABLE ",
                                 "\"",
                                 nom_schema,
                                 "\"",
                                 ".",
                                 "\"",
                                 nom_table,
                                 "\"",
                                 " ADD CONSTRAINT ",
                                 cle_prim_id_ref,
                                 " PRIMARY KEY (",
                                 "\"",
                                 id_ref,
                                 "\"",
                                 ");")
  
  # Execution des requetes
  dbWriteTable(con, name=c(nom_schema, nom_table), value = df, overwrite = TRUE, row.names=FALSE)
  
  dbGetQuery(con, requete_des_droits)
  dbGetQuery(con, requete_creation_index)
  dbGetQuery(con,requete_cle_primaire)
  
  ###
  ## tables multiples
  ###
  # structure du data frame
  list_nom_variables_mult <- c(id_ref, "Nom_balise", "Parent", "Chemin", "Profondeur", "Valeur", "Attribut" )
  
  # data frame vide
  nb_col <- length(list_nom_variables_mult)
  df_mult = data.frame(matrix(
    character(), 0, nb_col, dimnames=list(c(), list_nom_variables_mult)),
    stringsAsFactors=F)
  
  # noms en minuscule
  names(df_mult) <- tolower(names(df_mult))
  
  nom_table_mult <- paste0(nom_table, "_mult")
  # Ecriture requetes
  cle_id_ref_mult <- paste("cle", "id", nom_table_mult, sep="_")
  cle_prim_id_ref_mult <- paste("pk", "id", nom_table_mult, sep="_")
  cle_id_ref_mult_bis <- paste("pk", "id", nom_table_mult, "id", sep="_")
  
  requete_des_droits <- paste0("GRANT SELECT ON TABLE ",
                               "\"",
                               nom_schema,
                               "\"",
                               ".",
                               "\"",
                               nom_table_mult,
                               "\"",
                               ' TO "INC_U_PRI";')
  requete_creation_index <- paste0("CREATE INDEX IF NOT EXISTS ",
                                   "\"",
                                   cle_id_ref_mult,
                                   "\"",
                                   " ON ",
                                   "\"",
                                   nom_schema,
                                   "\"",
                                   ".",
                                   "\"",
                                   nom_table_mult,
                                   "\"",
                                   " (",
                                   "\"",
                                   id_ref,
                                   "\"",
                                   ",\"chemin\") ;")
  requete_creation_index_bis <- paste0("CREATE INDEX IF NOT EXISTS ",
                                       "\"",
                                       cle_id_ref_mult_bis,
                                       "\"",
                                       " ON ",
                                       "\"",
                                       nom_schema,
                                       "\"",
                                       ".",
                                       "\"",
                                       nom_table_mult,
                                       "\"",
                                       " (",
                                       "\"",
                                       id_ref,
                                       "\"",
                                       ") ;")
  requete_cle_primaire <- paste0("ALTER TABLE ",
                                 "\"",
                                 nom_schema,
                                 "\"",
                                 ".",
                                 "\"",
                                 nom_table_mult,
                                 "\"",
                                 " ADD CONSTRAINT ",
                                 cle_prim_id_ref_mult,
                                 " PRIMARY KEY (",
                                 "\"",
                                 id_ref,
                                 "\"",
                                 ",\"chemin\");")
  
  # Execution requetes
  dbWriteTable(con, name=c(nom_schema, nom_table_mult), overwrite=TRUE, value = df_mult, row.names=FALSE)
  
  dbGetQuery(con, requete_des_droits)
  dbGetQuery(con, requete_creation_index)
  dbGetQuery(con, requete_creation_index_bis)
  dbGetQuery(con,requete_cle_primaire)
  
}
