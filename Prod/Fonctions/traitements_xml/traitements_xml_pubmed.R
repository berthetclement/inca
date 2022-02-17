#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   traitements_xml_pubmed                                  #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #   Cette fonction traite et structure un lot de publication recupere en XML             #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  id_a_charger      : liste des identifiants a charger                                  #
#  #  r_search          : objet cree par search API                                         #
#  #  full_xml_database : lot de données .xml de type pubmed                                #
#  #  i_lot             : identifiant du lot traite                                         #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #  un fichier RDS avec les donnees XML extraite structurees                             #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#



traitements_xml_pubmed <- function(id_a_charger, r_search, full_xml_database, i_lot){
  
  # Boucle principale : pour chaque bloc de fichiers xml
  for(nb_lot in seq(1, length(full_xml_database))){ 
    
    tableau_dt_final <- data.frame()
    
    base_lot_1 <- read_xml(full_xml_database[[nb_lot]])
    all_files = xml_children(base_lot_1)
    
    if (length(all_files) > 0){
      lst_tableau_dt_final = lapply(1:length(all_files)
                                    , FUN = function(idx){ traitements_xml_pubmed_file(all_files[idx], id_a_charger, r_search, i_lot) }
      )
      
      tableau_dt_final = do.call("rbind", lst_tableau_dt_final)
    }
    
    if (nrow(tableau_dt_final) > 0) {
      saveRDS(tableau_dt_final, paste0(DIR_OUTPUT_RDS_PUBMED, paste0("lot_", i_lot), ".RDS"))
    }
  } 
}
