#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   Lancement_tree                                          #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction lance toute la récupération des tree :                                 #
#  #    1) lecture du fichier plat                                                          #      
#  #    2) structuration                                                                    #   
#  #    3) remontee sous postgre                                                            #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #                                                                              ,         #
#  # Pas de parametres                                                                      #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #  Donnees remontees sous Postgre dans la table tree                                    #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


Lancement_tree <- function() {

# On trace l'heure du début de l'étape  
heure_debut <- Sys.time() 

# 0 - Creation d'une log 
journal("Traitements_MESH_TREES","Traitements_MESH_TREES")

print("***********************************************")
print("*** Programme :    Traitements_MESH_TREES.R ***")
print("***********************************************")
print(as.character(Sys.time()))
cat("\n")

# 1 - Chargement fichier
path <- paste0(DIR_INPUT_DATA, NOM_FICHIER_MESH_TREES)
fic_mesh_tree <- read.delim(file = path, header = FALSE, dec = ",", sep = ";")

# TO LOG
if(exists("fic_mesh_tree")){
  text <- paste0("Chargement du fichier ", path, " : [OK]")
  print(text)
  cat("\n")
} 

# rename colonnes
names(fic_mesh_tree) <- c("name", "tree_code")

# AJOUT categories racines
  # non presentent dans le fichier d'origine

new_names <- c(
  "All MeSH Categories", "0",
  "Anatomy", "A",
  "Organisms", "B",
  "Diseases", "C",
  "Chemicals and Drugs", "D",
  "Analytical, Diagnostic and Therapeutic Techniques, and Equipment", "E",
  "Psychiatry and Psychology", "F",
  "Phenomena and Processes" ,"G",
  "Disciplines and Occupations", "H",
  "Anthropology, Education, Sociology, and Social Phenomena", "I",
  "Technology, Industry, and Agriculture" ,"J",
  "Humanities", "K",
  "Information Science", "L",
  "Named Groups", "M",
  "Health Care" ,"N",
  "Publication Characteristics", "V",
  "Geographicals", "Z"
)

len_list <- length(new_names)
index_name <- seq(1, len_list, by =2)
new_df <- data.frame(name= new_names[index_name], tree_code= new_names[-index_name])

# concatenation 
fic_mesh_tree <- rbind(fic_mesh_tree, new_df)

# tri 
fic_mesh_tree <- fic_mesh_tree[order(fic_mesh_tree$tree_code),]
row.names(fic_mesh_tree) <- 1:nrow(fic_mesh_tree)

# creation de niveaux (nouvelles colonnes) pour chaque tree code 
split_code_df <- as.data.table(str_split_fixed(fic_mesh_tree$tree_code, "\\.", n = Inf))

dim_col <- dim(split_code_df)[2]
colnames <- paste0("Niveau_", seq(1, dim_col))
names(split_code_df) <- colnames

# un code par colonne 
fic_mesh_tree <- cbind(fic_mesh_tree, split_code_df)

# TO LOG
print("Aperçu fichier mesh_trees: ")
print(fic_mesh_tree[1:3,])
cat("\n")

# EXPORT ----
write.table(fic_mesh_tree, paste0(CHEMIN_OUPUT_TREES, "mesh_trees.csv"), sep = ";", row.names = FALSE)


# TO LOG
path <- paste0(CHEMIN_OUPUT_TREES, "mesh_trees.csv")
if(file.exists(path)){
  text <- paste0("Export du fichier ", path, " : [OK]")
  print(text)
} 

cat("\n")

## remontee des donnees sous postgre
print(paste0("Remontee des donnees sous postgre: ",Sys.time()))
RPostgreSQL::dbWriteTable(con, 
                          name=c("pubmed_tmp", "tree"), 
                          value = fic_mesh_tree, 
                          append = FALSE, 
                          row.names=FALSE)

print(paste0("Fin de l'intégration des données tree: ",Sys.time()))

## on ferme la log
  sink()
  
  # fin timer du programme
  df_temp <- calcul_temps_trt(fullname_file = paste0(CHEMIN_TPS_TRAITEMENT,FILE_TPS_TRAITEMENT),
                              label = 'Lancement tree ',
                              heure_debut = heure_debut
  ) 

}

