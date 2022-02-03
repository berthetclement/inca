#-------------------------------------------------------#
#                                                       #
#                pstgr_write_table.R                    #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


pstgr_write_table <- function(nom_schema, nom_table, data_rds){
  # Chargement tables 
  names(data_rds) <- tolower(names(data_rds))
  
  RPostgreSQL::dbWriteTable(con, name=c(nom_schema, nom_table), value = data_rds, append = TRUE, row.names=FALSE)
  
  requete_des_droits <- paste0("GRANT SELECT ON TABLE ", "\"",nom_schema,"\"", ".", "\"", nom_table, "\"", 'TO "INC_U_PRI";')
  dbGetQuery(con, requete_des_droits)
}
