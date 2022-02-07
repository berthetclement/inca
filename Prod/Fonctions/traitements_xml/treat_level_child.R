## Traite un niveau d'arboresence du .xml pour un enregistrement donné


treat_level_child <- function(level_child, nb_cols_expected){
  
  df_level_child = data.frame()
  
  if(exists(paste0("children_",level_child))){
    enfants = get(paste0("children_",level_child))
    enfants_xml_length_0 = enfants[xml_length(enfants) == 0]
	len_enfants_xml_length_0 = length(enfants_xml_length_0)
	if(len_enfants_xml_length_0 > 0){
      lst_df_tag = lapply(1:len_enfants_xml_length_0
                        , FUN = function(idx){
                                              create_df_tag_attributes(enfants_xml_length_0[idx],level_child)
                                             }
                         )

      lst_df_tag_to_concat = lst_df_tag[lapply(lst_df_tag, length) == nb_cols_expected]
      df_level_child = do.call("rbind", lst_df_tag_to_concat)
	}
  }
  
  return(df_level_child)
}
