#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   create_index                                            #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction cree un index sur une table postgre                                    #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # nom_schema : nom du schema                                                             #
#  # nom_table  : nom de la table                                                           #
#  # idx_name : nom de l'index                                                              #
#  # col_to_idx : colonne à indexer                                                         # 
#  # idx_type : type de l'index.                                                            #
#  #            ==> Ajoute la colonne "chemin" à col_to_idx dans l'index si la valeur       #
#  #                 est différente de "single_column"                                      #
#                                                                                           #
## En sortie :                                                                              #
#   #  La table sous postrgre avec l'index                                                  #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


create_index <- function(nom_schema, nom_table, idx_name, col_to_idx, idx_type){
  
  if(idx_type == "single_column"){
    query_index_creation = paste0("CREATE INDEX IF NOT EXISTS ",
                                   "\"",
                                   idx_name,
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
                                   col_to_idx,
                                   "\"",
                                   ") ;")
  }else{
    query_index_creation <- paste0("CREATE INDEX IF NOT EXISTS ",
                                   "\"",
                                   idx_name,
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
                                   col_to_idx,
                                   "\"",
                                   ",\"chemin\") ;")
  }
  
  return(query_index_creation)
  
}
