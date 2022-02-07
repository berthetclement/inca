#-------------------------------------------------------#
#                                                       #
#         03-definition_fonction_new_fn_niv_1.r         #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

# creation et mise en forme d'un data frame 

# fonction pour ecriture
new_fn_niv_1 <- function(chil,i) {
  
  if (xml_length(chil[i]) == 0) { 
    tableau_df <- as.data.frame(
      cbind(xml_name(chil[i]),
            xml_name(xml_parent(chil[i])),
            xml_path(chil[i]),
            0, # profondeur
            xml_text(chil[i]),
            xml_attr(chil[i], attr= "UI", default = NA)
      ),
      stringsAsFactors=FALSE)
    
    names(tableau_df) <- c("Nom_balise","Parent","Chemin","Profondeur","Valeur", "Attribut")
    
  } else {tableau_df <- NULL}
  
  return(tableau_df)
}
