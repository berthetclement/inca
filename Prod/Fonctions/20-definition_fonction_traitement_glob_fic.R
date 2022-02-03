
#-------------------------------------------------------#
#                                                       #
#       02-Traitements_fichiers_XML_MESH.R              #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

traitement_glob_fic <- function (dir_input, file_input, dir_output
                             ,full_xml_database, chemin, nom ,parent_id ,bal_id ,name_id) {

# 1 - Lecture et séparation du référentiel en fichiers plus petits
run_xml_splitter(dir_input = dir_input
                 ,file_input =  file_input
                 ,dir_output = dir_output
                 )


# 2 - Traitement des fichiers splitté

## 2-1 on liste l'ensemble des fichiers RDS présents dans le répertoire
liste_fic <- list.files(dir_output)
nb_fic <- length(liste_fic)

for (n_fic in 1:nb_fic) {
  
  ## on identifie le fichier à lire
  nom_fic <- liste_fic[n_fic]  
  
  ## on lit le fichier xml correspondant
  fic <- xml2::read_xml(paste0(dir_output,nom_fic))
  
  
  # Traitement des fichiers MESH
  traitements_xml_fic(full_xml_database=fic
                      ,chemin=chemin
                      ,nom=nom
                      ,parent_id=parent_id
                      ,bal_id=bal_id
                      ,name_id= name_id)
  

  
  print(nom_fic)
  
}


}


