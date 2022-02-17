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
#  #   un vecteur d'element                                                                 #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #  un vecteur d'element                                                                 #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

'%!in%' <- function(x,y){
    !('%in%'(x,y))
}
