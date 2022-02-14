#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   create_df_tag_attributes                                #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction ecrit dans un data frame les différents éléments d'une balise.         #
#  #  Elle intervient au point le plus profond de l'arborescence                            #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  tag_to_add : balise a analyser                                                        #
#  #  tag_depth  : profondeur ou est positionnee la balise                                  #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #  Un dataframe avec les différentes informations disponibles concernant la balise      #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#



create_df_tag_attributes <- function(tag_to_add, tag_depth){

  df_tag = as.data.frame(cbind(  "Nom_balise" = xml_name(tag_to_add)
                               , "Parent" = xml_name(xml_parent(tag_to_add))
                               , "Chemin" = xml_path(tag_to_add)
                               , "Profondeur" = tag_depth + 1
                               , "Valeur" = xml_text(tag_to_add)
                               , "Attribut" = xml_attr(tag_to_add, attr = "UI", default = NA)
                               )
						  , stringsAsFactors = FALSE
						)
  
  return(df_tag)
}