#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                     treat_record                                          #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction traite un enregistrement donné dans un xml                             #
#  # nom_parent_idn nom_balise_id utilisés pour détecter l'identifiant de l'enregistrement  #                                                                                     #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # children_0   : élément d'un .xml                                                       #
#  #              ==>(un enfant de niveau 0 qui contient les balises d'un enregistrement)   #                                                                                      #
#  # nom_parent_id : cle utilise pour détecter l'identifiant de l'enregistrement            #
#  # nom_balise_id : cle utilise pour détecter l'identifiant de l'enregistrement            #
#  # data_type     : type de données à traiter                                              #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   # un data frame contenant l'ensemble des niveaux de l'enregistrement                    #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


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
  
  if(data_type != "pubmed"){
    id_unique_file = dt_record %>% filter(Nom_balise == nom_balise_id & Parent == nom_parent_id) %>% pull(Valeur)
    dt_record = dt_record %>% mutate(id = id_unique_file)
    colnames(dt_record)[which(colnames(dt_record) == "id")] = paste("id", data_type, sep = "_")
  }
  
  return(dt_record)  
}
