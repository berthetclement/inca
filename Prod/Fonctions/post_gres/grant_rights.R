#-------------------------------------------------------#
#                                                       #
#     grant_rights.R                                    #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

## Description parameters : 
# nom_schema : nom du schema en caracteres
# nom_table : nom de la table en caracteres

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
