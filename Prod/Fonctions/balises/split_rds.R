#-------------------------------------------------------#
#                                                       #
#                 split_rds.R                           #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

###
## Application des regles de gestion par fichier RDS
###

split_rds <- function(obj_rds, simple_table= FALSE, name_id, referentiel){
  ##
  # Creation des regles de gestion a partir du referentiel
  ##
  
  ## balises simples
  ident_balises_simples <- referentiel %>% 
    filter(grepl("simple", type_balise) & !grepl("non_significative", type_balise))
  
  # balises simples erronees
  ident_balises_simples_err <- referentiel %>% 
    filter(grepl("simple", type_balise) & grepl("erron", type_balise))
  
  ## balises multiples
  ident_balises_mutiples <- referentiel %>% 
    filter(!(grepl("simple", type_balise) & !grepl("non_significative", type_balise)) )
  
  # balises multpiples erronees
  ident_balises_multiples_err <- referentiel %>% 
    filter(!grepl("simple", type_balise) & grepl("erron", type_balise))
  
  ## Traitements 
  var_id <- sym(name_id)
  
  if(simple_table){
    ## balisage table simple
    # table des balises simples
    fic_rds_simples <- obj_rds %>% 
      inner_join(ident_balises_simples,by=c("Nom_balise","Parent")) %>% 
      select(names(obj_rds))
    
    # gestion des dates
    fic_rds_simples <- balises_simples_dates(fic_rds_simples, var_id)
    
    # gestion tag balises erronees
    list_id_balises_err <- obj_rds %>%
      inner_join(ident_balises_simples_err,by=c("Nom_balise","Parent")) %>% 
      select(names(obj_rds)) %>% 
      pull(!!var_id)
    
    # tag + suppression des balises + suprr colone "Attribut"
    fic_rds_simples <- fic_rds_simples %>% 
      mutate(balises_error= ifelse(!!var_id %in% list_id_balises_err, TRUE, FALSE)) %>% 
      select(-Attribut)
    
    # tabulation de la table simple
    fic_rds_simples <- tidyr::pivot_wider(data = fic_rds_simples %>% 
                                            select(-c(Parent, Chemin, Profondeur)), 
                                          names_from= "Nom_balise", 
                                          values_from= "Valeur")
    return(fic_rds_simples)
  }else{
    ## balisage table multiple + suppression des balises erronees
    fic_rds_multiples <- obj_rds %>% 
      inner_join(ident_balises_mutiples,by=c("Nom_balise","Parent")) %>% 
      anti_join(ident_balises_multiples_err,by=c("Nom_balise","Parent")) %>% 
      select(names(obj_rds))
    
    return(fic_rds_multiples)
  }
  
}
