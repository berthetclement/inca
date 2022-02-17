#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   initialize_df_record                                    #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  # Cette fonction Initialise un data frame vide avec 6 colonnes                           #
#  #  Nom_balise, Parent, Chemin, Profondeur, Valeur, Attribut                              #                                                         #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #                                                                                        #
#  # pas de parametre                                                                       #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #  un data.frame vide                                                                   #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#
## Initialise un data frame vide avec 6 colonnes Nom_balise, Parent, Chemin, Profondeur, Valeur, Attribut


initialize_df_record <- function(){

  df_record = data.frame( "Nom_balise" = character(), "Parent" = character()
					    , "Chemin" = character(), "Profondeur" = integer()
						, "Valeur" = character(), "Attribut" = character()
						)

  return(df_record)
}
