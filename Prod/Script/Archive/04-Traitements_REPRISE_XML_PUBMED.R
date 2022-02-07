
#-------------------------------------------------------#
#                                                       #
#       04-Traitements_REPRISE_XML_PUBMED.R             #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#

##
# Le programme se base sur le fichier de suivi /Prod/Output/Suivi_id_PUBMED.csv
#  1 - Si "fetch_id" == "FALSE" il doit etre repris
##

# 0 - Creation d'une log ----
journal("04-Traitements_REPRISE_XML_PUBMED","04-Traitements_REPRISE_XML_PUBMED")

print("*******************************************************")
print("*** Programme : 04-Traitements_REPRISE_XML_PUBMED.R ***")
print("*******************************************************")
print(as.character(Sys.time()))
cat("\n")

# Lecture fichier de suvi 

fic <- read.csv2("Prod/Output/Suivi_id_PUBMED.csv")

# pas de reprise ----
if(all(fic$fetch_id)){
  # TO LOG
  text <- paste0("Nombre d'ID pubmed correctement chargé : "
                 , length(fic$fetch_id))
  print(text)
  text <- paste0("Nombre d'ID en base : ",
                 length(fic$recherche_id))
  print(text)
  print("Aucune reprise à prévoir")
}else{
  # reprise ----
  
  # 1 - selection des id a reprendre 
  df_list_id_reprise <- fic %>% filter(fetch_id %in% FALSE)
  
  # 2 - ecriture du fichier de suivi des reprises
  write.table(df_list_id_reprise, 
              file = paste0(chemin_output_reprise, "List_id_reprise.csv"), 
              sep = ";", 
              row.names = FALSE)
  
    # /!\ reprise si non NCT ? /!\
  list_id_reprise <- fic %>% 
    filter(fetch_id %in% FALSE) %>% 
    pull(recherche_id)
  
  # 3 - FETCH ----
  full_xml_reprise <- fetch_reprise(list_id_reprise, step_by= 300, db_name= "pubmed", parse=FALSE)
  
  ok = XML::xmlToList(full_xml_reprise[[1]])
  lapply(ok, function(x){
    x$MedlineCitation$PMID$text})
  
  # 4 - test des id fetch + maj fichier de suivi global ----
  test_id_fetch_reprise(full_fetch_object = full_xml_reprise, 
                        path_dir_out = chemin_output_reprise, 
                        df_id_reprise = df_list_id_reprise, 
                        name_file_out = nom_fichier_reprises_id)
  
  
  # 5 - Traitements fichiers XML ----
  traitements_xml(full_xml_reprise, chemin_output_reprise)
  
  # 6 - Jointure entre le fichier de suivi des ID fetch reprises ----
    # et le fichier de control des ID avec presence NCT (temporairement dans /Output)
  suivi_id_fetch_reprise <- read.csv2(paste0(chemin_output_reprise, nom_fichier_reprises_id))
  suivi_id_nct <- read.csv2(paste0(chemin_output, nom_fichier_suivi_nct))
  
  # jointure
  suivi_global_reprise <- left_join(suivi_id_fetch_reprise, suivi_id_nct)
  
  # ecriture (ecrasement)
  write.table(suivi_global_reprise, paste0(chemin_output_reprise, nom_fichier_reprises_id), row.names = FALSE, sep = ";")
  
  # 6 - Suppression ----
  # suppression du fichier de suivi des NCT 
  if(file.exists(paste0(chemin_output, nom_fichier_suivi_nct))){
    file.remove(paste0(chemin_output, nom_fichier_suivi_nct))
  }
  
  # 7 - Jointure/MAJ du suivi id pubmed avec le suivi id reprise
  filtre <- fic$recherche_id %in% df_list_id_reprise$recherche_id
  fic[filtre , ]$fetch_id <- suivi_global_reprise$fetch_id
  
  # maj du fichier suivi id pubmed
  write.table(suivi_global_pubmed, paste0(chemin_output, "Suivi_id_PUBMED_test.csv"), row.names = FALSE, sep = ";")
  
}




sink()