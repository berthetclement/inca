
#-------------------------------------------------------#
#                                                       #
#       01-Traitements_fichiers_XML_PUBMED.R            #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


###
# Connexion a l'API NCBI 
###

##
# Utilisation du package {rentrez} : 
#   1 - Recherches d'occurences de texte dans les publications
#   2 - Telechargement des publications pubmed au format xml
##

# 0 - Creation d'une log 
journal("01-Traitements_fichiers_XML_PUBMED","01-Traitements_fichiers_XML_PUBMED")
print(as.character(Sys.time()))

# 1 - search id pubmed with NCT 

r_search <- searchAPI(base_name= "pubmed", 
                     search_term= "(ClinicalTrials.gov[Secondary Source ID])", 
                     nb_id_max= 150000, 
                     opt_history= TRUE)

print(paste0("1 - Recherche des publications pubmed : ",
      r_search$count,
      " publications"))

# 2 - fetch des id en base 

print("2 - Telechargement des publications : ")

# Retourne une liste contenant "n" fichiers xml non parse

# stop_index_id <- r_search$count
full_recs_xml_web <- fetchAPI(search_object = r_search, pos_start = start_index_id, pos_stop = stop_index_id, step_by = step_by_id, 
                                  db_name = "pubmed", web_histo = r_search$web_history, parse = FALSE)
  


# 3 - test des id fetch ----
  # Compare les id recherches Versus les id fetch
  # Ecriture d'un fichier de suivi en OUTPUT
test_id_fetch(full_recs_xml_web, chemin_output)


# 4 - Lancement traitement fichiers xml ----
  # pour chaque lot de fichiers xml => export RDS
    # un seul data frame pour l'ensemble des fichiers n'est pas possible
  # check des id avec NCT : appel a la fonction 07-definition_foctions_check_xml.R
traitements_xml(full_recs_xml_web, chemin_pubmed_rds)


# 5 - Jointure entre le fichier de suivi des ID fetch ----
  # et le fichier de control des ID avec presence NCT 
suivi_id_fetch <- read.csv2(paste0(chemin_output, nom_fichier_suivi_id))
suivi_id_nct <- read.csv2(paste0(chemin_output, nom_fichier_suivi_nct))

# jointure
suivi_global_pubmed <- left_join(suivi_id_fetch, suivi_id_nct)

# ecriture (ecrasement)
write.table(suivi_global_pubmed, paste0(chemin_output, nom_fichier_suivi_id), row.names = FALSE, sep = ";")

# 6 - Suppression ----
  # suppression du fichier de suivi des NCT 
if(file.exists(paste0(chemin_output, nom_fichier_suivi_nct))){
  file.remove(paste0(chemin_output, nom_fichier_suivi_nct))
}


# 7 - Resume du suivi des telechargements ----
  # TO LOG 
print("*** Suivi des téléchargements : ***")
text <- paste0("Nombre de publications retenues : ", stop_index_id)
print(text)

nb_id_true_fetch <- suivi_id_fetch %>% 
  filter(fetch_id==TRUE) %>% 
  count(fetch_id) %>% 
  pull(n)
text <- paste0("Nombre de publications téléchargées : ", nb_id_true_fetch)
print(text)

if(stop_index_id==nb_id_true_fetch){
  print("Pas de reprise à faire")
}else{
  nb_id_false_fetch <- suivi_id_fetch %>% 
    filter(fetch_id==FALSE) %>% 
    count(fetch_id) %>% 
    pull(n)
  text <- paste0("Nombre d'id PUBMED à reprendre : ", nb_id_false_fetch)
  print(text)
}


# clean env ---- 
rm(full_recs_xml_web)

sink()















