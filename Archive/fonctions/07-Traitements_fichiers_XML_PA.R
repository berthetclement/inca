
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
fic <- xml2::read_xml("Prod/Input/pa2022.xml")
chemin_pa_rds <- paste0(chemin_output, "pa_rds/")
# Traitement des fichiers SUPP
traitements_xml_supp(full_xml_database = fic
                     ,chemin = chemin_pa_rds
                     ,nom = "pa_lot_"
                     ,nom_parent_id="DescriptorReferredTo"
                     ,nom_balise_id="DescriptorUI")



sink()




