#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   pstgr_write_table                                       #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  L'objectif de cette fonction est de remontee la table en parametre dans la table      #
#  #  Postgre cible                                                                         #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # nom_schema : schema cible                                                              #
#  # nom_table  : table cible                                                               #
#  # data_rds   : donnees a remonter                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   # la table postegre enrichit                                                            #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


pstgr_write_table <- function(nom_schema, nom_table, data_rds){
  # Chargement tables 
    #on met en minuscule le nom des champs pour qu'ils soient en minuscules dans la table
    names(data_rds) <- tolower(names(data_rds))
    
    # on remonte les donnees de la table (avec un append donc on enrichit)
    RPostgreSQL::dbWriteTable(con,
                              name=c(nom_schema, nom_table),
                              value = data_rds,
                              append = TRUE,
                              row.names=FALSE)
  
    # on met les bons droits 
    requete_des_droits <- paste0("GRANT SELECT ON TABLE ", "\"",nom_schema,"\"", ".", "\"", nom_table, "\"", 'TO "INC_U_PRI";')
    dbGetQuery(con, requete_des_droits)
}
