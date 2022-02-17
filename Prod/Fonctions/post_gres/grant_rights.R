#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   grant_rights                                            #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction donne les droits de select sur une table                               #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # nom_schema : nom du schema                                                             #
#  # nom_table  : nom de la table                                                           #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #  La table sous postrgre avec les droits de select                                     #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


grant_rights <- function(nom_schema, nom_table){
  
  query_rights <- paste0("GRANT SELECT ON TABLE ", 
                               "\"", 
                               nom_schema, 
                               "\"", 
                               ".", 
                               "\"",
                               nom_table, 
                               "\"",
                               ' TO "INC_U_PRI";')
  
  return(query_rights)
}
