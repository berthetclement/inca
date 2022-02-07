#-------------------------------------------------------#
#                                                       #
#           05-Traitements_BALISES.R                    #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#



#-------------------------------------------------------#
#           EXPLOITATION REFERENTIEL                    #
#                                                       #
#-------------------------------------------------------#

# lecture referentiel valide en INPUT
ref_balises <- read.csv2(paste0(chemin_output, 'cpt_balises_pubmed.csv'))

## Traitements des fichiers RDS ----
balisage_RDS(referentiel = ref_balises, 
             name_id = "id_pubmed",
             repertoire_in = "Prod/Output/pubmed_rds/", 
             repertoire_out = chemin_output_balises)



# MESH ----
# lecture referentiel valide en INPUT
ref_balises_mesh <- read.csv2(paste0(chemin_output, 'cpt_balises_mesh.csv'))

## Traitements des fichiers RDS ----
balisage_RDS(referentiel = ref_balises_mesh, 
             name_id = "id_mesh", 
             repertoire_in = "Prod/Output/mesh_rds/", 
             repertoire_out = "Prod/Output/balises_rds/mesh/")




