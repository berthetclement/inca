#-------------------------------------------------------#
#                                                       #
#     initialize_df_table_simple_mult.R                 #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

## Description parameters : 
# list_columns : liste de colonnes du data frame à initialiser

initialize_df_table_simple_mult <- function(list_columns){

  df = data.frame(matrix(character(), 0, length(list_columns), dimnames = list(c(), list_columns))
				, stringsAsFactors = FALSE
				)
	
  return(df)

}
