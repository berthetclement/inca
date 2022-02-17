#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   create_primary_key                                      #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction cree une cle primaire sur une table postgre                            #
#  #  Par construction, cette cle est egalement un index                                    #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # nom_schema : nom du schema                                                             #
#  # nom_table  : nom de la table                                                           #
#  # pk_name    : nom de la cle primaire                                                    #
#  # pk_col     : colonne identifiee en tant que cle primaire                               # 
#  # pk_type    : type de la clé primaire.                                                  #
#  #              ==> Ajoute la colonne "chemin" à pk_col dans la clé primaire              #
#  #                  si la valeur est différente de "table_simple"                         #
#                                                                                           #
## En sortie :                                                                              #
#   #  La table sous postrgre avec la cle primaire et l'index                               #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


create_primary_key <- function(nom_schema, nom_table, pk_name, pk_col, pk_type){
  
  if(pk_type == "table_simple"){
    query_primary_key <- paste0("ALTER TABLE ",
                                 "\"",
                                 nom_schema,
                                 "\"",
                                 ".",
                                 "\"",
                                 nom_table,
                                 "\"",
                                 " ADD CONSTRAINT ",
                                 pk_name,
                                 " PRIMARY KEY (",
                                 "\"",
                                 pk_col,
                                 "\"",
                                 ");")
  }else{
    query_primary_key <- paste0("ALTER TABLE ",
                                 "\"",
                                 nom_schema,
                                 "\"",
                                 ".",
                                 "\"",
                                 nom_table,
                                 "\"",
                                 " ADD CONSTRAINT ",
                                 pk_name,
                                 " PRIMARY KEY (",
                                 "\"",
                                 pk_col,
                                 "\"",
                                 ",\"chemin\");")
  }
  
  return(query_primary_key)
  
}
