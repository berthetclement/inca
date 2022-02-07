#-------------------------------------------------------#
#                                                       #
#           04-balises_simples_dates.R                  #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

## Contexte : 
# Fonction traitant les dates   
# Transforme plusieurs lignes d'une date (day-month-year) en une seule ligne
# En sortie : Pour chaque id et pour chaque type de date, la date est concatenee sur une ligne

## Description parameters : 
# referentiel : chemin complet du referentiel de comptage (ex: "file.csv") 
# name_id, 
# repertoire_in, 
# repertoire_out, 
# nom_schema, 
# nom_table

balises_simples_dates <- function(df_table_simple, name_id, ref){
  var_id <- sym(name_id)
  
  # gestion des dates
  fic_rds_simples_dates <- df_table_simple %>% 
    filter(grepl("Date", Parent))
  
  # si dates presentent
  if(nrow(fic_rds_simples_dates)>0){
    # valeurs dates (utilisation de nest)
    df_nest_date <- fic_rds_simples_dates %>% 
      select(Nom_balise, Valeur, Parent, !!var_id) %>% 
      nest(c(Nom_balise, Valeur))
    
    date_content <- t(df_nest_date$data)
    
    nb_row <- dim(df_nest_date)[1]
    
    for(i in seq(1, nb_row)){
      df_nest_date[i, "Valeur"] <- paste0(date_content[[i]]$Valeur, 
                                          collapse="-")
    }
    
    # /!\ format des dates a gerer
    
    # data frame en sortie 
    df_nest_date <- df_nest_date %>% 
      mutate(Nom_balise= Parent) %>% 
      select(-data)
    
    # suppression des lignes contenant "Date"
    fic_rds_simples <- df_table_simple %>% 
      filter(!grepl("Date", Parent)) 
    
    # RBIND 
    fic_rds_simples <- bind_rows(fic_rds_simples, df_nest_date) 
    
    return(fic_rds_simples)
  }
  
  return(df_table_simple)
}
