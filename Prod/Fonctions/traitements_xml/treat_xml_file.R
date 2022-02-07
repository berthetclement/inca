## Traite les données xml full_xml_database après lecture du fichier .xml 
## nom_parent_id et nom_balise_id utilisés pour détecter l'identifiant de l'enregistrement
## output_rds est le répertoire de sortie des fichiers .rds
## prefix_rds est le préfixe du fichier .rds de sortie
## output_suivi est le répertoire contenant le fichier de suivi du traitement des données
## file_suivi est le fichier de suivi du traitement des données
## test_fun est la fonction de test de la qualité des données
## data_type est le type de la donnée en entrée parmi les référentiels existants (supp, qual, pa, desc)


treat_xml_file <- function(full_xml_database, nom_parent_id, nom_balise_id, output_rds, prefix_rds, output_suivi, file_suivi, test_fun, data_type){
  
  all_records = xml_children(full_xml_database)
  lst_dt_record = lapply(1:length(all_records)
                        , FUN = function(idx){
                                              treat_record(all_records[idx], nom_parent_id, nom_balise_id, data_type)
                                             }
                        )
  dt_record_concat = do.call("rbind", lst_dt_record)
  
  horodatage = format(Sys.time(),"%Y%m%d%H%M%S")
  rds_filename = paste0(prefix_rds, horodatage, ".RDS")
  dt_check = test_fun(dt_record_concat, horodatage, rds_filename)
  
  saveRDS(dt_record_concat, paste0(output_rds, rds_filename))
  write_data_check_to_csv(dt_check, output_suivi, file_suivi)
}
