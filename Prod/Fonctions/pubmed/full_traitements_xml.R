#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   full_traitements_xml                                    #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction permet l'integration en RDS de l'ensemble des xml.                     #
#  #  chaque RDS contiendra le nombre de publication defini en parametre                    #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # id_a_charger   : la liste des id a charger :                                           #    
#                           - le vecteur issu de r_search a l'init                          #
#                           - le vecteur issu identification_id_a_charger() si reprise      #
#  # r_search        : objet cree par search API                                            #
#  # pos_id_start    : position de la premiere publication a recuperer dans search_object   #
#  # pos_id_end      : position de la derniere publication a recuperer dans search_object   #
#  # by_nb_id        : nombre de xml par fichier : definit dans les parametres initiaux     #
#                                                                                           #
## En sortie :                                                                              #
#   #  Les fichiers RDS issus de la structuration des xml ramenes                           #
#   #  Le fichier de suivi des integrations                                                 #
#                                                                                           #
#-------------------------------------------------------------------------------------------#



full_traitements_xml <- function(id_a_charger,r_search,pos_id_start, pos_id_end, by_nb_id){
  # premier decoupage de la sequence d'id 
  for( seq_index in seq(pos_id_start, pos_id_end, by_nb_id)){
    
    # 1-Recuperation des fichiers XML par paquet
      
      pos_stop <- (seq_index+by_nb_id-1)
      
      full_recs_xml_web <- fetchAPI(search_object = r_search
                                    ,pos_start = seq_index
                                    ,pos_stop = pos_stop
                                    ,step_by = by_nb_id
                                    ,db_name = "pubmed"
                                    ,web_histo = r_search$web_history
                                    ,parse = FALSE)
    
    # 2-Structuration du fichier XML en RDS
      traitements_xml_pubmed(id_a_charger = id_a_charger
                           ,r_search = r_search
                           ,full_xml_database = full_recs_xml_web
                           ,i_lot = format(Sys.time(),"%Y%m%d%H%M%S"))
    
      rm(full_recs_xml_web)
    
  }
}