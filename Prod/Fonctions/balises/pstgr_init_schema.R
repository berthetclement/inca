#-------------------------------------------------------#
#                                                       #
#              pstgr_init_schema.R                      #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#



pstgr_init_schema <- function(nom_schema){
  # requete
  Creation_Schema_NCT_Tampon <- paste("CREATE SCHEMA IF NOT EXISTS ", 
                                      "\"", 
                                      nom_schema, 
                                      "\"", 
                                      " AUTHORIZATION \"INC_U_PRI_A\" ;
                                      GRANT USAGE ON SCHEMA ",
                                      "\"",
                                      nom_schema, 
                                      "\"", 
                                      " TO \"INC_U_PRI\ ;
                                      GRANT ALL ON SCHEMA",
                                      "\"", 
                                      nom_schema, 
                                      "\"", 
                                      " TO \"INC_U_DSI\" ;")
  
  # execution
  dbGetQuery(con, Creation_Schema_NCT_Tampon)
}