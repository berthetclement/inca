#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   fetchAPI                                                #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction permet la récupération des publications liees a un NCT au format XML   #
#  #  Elle permet egalement de maitriser le nombre de publications ramener                  #      
#  #  Elle utilise la fonction entrez_fetch du package rentrez                              #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # search_object   : objet cree par search API                                            #
#  # pos_start       : position de la premiere publication a recuperer dans search_object   #
#  # pos_stop        : position de la derniere publication a recuperer dans search_object   #
#  # step_by         : indique si le niveau de pas par lequel on veut recup les publications#
#  # db_name         : indique la base que l'on va souhaiter interroger, ici c'est pubmed   #
#  # web_histo       : indique l'element de search_objet qui permet la recuperation en masse#
#  # parse           : indique si l'on souhaite recuperer des donnees parsees ou non cations#
#                                                                                           #
## En sortie :                                                                              #
#   #  une liste de fichiers xml refletant les publications que l'on a souhaite  recuperer  #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


fetchAPI <- function(search_object, pos_start, pos_stop, step_by, db_name, web_histo= NULL, parse=FALSE){
  
  if(all(class(search_object) %in% c("esearch", "list"))){
    cat("\nTotal ID : ", search_object$count, "\n")
    longueur <- pos_stop-pos_start+1
    cat("\nTotal ID fetch: ", longueur, "\n")
    recs <- list()
    i=1
    for( seq_start in seq(pos_start,pos_stop,step_by)){
      recs[[i]] <- entrez_fetch(db=db_name, 
                                web_history=web_histo,
                                rettype="xml", 
                                retmax=step_by, 
                                retstart=seq_start-1,
                                parsed = parse)
      i=i+1
      cat(seq_start+(step_by-1), "sequences downloaded\r")
    }
  }else 
    stop("put result object from entrez_search function")
  
  return(recs)
  
}