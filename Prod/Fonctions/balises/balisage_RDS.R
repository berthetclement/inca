#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                                                                           #
#                                                                                           #
#                balisage_RDS.R                                                             #
#                                                                                           #
#                                                                                           #
## Contexte :                                                                               #
#  # Fonction qui scan un repertoire contenant des .RDS                                     #
#  # Appel la fonction de decoupage en table simples/multiples : split_rds()                #      
#  # En sortie : Ecrit les tables simples/multiples sous postgres : pstgr_write_table()     #
#                                                                                           #
## Description parameters :                                                                 #
#  # referentiel : chemin complet du referentiel de comptage (ex: "file.csv")               #
#  # name_id,                                                                               #
#  # repertoire_in,                                                                         #
#  # repertoire_out,                                                                        #
#  # nom_schema,                                                                            #
#  # nom_table                                                                              #
#                                                                                           #
#                                                                                           #
#                                                                                           #
#-------------------------------------------------------------------------------------------#
    
    
    ## 2 - Creation tables vides 
      # simple / multiple a partir du referentiel 
    

balisage_RDS <- function(nom_schema, nom_table){
  
  temps <- as.data.frame(Sys.time())
  write.table(temps,file=paste0(chemin_tps_traitment,'Balisage_',nom_table,'_debut.txt'), col.names = TRUE, row.names = FALSE)  
  
  # 0 - Creation d'une log 
  journal(paste0('Balisage_',nom_table),paste0('Balisage_',nom_table))
  print(as.character(Sys.time()))
  
  file_comptage = get(paste("PATH_REF_CPT", toupper(nom_table), sep = "_"))
  dir_rds = get(paste("DIR_OUTPUT_RDS", toupper(nom_table), sep = "_"))
  id_ref = paste("id", nom_table, sep = "_")
  
  # Initialisation du schéma
  pstgr_init_schema(nom_schema)
  
  # Initialisation des tables PUBMED vides
  pstgr_write_table_ref_vide(nom_schema, nom_table)
  
  # lecture referentiel valide en INPUT
  referentiel <- read.csv2(file_comptage)
  
  # test si RDS en output
  ls_fic <- list.files(dir_rds, pattern = "*.RDS")
  if(length(ls_fic)>0){
    
    nb_rds <- length(ls_fic)
    
    # bouclage
    for(i_file in seq(1, nb_rds)){
      # lecture
      df <- readRDS(paste0(dir_rds, ls_fic[i_file]))
      
      ## SPLIT table balises simples
      fic_rds_simples <- split_rds(obj_rds = df, 
                                   simple_table = TRUE, 
                                   name_id = id_ref, 
                                   referentiel = referentiel)
      
      ## SPLIT table balises multpiples
      fic_rds_multiples <- split_rds(obj_rds = df, 
                                     name_id = id_ref, 
                                     referentiel = referentiel)
      

      ## sauvegarde rds
      old_name <- tools::file_path_sans_ext(ls_fic[i_file])
      
        # save simple
      # saveRDS(fic_rds_simples, paste0(repertoire_out, old_name, "_simple",".RDS"))
      pstgr_write_table(nom_schema = nom_schema, nom_table = nom_table, data_rds = fic_rds_simples)
      
        # save multiple
      # saveRDS(fic_rds_multiples, paste0(repertoire_out, old_name, "_multiple", ".RDS"))
      nom_table_mult <- paste0(nom_table,"_mult")
      pstgr_write_table(nom_schema = nom_schema, nom_table = nom_table_mult, data_rds = fic_rds_multiples)
      
    }
    
  }else stop("Aucun fichier RDS en sortie")
  
  ## on ferme la log
  sink()
  
  # fin timer du programme
  temps <- as.data.frame(Sys.time())
  write.table(temps,file=paste0(chemin_tps_traitment,'Balisage_',nom_table,'_fin.txt'), col.names = TRUE, row.names = FALSE)  
}
