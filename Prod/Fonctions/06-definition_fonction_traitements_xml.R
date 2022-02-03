#-------------------------------------------------------#
#                                                       #
#         06-traitements_xml.R                          #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


# Traitements fichiers xml ----
  # export au format RDS un data frame contenant l'ensemble des fichiers xml d'un lot

traitements_xml <- function(id_a_charger,r_search,full_xml_database, export_path_file, i_lot){
  
  # Boucle principale : pour chaque bloc de fichiers xml
  for(nb_lot in seq(1, length(full_xml_database))){ 
    
    # init / purge
    tableau_dt_final <- data.frame()
    
    # conversion en xml node
    base_lot_1 <-read_xml(full_xml_database[[nb_lot]])
    
    # boucle sur nb de fichier xml  
    for(i_file in seq(1, xml_length(base_lot_1))){
      
      # init/purge
      tableau_dt2 <- data.frame()
      
      file_unique_xml <- xml_child(base_lot_1, i_file)
      
      ## on teste la nécessité de travailler le XML
      
      if (test_reprise_necessaire(id_a_charger,file_unique_xml) == 1) {
      
      # pour chaque branche du fichier
      for(j_branches in seq(1, xml_length(file_unique_xml))){
        
        # init/purge
        tableau_df <- data.frame()
        
        # selection de la branche 
        branche <- xml_children(file_unique_xml)[j_branches]
        
        ## CODE LOT 1 
        
        # obtenir les elements du fichier xml
        children_0=branche
        
        # Detection profondeur ----
        N=0
        somme=1
        
        while (somme >0) {
          assign(paste0("children_",N+1),xml_children(get(paste0("children_",N))) ) # ,envir=.GlobalEnv
          somme=sum(xml_length(get(paste0("children_",N))))
          N=N+1
          # print(N)
        }
        
        # init data frame 
        tableau_df <- new_fn_niv_1(children_1,1)
        
        n <- length(children_0)
        # for (ii in 2:n) {
        #   ajout<- new_fn_niv_1(children_0,ii)
        #   tableau_df <- rbind(tableau_df,ajout)
        #   tableau_df$Profondeur[tableau_df$Profondeur==0]=1
        # }
        
        # On définit i comme variant de 0 à N.  
        # Il n'en reste pas moins qu'on s'occupe des enfants de niveau children_1 puisque les indices utilisés 
        # dans cette boucle For sont d'expression "i+1", de sorte que lorsque i=0, on travaille bien avec j = i+1 = 1.
        print("DEBUT calcul balises")
        print(as.character(Sys.time()))
        for (i in 0:N){
          enfants <- xml_children(get(paste0("children_",i)))
          assign(paste0("children_",i+1),enfants) # envir=.GlobalEnv
          M <- length(get(paste0("children_",i+1)))
          
          print(paste0("generation de balises", " -- longueur children: ", M, "-- profondeur : ", N))
          for(j in 1:M) { 
            assign(paste0("balise_",j),enfants[j]) 
          }
          
          print("generation de balises")
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
            
           } #fin de la clause (for jj in 1:M)
          
          # purge des variables "balises_" 
          rm(list=ls(pattern="balise_"))
        }
        
        print("FIN calcul balises")
        print(as.character(Sys.time()))
        
        # purge des variables "balises_" / children
        rm(list=ls(pattern="balise_"))
        rm(list=ls(pattern="children_"))
        
        # resultat
        tableau_dt2 <- as.data.table(rbind(tableau_dt2, tableau_df))
        tableau_dt2 <- tableau_dt2 %>% 
          filter(Profondeur != 0)
      
        ## FIN CODE LOT 1
        
      } # fin boucle branches
      
      # tag id pubmed
        # /!\ Ne prendre que le PMID de la publication et non un PMID d'un article en citation ou commentaire /!\
      id_pubmed <- tableau_dt2 %>% 
        filter(Nom_balise %in% "PMID" & Parent %in% "MedlineCitation") %>% 
        pull(Valeur)
        # retourne "id_pubmed" character
      
      tableau_dt2 <- tableau_dt2 %>% 
        mutate(id_pubmed= id_pubmed)
  
      ## on fait les vérifications
      
      # test de bonne récupération via l'API ----
      id_search <- r_search$ids[r_search$ids %in% id_pubmed]
      if(exists("id_search")){
        df <- data.frame(recherche_id= id_search,
                         fetch_id= TRUE)
      }else{
        df <- data.frame(recherche_id= id_search,
                         fetch_id= FALSE)
      }
      

      # verifications du contenu type présence NCT ----
      # genere un fichier csv qui track la presence de NCT dans chaque publi pubmed
      res_test <- check_xml(tableau_dt2, i_lot)
      
      
      ## on reconsolide les différents tests
      
      df <- cbind(df,res_test)
      
      # ecriture fichier de suivi CSV id par id 
      write.table(df, 
                  paste0(chemin_output, nom_fichier_suivi_id), 
                  row.names = FALSE, 
                  sep = ";", 
                  append = TRUE,
                  col.names = !file.exists(paste0(chemin_output, nom_fichier_suivi_id)))
      

      # tableau final
        # un seul data frame final est trop lourd
      
      tableau_dt_final <- as.data.table(rbind(tableau_dt_final, tableau_dt2))
      }
      
    } # fin boucle par fichier
    
    ## on met un test au cas où il n'y ait aucune publication d'intégrée
    
    if (nrow(tableau_dt_final) > 0) {
    
    # EXPORTS RDS----
    nom_lot_rds <- paste0("lot_", i_lot)
    saveRDS(tableau_dt_final, paste0(export_path_file, nom_lot_rds, ".RDS"))
 
    }
  } # FIN bloc
  
  # # purge des variables "balises_" / "children_"
  # rm(list=ls(pattern="balise_"))
  # rm(list=ls(pattern="children_"))
  
}
