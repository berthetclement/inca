#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                           journal                                         #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #   Cette fonction a vocation a exporter dans un fichier plat la log d'un traitement     #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  nom_connexion : nom de la connexion a la log                                          #
#  #  nom_programme : nom qui servira au nom du fichier texte                               #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #  un fichier texte avec la log du traitement                                           #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

# Creation LOG ----
journal <- function(nom_connexion,nom_programme) {
  
  
  assign(paste0('connexion_',nom_connexion), file(paste0(CHEMIN_LOG,nom_programme, format(Sys.time(),"%Y%m%d%H%M%S"),'.log')))
  
  # création avec la commande "sink" du fichier texte, identifié par la connexion "connexion"
  
  # par défaut, écris les output dans le fichier texte
  # ce fichier est vide
  sink(get(paste0('connexion_',nom_connexion)), append=TRUE)
  
  # on précise qu'on veut obtenir les messages de console
  # le fichier reste vide
  sink(get(paste0('connexion_',nom_connexion)), append=TRUE, type="message")
  }



