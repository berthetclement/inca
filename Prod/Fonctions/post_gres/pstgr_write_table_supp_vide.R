#-------------------------------------------------------#
#                                                       #
#     pstgr_write_table_supp_vide.R                     #
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

pstgr_write_table_supp_vide <- function(ref_comptage, nom_schema, nom_table){
  # lecture referentiel valide en INPUT
  ref_comptage <- read.csv2(ref_comptage)
  
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
  list_nom_variables_simples_traite <- c("id_supp", "balises_error")
  
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
  requete_des_droits <- paste0("GRANT SELECT ON TABLE ", 
                              "\"", 
                              nom_schema, 
                              "\"", 
                              ".", 
                              "\"",
                              nom_table, 
                              "\"",
                              ' TO "INC_U_PRI";')
  requete_creation_index <- paste0("CREATE INDEX IF NOT EXISTS \"cle_id_supp\" ON ",
                                   "\"",
                                   nom_schema,
                                   "\"",
                                   ".",
                                   "\"",
                                   nom_table,
                                   "\"",
                                   "(\"id_supp\") ;")
  requete_cle_primaire <- paste0("ALTER TABLE ",
                                 "\"",
                                 nom_schema,
                                 "\"",
                                 ".",
                                 "\"",
                                 nom_table,
                                 "\"",
                                 "ADD CONSTRAINT pk_id_supp PRIMARY KEY (\"id_supp\");")
  
  # Execution des requetes
  dbWriteTable(con, name=c(nom_schema, nom_table), value = df, overwrite = TRUE, row.names=FALSE)
  
  dbGetQuery(con, requete_des_droits)
  dbGetQuery(con, requete_creation_index)
  dbGetQuery(con,requete_cle_primaire)
  
  ###
  ## tables multiples
  ###
  # structure du data frame
  list_nom_variables_mult <- c("id_supp", "Nom_balise", "Parent", "Chemin", "Profondeur", "Valeur", "Attribut" )
  
  # data frame vide
  nb_col <- length(list_nom_variables_mult)
  df_mult = data.frame(matrix(
    character(), 0, nb_col, dimnames=list(c(), list_nom_variables_mult)),
    stringsAsFactors=F)
  
  # noms en minuscule
  names(df_mult) <- tolower(names(df_mult))
  
  nom_table <- paste0(nom_table, "_mult")
  # Ecriture requetes
  requete_des_droits <- paste0("GRANT SELECT ON TABLE ",
                               "\"",
                               nom_schema,
                               "\"",
                               ".",
                               "\"",
                               nom_table,
                               "\"",
                               ' TO "INC_U_PRI";')
  requete_creation_index <- paste0("CREATE INDEX IF NOT EXISTS \"cle_id_supp_mult\" ON ",
                                   "\"",
                                   nom_schema,
                                   "\"",
                                   ".",
                                   "\"",
                                   nom_table,
                                   "\"",
                                   " (\"id_supp\",\"chemin\") ;")
  requete_creation_index_bis <- paste0("CREATE INDEX IF NOT EXISTS \"cle_id_supp_mult_id\" ON ",
                                       "\"",
                                       nom_schema,
                                       "\"",
                                       ".",
                                       "\"",
                                       nom_table,
                                       "\"",
                                       " (\"id_supp\") ;")
  requete_cle_primaire <- paste0("ALTER TABLE ",
                                 "\"",
                                 nom_schema,
                                 "\"",
                                 ".",
                                 "\"",
                                 nom_table,
                                 "\"",
                                 " ADD CONSTRAINT pk_supp_mult PRIMARY KEY (\"id_supp\",\"chemin\");")
  
  # Execution requetes
  dbWriteTable(con, name=c(nom_schema, nom_table), overwrite=TRUE, value = df_mult, row.names=FALSE)
  
  dbGetQuery(con, requete_des_droits)
  dbGetQuery(con, requete_creation_index)
  dbGetQuery(con, requete_creation_index_bis)
  dbGetQuery(con,requete_cle_primaire)
  
}
