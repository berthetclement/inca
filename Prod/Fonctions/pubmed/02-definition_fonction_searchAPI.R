


#-------------------------------------------------------#
#                                                       #
#            02-definition_fonction_searchAPI.r         #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


# Recherche dans une base 
# Recherche avec occurences de texte

searchAPI <- function(base_name= "pubmed", 
                           search_term= "(ClinicalTrials.gov[Secondary Source ID])", 
                           nb_id_max= 150000, 
                           opt_history= TRUE){
  key_term_search <- search_term
  r_search <- entrez_search(db= base_name, 
                            term= search_term, 
                            retmax= nb_id_max, 
                            use_history = opt_history )
  r_search
}
