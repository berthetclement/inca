#-------------------------------------------------------#
#                                                       #
#                                                       #
#                                                       #
#                balisage_RDS.R                         #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

## Contexte : 
  # Fonction qui scan un repertoire contenant des .RDS 
  # Appel la fonction de decoupage en table simples/multiples : split_rds()
  # En sortie : Ecrit les tables simples/multiples sous postgres : pstgr_write_table()

## Description parameters : 
  # referentiel : chemin complet du referentiel de comptage (ex: "file.csv") 
  # name_id, 
  # repertoire_in, 
  # repertoire_out, 
  # nom_schema, 
  # nom_table

balisage_RDS <- function(referentiel, name_id, repertoire_in, repertoire_out= NULL, nom_schema, nom_table){
  # lecture referentiel valide en INPUT
  referentiel <- read.csv2(referentiel)
  
  # test si RDS en output
  ls_fic <- list.files(repertoire_in, pattern = "*.RDS")
  if(length(ls_fic)>0){
    
    nb_rds <- length(ls_fic)
    
    # bouclage
    for(i_file in seq(1, nb_rds)){
      # lecture
      df <- readRDS(paste0(repertoire_in, ls_fic[i_file]))
      
      ## SPLIT table balises simples
      fic_rds_simples <- split_rds(obj_rds = df, 
                                   simple_table = TRUE, 
                                   name_id = name_id, 
                                   referentiel = referentiel)
      
      ## SPLIT table balises multpiples
      fic_rds_multiples <- split_rds(obj_rds = df, 
                                     name_id = name_id, 
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
}
