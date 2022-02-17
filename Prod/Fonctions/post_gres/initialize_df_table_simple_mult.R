#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   initialize_df_table_simple_mult                         #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  # Cette fonction a pour vocation a creer un dataframe vide a partir d'une liste          #
#  # de colonnes predefinies                                                                #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # list_columns : la liste des colonnes                                                   #
#  #                                                                                        #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #   Un dataframe vide avec les colonnes demandees                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


initialize_df_table_simple_mult <- function(list_columns){

  df = data.frame(matrix(character(), 0, length(list_columns), dimnames = list(c(), list_columns))
				, stringsAsFactors = FALSE
				)
	
  return(df)

}
