#-------------------------------------------------------#
#                                                       #
#     15-traitements_xml.R                              #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


# Traitements fichiers xml issu d'un fichier ----
# [SORTIE] : 

traitements_xml_fic <- function(full_xml_database,chemin,nom,parent_id,bal_id, name_id){

  var_id <- sym(name_id)
  
  # init tableau final
  tableau_dt_final <- data.frame()
  
  
  nb_elements_xml<- xml_length(full_xml_database)
  
  # [test] ----
  nb_elements_xml_bloc <- 1000
  
  nb_boucle <- floor(nb_elements_xml/nb_elements_xml_bloc)

  # on gère le cas où ça tombe pile poil
  if (floor(nb_elements_xml/nb_elements_xml_bloc) == nb_elements_xml/nb_elements_xml_bloc) {nb_boucle <- nb_boucle - 1} 

  for (deb_seq in 0:nb_boucle) {
 
    fic_debut <- deb_seq * nb_elements_xml_bloc + 1
    fic_fin <- (deb_seq + 1)* nb_elements_xml_bloc
    ## on gère la dernière boucle
    if (fic_fin >nb_elements_xml) {fic_fin <- nb_elements_xml}     
    
    
    
    # boucle sur nb de fichier xml  
    for(i_file in seq(fic_debut, fic_fin)){

      # init/purge
      tableau_dt2 <- data.frame()
 
      file_unique_xml <- xml_child(full_xml_database, i_file)

      # init/purge
      tableau_df <- data.frame()
      
      ## CODE LOT 1 
      
      # obtenir les elements du fichier xml
      children_0=file_unique_xml
      
      # Detection profondeur ----
      N=0
      somme=1
      
      while (somme >0) {
        assign(paste0("children_",N+1),xml_children(get(paste0("children_",N))),envir=.GlobalEnv)
        somme=sum(xml_length(get(paste0("children_",N))))
        N=N+1
        # print(N)
      }
      
      # init data frame 
      tableau_df <- new_fn_niv_1(children_1,1)
      
      n <- length(children_0)

      
      # On définit i comme variant de 0 à N.  
      # Il n'en reste pas moins qu'on s'occupe des enfants de niveau children_1 puisque les indices utilisés 
      # dans cette boucle For sont d'expression "i+1", de sorte que lorsque i=0, on travaille bien avec j = i+1 = 1.
      for (i in 0:N){
        enfants <- xml_children(get(paste0("children_",i)))
        assign(paste0("children_",i+1),enfants) # envir=.GlobalEnv
        M <- length(get(paste0("children_",i+1)))
        
        for(j in 1:M) { 
          assign(paste0("balise_",j),enfants[j]) 
        }
        
        for(jj in 1:M){
          if (xml_length(get(paste0("balise_",jj))) == 0){
            ajout <- as.data.frame(cbind("Nom_balise"=xml_name(get(paste0("balise_",jj))),
                                         "Parent"=xml_name(xml_parent(get(paste0("balise_",jj)))),
                                         "Chemin"=xml_path(get(paste0("balise_",jj))),
                                         "Profondeur"="AAA",
                                         "Valeur"=xml_text(get(paste0("balise_",jj))),
                                         "Attribut"=xml_attr(get(paste0("balise_",jj)), attr = "UI", default = NA)
            ),
            stringsAsFactors=FALSE)
            
            if (length(ajout)==6){
              tableau_df <- rbind(tableau_df,ajout)
              tableau_df$Profondeur[tableau_df$Profondeur=="AAA"]=i+2
            }
            
          } #fin de la clause if (xml_length ...)
          
          # print(paste0(i,"_",jj))
          
        } #fin de la clause (for jj in 1:M)
        # purge des variables "balises_"
        rm(list=ls(pattern="balise_"))
        
        
      }  ## FIN CODE LOT 1
      rm(list=ls(pattern="children_"))
      
      # resultat
      tableau_dt2 <- as.data.table(rbind(tableau_dt2, tableau_df))
      tableau_dt2 <- tableau_dt2 %>% 
        filter(Profondeur != 0)
 
      # TAG ID MESH
      id_unique_file <- tableau_dt2 %>% 
        filter(Nom_balise %in% bal_id 	& Parent %in% parent_id) %>% 
        pull(Valeur)
      
      # [ajout] "id_mesh"
      tableau_dt2 <- tableau_dt2 %>% 
        mutate(!!var_id:= id_unique_file)
      
      # tableau final
      # un seul data frame final est trop lourd
      # export RDS pour un nombre donne de fichiers XML 
      
      tableau_dt_final <- as.data.table(rbind(tableau_dt_final, tableau_dt2))
      
    } # fin boucle par fichier
    
    # EXPORT RDS----
    i_lot <- format(Sys.time(),"%Y%m%d%H%M%S")
    saveRDS(tableau_dt_final, paste0(chemin, nom, i_lot, ".RDS"))
    
    # purge 
    tableau_dt_final <- data.frame()
    
    # on patiente 1s pour être sur de ne pas avoir le même nom si le fichier est très petit 
    # et que le traitement va trop vite
    Sys.sleep(1)

  } 
}
