
#-------------------------------------------------------#
#                                                       #
#       02-Traitements_fichiers_XML_MESH.R              #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


# Le referentiel MESH est present dans le dossier /Input

# 0 - Creation d'une log ----
journal("02-Traitements_fichiers_XML_MESH"," 02-Traitements_fichiers_XML_MESH")

print("Programme: 02-Traitements_fichiers_XML_MESH")
print("Heure lancement: ")
print(as.character(Sys.time()))

# 1 - Lecture et séparation du référentiel des MESH
run_xml_splitter(dir_input = chemin_input
                 ,file_input =  nom_fic_mesh
                 ,dir_output = paste0(chemin_input,"/XML_Mesh_Splitted/")
                 ,BLOCK_SIZE = 1000
                 ,TAG_TO_DETECT = c('<DescriptorRecord DescriptorClass = "1">','<DescriptorRecord DescriptorClass = "2">','<DescriptorRecord DescriptorClass = "3">','<DescriptorRecord DescriptorClass = "4">')
                 ,HEADER_TAG = paste0('<?xml version="1.0"?>\n','<DescriptorRecordSet LanguageCode = "eng">')
                 ,FOOTER_TAG = '</DescriptorRecordSet>')


# 2 - Traitement des fichiers MESH

  ## 2-1 on liste l'ensemble des fichiers RDS présents dans le répertoire
  liste_fic <- list.files(paste0(chemin_input,"XML_Mesh_Splitted/"))
  nb_fic <- length(liste_fic)
  
  for (n_fic in 1:nb_fic) {

    ## on identifie le fichier à lire
    nom_fic <- liste_fic[n_fic]  
    
    ## on lit le fichier xml correspondant
    fic <- xml2::read_xml(paste0(chemin_input,"XML_Mesh_Splitted/",nom_fic))
    
  
    # Traitement des fichiers MESH
    traitements_xml_fic(full_xml_database=fic
                        ,chemin=chemin_mesh_rds
                        ,nom="mesh_lot_"
                        ,parent_id="DescriptorRecord"
                        ,bal_id="DescriptorUI"
                        ,name_id= "id_mesh")
    
    print(nom_fic)
    
  }

sink()




