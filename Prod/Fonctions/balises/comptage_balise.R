
#-------------------------------------------------------#
#                                                       #
#                                                       #
#                                                       #
#                comptage_balise.R                      #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

## Contexte : 
# Fonction Fabrique le referentiel (pubmed/desc/supp/...)
# Scan un repertoire contenant les .RDS  
# En sortie : Ecrit le referentiel avec les types de balises identifiees

## Description parameters : 
# nom_chemin,
# id_fic,
# nom_output

comptage_balise <- function(nom_chemin,id_fic,nom_output) {

  #### Comptage des balises  
  
  ## on liste l'ensemble des fichiers RDS présents dans le repertoire
  liste_fic <- list.files(nom_chemin, pattern = "*.RDS")
  
  ## nombre de fichier à traiter
  nb_fic <- length(liste_fic)
  
  ## on va compter sur chaque fichier puis aggréger
  for (n_fic in 1:nb_fic) {
    
    ## on identifie le fichier à lire
    nom_fic <- liste_fic[n_fic]  
    
    ## on lit le RDS
    temp <- readRDS(paste0(nom_chemin,nom_fic))
    
    ## on aggrege au niveau de la publication
    cpt <- temp %>% group_by(get(id_fic),Parent,Nom_balise) %>%
      summarise(nb=n())
    
    ## on aggrege au niveau du couple Parent, Nom_balise
    cpt2 <- cpt %>% group_by(Parent,Nom_balise) %>%
      summarise(nb_publi = n(), nb_tot=sum(nb), min = min(nb), max = max(nb))
    
    cpt2$nom_fic <- nom_fic
    
    ## on stocke le résultat
    if (n_fic == 1) { res_tot <- cpt2} else {res_tot <- rbind(res_tot,cpt2)}
    
    
  }
  
  
  ## on aggrege 
  res_tot_agg <- res_tot %>% group_by(Parent,Nom_balise) %>%
    summarise(nb_fic = n(), nb_tot_agg=sum(nb_tot), min = min(min), max = max(max))
  
  #### qualification des balises
  
  ## on compte le nombre d'éléments traités
  nb_element <- max(res_tot_agg[(res_tot_agg$min == 1 & res_tot_agg$max == 1),]$nb_tot_agg)
  
  ## on pre-qualifie les balises
  # [ajout] "NA" au lieu de NA
  res_tot_agg$type_balise <- "NA"
  ## les balises simples 
  ## on initialise à balise simple chemin
  res_tot_agg[(res_tot_agg$min == 1 & res_tot_agg$max == 1),]$type_balise <- "simple_chemin"
  ## les dates
  ## de manière générale
  res_tot_agg[(res_tot_agg$min == 1 & res_tot_agg$max == 1) 
              & grepl("Date",res_tot_agg$Parent),]$type_balise <- "simple_date"
  ## cas particuliers : PubDate
  res_tot_agg[(res_tot_agg$min == 1 & res_tot_agg$max == 1) 
              & res_tot_agg$Parent == "PubDate",]$type_balise <- "simple_PubDate"
  
  ## les balise non significatives
  res_tot_agg[(res_tot_agg$min == 1 & res_tot_agg$max == 1) 
              & res_tot_agg$nb_tot_agg < nb_element * tx_balise_NS,]$type_balise <- "simple_non_significative"
  
  ## les balises erronnées  
  res_tot_agg[(res_tot_agg$min == 1 & res_tot_agg$max == 1) 
              & (res_tot_agg$Parent %in% liste_balises_erronnees 
                 | res_tot_agg$Nom_balise %in% liste_balises_erronnees),]$type_balise <- "simple_erronnee"
  
  ## les balises multiples 
  ## on initialise à balise multiple
  res_tot_agg[!(res_tot_agg$min == 1 & res_tot_agg$max == 1),]$type_balise <- "multiple"
  ## les balises erronnées  
  res_tot_agg[!(res_tot_agg$min == 1 & res_tot_agg$max == 1) 
              & (res_tot_agg$Parent %in% liste_balises_erronnees 
                 | res_tot_agg$Nom_balise %in% liste_balises_erronnees),]$type_balise <- "multiple_erronnee"
  
  #### on identifie les nouvelles balises   
  
  ## on lit le fichier de référence
  liste_balise_hist <- read.csv2(paste0(chemin_output_ref_comptage,nom_output,".csv"))  
  
  ## on ne garde que les données qui nous inétresse
  liste_balise_hist <- liste_balise_hist %>% select(Parent,Nom_balise,type_balise) %>%
    rename(type_balise_old = type_balise)
  
  ## on initialise le champs Nouvelle_valeur à "NON"
  liste_balise_hist$Nouvelle_valeur <- "NON"
  
  ## on joint avec le référentiel actuel
  res_tot_agg <- res_tot_agg %>% 
    left_join(liste_balise_hist,by=c("Parent","Nom_balise"))
  res_tot_agg$Nouvelle_valeur <- ifelse(is.na(res_tot_agg$Nouvelle_valeur),"OUI",liste_balise_hist$Nouvelle_valeur)
  
  ## on sauvegarde le résultat
  ## on archive l'ancienne version
  file.rename(from = paste0(chemin_output_ref_comptage, nom_output,".csv"), 
              to = paste0(chemin_output_ref_comptage, nom_output,"_",format(Sys.time(),"%Y%m%d%H%M%S"),".csv"))
  
  ## on exporte la nouvelle
  write.table(res_tot_agg, 
              paste0(chemin_output_ref_comptage,nom_output,".csv"), 
              row.names = FALSE, 
              sep = ";")
}


