
#-------------------------------------------------------#
#                                                       #
#            01-definition_fonction_log.r               #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

# print de la sortie console vers un fichier log



# Creation LOG ----
journal <- function(nom_connexion,nom_programme) {
  
  
  assign(paste0('connexion_',nom_connexion), file(paste0(chemin_log,nom_programme, format(Sys.time(),"%Y%m%d%H%M%S"),'.log')))
  
  # création avec la commande "sink" du fichier texte, identifié par la connexion "connexion"
  
  # par défaut, écris les output dans le fichier texte
  # ce fichier est vide
  sink(get(paste0('connexion_',nom_connexion)), append=TRUE)
  
  # on précise qu'on veut obtenir les messages de console
  # le fichier reste vide
  sink(get(paste0('connexion_',nom_connexion)), append=TRUE, type="message")
  }



