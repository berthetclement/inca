#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   Lancement_PUBMED                                        #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Fonction qui teste l'existence d'un schema et le cree si besoin                       #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #   nom_schema : nom du schema a créer                                                   #
#  #                                                                                        #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #  Le schema cree s'il n existait pas                                                   #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#



pstgr_init_schema <- function(nom_schema){
  # requete
  Creation_Schema_NCT_Tampon <- paste0("CREATE SCHEMA IF NOT EXISTS ", 
                                      "\"", 
                                      nom_schema, 
                                      "\"", 
                                      " AUTHORIZATION \"INC_U_PRI_A\" ;
                                      GRANT USAGE ON SCHEMA ",
                                      "\"",
                                      nom_schema, 
                                      "\"", 
                                      " TO \"INC_U_PRI\" ;
                                      GRANT ALL ON SCHEMA ",
                                      "\"", 
                                      nom_schema, 
                                      "\"", 
                                      " TO \"INC_U_DSI\" ;")
  
  # execution
  dbGetQuery(con, Creation_Schema_NCT_Tampon)
}
