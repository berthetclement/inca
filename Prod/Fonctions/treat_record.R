## Traite un enregistrement children_0
## nom_parent_id et nom_balise_id utilisés pour détecter l'identifiant de l'enregistrement
## Retourne un data frame / data table avec une colonne id_{data_type} pour identifier l'enregistrement


treat_record <- function(children_0, nom_parent_id, nom_balise_id, data_type){
  
  df_record = initialize_df_record()
  len_df_record = length(df_record)
  
  level_child = 0
  depth = 1
  
  while (depth > 0) {
    children_N = get(paste0("children_",level_child))
    assign(paste0("children_", level_child+1), xml_children(children_N), envir = .GlobalEnv)
    depth = sum(xml_length(children_N))
    level_child = level_child + 1
  }
  
  lst_df_child = lapply(1:level_child, FUN = function(idx){treat_level_child(idx,len_df_record)})
  df_record = do.call("rbind", lst_df_child)
  
  rm(list = ls(pattern = "children_"))
  
  dt_record = as.data.table(df_record)
  
  id_unique_file = dt_record %>% filter(Nom_balise == nom_balise_id & Parent == nom_parent_id) %>% pull(Valeur)
  
  dt_record = dt_record %>% mutate(id = id_unique_file)
  colnames(dt_record)[which(colnames(dt_record) == "id")] = paste("id", data_type, sep = "_")
  
  return(dt_record)  
}
