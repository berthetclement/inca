#-------------------------------------------------------#
#                                                       #
#   10-definition_fonction_full_traitements_xml.R       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

# fonction permettant d'aleger les traitements xml
  # permet de gerer les traitements de fichiers xml pubmed par paquet d'id 
  # permet d'alleger la taill de l'objet en sorti de la fonction fetchAPI()
  # les etapes : 
    # - telechargement des publications (fetch)
    # - tests des id telecharges + creation du fichier de suivi 
    # - traitements des fichiers xml vers data frame + test si presence NCT dans la publication

full_traitements_xml <- function(id_a_charger,r_search,pos_id_start, pos_id_end, by_nb_id){
  # premier decoupage de la sequence d'id 
  for( seq_index in seq(pos_id_start, pos_id_end, by_nb_id)){
    
    # fetch
    
    # on va gérer les cas où l'on doit ramener moins de publication que le step_by
    
    pos_stop <- (seq_index+by_nb_id-1)
    
    full_recs_xml_web <- fetchAPI(search_object = r_search
                                  ,pos_start = seq_index
                                  ,pos_stop = pos_stop
                                  ,step_by = by_nb_id
                                  ,db_name = "pubmed"
                                  ,web_histo = r_search$web_history
                                  ,parse = FALSE)
    
    # 3 - Lancement traitement fichiers xml ----
    # pour chaque lot de fichiers xml => export RDS
    # un seul data frame pour l'ensemble des fichiers n'est pas possible
    # check des id avec NCT : appel a la fonction 07-definition_foctions_check_xml.R
    traitements_xml_pubmed(id_a_charger = id_a_charger
                           ,r_search = r_search
                           ,full_xml_database = full_recs_xml_web
                           ,i_lot = format(Sys.time(),"%Y%m%d%H%M%S"))
    
    rm(full_recs_xml_web)
    
  }
}