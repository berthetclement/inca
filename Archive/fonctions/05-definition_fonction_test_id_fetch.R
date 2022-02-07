

#-------------------------------------------------------#
#                                                       #
#      05-definition_fonction_test_id_fetch.r           #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


test_id_fetch <- function(pos_start_id, pos_stop_id, full_fetch_object, path_dir_out){
 # conversion en bloc dans une liste 
  list_test_id <- lapply(full_fetch_object, function(x){
    l <- XML::xmlToList(x)
  })
  
  # les indices 
  start = pos_start_id
  stop = pos_stop_id # fixer les indices par pas 
  
  cat("\n", "Nombre de blocs : ", length(list_test_id))
  cat("\n", "Nombre de fichiers xml dans un bloc : ", length(list_test_id[[1]]))
  
  df_suivi <- data.table()
  for(nb_bloc in seq(1, length(list_test_id))){
    
    # 1 - extraire un bloc 
    bloc <- list_test_id[[nb_bloc]]
    
    # 2 - extraire les id di bloc
    res_id_list <- lapply(bloc, function(x){
      x$MedlineCitation$PMID$text})
    
    id_fetch <- unname(unlist(res_id_list))
    id_search <- r_search$ids[start:stop]
    
    # 3 - boolee test qui servira d'index
    test <- id_search %in% id_fetch 
    
    # 4 - data frame de suivi des id
    df <- as.data.table(data.frame(recherche_id= id_search,
                                   fetch_id= test))
    df_suivi <- rbind(df_suivi, df)
    
    start <- stop+1
    stop <- stop+step_by_id
    
  }
  
    cat("\n", 
        "Dimension fichier de suivi des id charges : ",
        "\n",
        dim(df_suivi),
        "\n"
    )
    write.table(df_suivi, 
                paste0(path_dir_out, nom_fichier_suivi_id), 
                row.names = FALSE, 
                sep = ";", 
                append = TRUE,
                col.names = !file.exists(paste0(path_dir_out, nom_fichier_suivi_id)))
  
  
}
