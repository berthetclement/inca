load_rds_file_to_db <- function(rds_file, referentiel, nom_schema, nom_table){

  df_rds = readRDS(rds_file)
  id_ref = paste("id", nom_table, sep = "_")
    
  ## SPLIT table balises simples
  fic_rds_simples = split_rds(obj_rds = df_rds, 
                               simple_table = TRUE, 
                               name_id = id_ref, 
                               referentiel = referentiel)
    
  ## SPLIT table balises multiples
  fic_rds_multiples = split_rds(obj_rds = df_rds, 
                                 name_id = id_ref, 
                                 referentiel = referentiel)
      
  pstgr_write_table(nom_schema = nom_schema, nom_table = nom_table, data_rds = fic_rds_simples)
  pstgr_write_table(nom_schema = nom_schema, nom_table = paste(nom_table, "mult", sep = "_"), data_rds = fic_rds_multiples)
}
