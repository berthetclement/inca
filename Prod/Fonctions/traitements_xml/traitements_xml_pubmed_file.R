#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   traitements_xml_pubmed_file                             #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #   Cette fonction traite et structure une publication recuperee en XML                  #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  file_unique_xml   : traitement d'une publication au format XML                        #
#  #  id_a_charger      : liste des identifiants a charger                                  #
#  #  r_search          : objet cree par search API                                         #
#  #  i_lot             : identifiant du lot traite                                         #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #  un dataframe avec les donnees XML de la publication extraite structuree              #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


## Apparition de cette fonction qui traite pubmed à la maille "fichier"
traitements_xml_pubmed_file <- function(file_unique_xml, id_a_charger, r_search, i_lot){
  
  tableau_dt_final <- data.frame()
  
  if (test_reprise_necessaire(id_a_charger,file_unique_xml) == 1) {
    
    dt_file = data.frame()
    
    all_records = xml_children(file_unique_xml)		
    lst_dt_record_branche = lapply(1:length(all_records)
                                   , FUN = function(idx){ treat_record(all_records[idx], "", "", "pubmed") }
    )
    
    dt_record_branche_concat = do.call("rbind", lst_dt_record_branche)
    dt_file = as.data.table(rbind(dt_file, dt_record_branche_concat))
    
    id_pubmed = dt_file %>% filter(Nom_balise == NOM_BALISE_ID_PUBMED & Parent == NOM_PARENT_ID_PUBMED) %>% pull(Valeur)
    dt_file = dt_file %>% mutate(id_pubmed = id_pubmed)
    tableau_dt_final = as.data.table(rbind(tableau_dt_final, dt_file))
    
    id_search <- r_search$ids[r_search$ids %in% id_pubmed]
    df = data.frame(recherche_id = id_search, fetch_id = exists("id_search"))
    res_test = check_xml(dt_file, i_lot)
    df = cbind(df,res_test)
    write_data_check_to_csv(df, DIR_OUTPUT_SUIVI, FILE_SUIVI_PUBMED)
  }
  
  return(tableau_dt_final)
}