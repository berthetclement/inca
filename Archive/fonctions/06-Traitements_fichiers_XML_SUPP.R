
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
journal("03-Traitements_fichiers_XML_SUPP"," 02-Traitements_fichiers_XML_SUPP")

print("Programme: 03-Traitements_fichiers_XML_SUPP")
print("Heure lancement: ")
print(as.character(Sys.time()))

# Lecture fichier referentiel MESH
# fic <- xml2::read_xml(paste0(chemin_input, nom_fic_mesh_test))

## on liste l'ensemble des fichiers RDS présents dans le répertoire
liste_fic <- list.files(paste0(chemin_input,"XML_Splitted/"))

## nombre de fichier à traiter
nb_fic <- length(liste_fic)

## on va compter sur chaque fichier puis aggréger
for (n_fic in 1:nb_fic) {

  ## on identifie le fichier à lire
  nom_fic <- liste_fic[n_fic]  
  
  ## on lit le fichier xml correspondant
  fic <- xml2::read_xml(paste0(chemin_input,"XML_Splitted/",nom_fic))


chemin_supp_rds <- paste0(chemin_output, "supp_rds/")
# Traitement des fichiers SUPP
traitements_xml_supp(full_xml_database=fic
                     ,chemin=chemin_supp_rds
                     ,nom="supp_lot_"
                     ,parent_id="SupplementalRecord"
                     ,bal_id="SupplementalRecordUI")

print(n_fic)

}

sink()




