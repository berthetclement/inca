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
# nom_schema : nom du schema en caracteres
# nom_table : nom de la table en caracteres

pstgr_write_table_ref_vide <- function(nom_schema, nom_table){
  
  # Recuperation du nom du fichier de balisage 
  file_comptage = get(paste("PATH_REF_CPT", toupper(nom_table), sep = "_"))
  
  ref_comptage <- read.csv2(file_comptage)
  
  ###
  ##  recuperation des noms de variables pour la table SIMPLE 
  ###
  
  # variables SIMPLE_TAG
  simple_tag_to_char <- (ref_comptage
							%>% filter(type_balise %in% LST_SIMPLE_TAG)
								%>% pull(Nom_balise)
									%>% unique)
  
  # variables SIMPLE_DATE_BDD_DATE
  simple_date_to_date <- (ref_comptage
							%>% filter(type_balise %in% LST_SIMPLE_DATE_BDD_DATE)
								%>% pull(Parent)
									%>% unique)
  
  # variables SIMPLE_DATE_BDD_CHARACTER
  simple_date_to_char <- (ref_comptage
							 %>% filter(type_balise %in% LST_SIMPLE_DATE_BDD_CHARACTER) 
								%>% pull(Parent)
									%>% unique)
  
  # noms de colonnes post traitements 
  id_ref <- paste("id", nom_table, sep = "_")
  
  ###
  ## tables simples
  ###
  # Structure du data frame
  list_nom_variables_simples = tolower(
									c(id_ref,
									simple_date_to_date,
									simple_date_to_char,								  
									simple_tag_to_char,
									LST_SIMPLE_CALC
									)
									)
  
  df_simple = initialize_df_table_simple_mult(list_nom_variables_simples)
  df_simple[tolower(simple_date_to_date)] = lapply(df_simple[tolower(simple_date_to_date)], as.Date, origin = "1899-12-30")
  
  # Preparation des elements des requetes
  #idx_id_ref = paste("idx", "id", nom_table, sep = "_")
  primary_key_name_simple = paste("pk", "id", nom_table, sep = "_")
  
  # Generation des requetes
  query_rights_simple = grant_rights(nom_schema, nom_table)
  #Une PK est un index particulier par definition
  #query_idx_id_ref_simple = create_index(nom_schema, nom_table, idx_id_ref, id_ref, "single_column")
  query_primary_key_simple = create_primary_key(nom_schema, nom_table, primary_key_name_simple, id_ref, "table_simple")
  
  # Execution des requetes
  dbWriteTable(con, name = c(nom_schema, nom_table), value = df_simple, overwrite = TRUE, row.names = FALSE)
  dbGetQuery(con, query_rights_simple)
  #dbGetQuery(con, query_idx_id_ref_simple)
  dbGetQuery(con, query_primary_key_simple)
  
  ###
  ## tables multiples
  ###
  # Structure du data frame
  list_nom_variables_mult = tolower(c(id_ref, LST_COLS_MULT))
  df_mult = initialize_df_table_simple_mult(list_nom_variables_mult)
  
  # Preparation des elements des requetes
  nom_table_mult = paste(nom_table, "mult", sep = "_")
  idx_id_ref_mult = paste("idx", "id", nom_table, "mult", sep = "_")
  #idx_id_ref_mult_chemin = paste("idx", "id", nom_table, "chemin", "mult", sep = "_")
  primary_key_name_mult = paste("pk", "id", nom_table, "chemin", "mult", sep = "_")
  
  # Generation des requetes
  query_rights_mult = grant_rights(nom_schema, nom_table_mult)
  query_idx_mult_id_ref = create_index(nom_schema, nom_table_mult, idx_id_ref_mult, id_ref, "single_column")
  #Une PK est un index particulier par definition
  #query_idx_mult_id_ref_chemin = create_index(nom_schema, nom_table_mult, idx_id_ref_mult_chemin, id_ref, "with_chemin")
  query_primary_key_mult = create_primary_key(nom_schema, nom_table_mult, primary_key_name_mult, id_ref, "table_mult")
  
  # Execution des requetes
  dbWriteTable(con, name = c(nom_schema, nom_table_mult), overwrite = TRUE, value = df_mult, row.names = FALSE)
  dbGetQuery(con, query_rights_mult)
  #dbGetQuery(con, query_idx_mult_id_ref_chemin)
  dbGetQuery(con, query_idx_mult_id_ref)
  dbGetQuery(con, query_primary_key_mult)
}
