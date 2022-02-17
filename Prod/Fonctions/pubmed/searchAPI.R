#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   searchAPI                                               #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction permet la récupération des id des publications liees a un NCT          #
#  #  Elle permet egalement de remonter sur l'API la liste des publications que l 'on       #      
#  #  ramenera par la suite pour les recuperer en masse (option use_history = TRUE)         #   
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # base_name   : indique la base que l'on va souhaiter interroger, ici c'est pubmed       #
#  # search_term : indique l'occurence de texte recherchee et ou (fourni pas INCA ici)      #
#  # nb_id_max   : indique le nombre maximum d'identification a ramener : 999999 par defaut #
#  # opt_history : indique si l'on veut remonter sur l'API la liste des publications pour   #
#                  permettre la recuperation en masse par la suite.                         #
#                                                                                           #
## En sortie :                                                                              #
#   #  un objet contenant l'ensemble des publications à ramener au format attendu par le    #
#   #  fonction entrez_fetch du package rentrez pour la recuperation des publications       #                                                                                   #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

searchAPI <- function(base_name= "pubmed", 
                           search_term= "(ClinicalTrials.gov[Secondary Source ID])", 
                           nb_id_max= 999999, 
                           opt_history= TRUE){
  key_term_search <- search_term
  r_search <- entrez_search(db= base_name, 
                            term= search_term, 
                            retmax= nb_id_max, 
                            use_history = opt_history )
  r_search
}
