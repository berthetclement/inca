#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                           '%!in%'                                         #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #                                                                                        #
#  # cette fonction permet de renvoyer les elements d'un vecteur qui ne sont pas dans un    #
#  # vecteur                                                                                #
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #                                                                                        #
#  #   un vecteur d'elements                                                                #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #  un vecteur d'elements                                                                #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

'%!in%' <- function(x,y){
    !('%in%'(x,y))
}
