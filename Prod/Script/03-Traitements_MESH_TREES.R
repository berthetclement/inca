

#-------------------------------------------------------#
#                                                       #
#       03-Traitements_MESH_TREES.R                     #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


##
# Utilisation d'un referentiel (fichier) 
# Le fichier est present dans le dossier /Input
##

# 0 - Creation d'une log 
journal("03-Traitements_MESH_TREES","03-Traitements_MESH_TREES")

print("***********************************************")
print("*** Programme : 03-Traitements_MESH_TREES.R ***")
print("***********************************************")
print(as.character(Sys.time()))
cat("\n")

# 1 - Chargement fichier
path <- paste0(chemin_input, nom_fichier_mesh_trees)
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
write.table(fic_mesh_tree, paste0(chemin_output_trees, "mesh_trees.csv"), sep = ";", row.names = FALSE)


# TO LOG
path <- paste0(chemin_output_trees, "mesh_trees.csv")
if(file.exists(path)){
  text <- paste0("Export du fichier ", path, " : [OK]")
  print(text)
} 

cat("\n")
sink()



