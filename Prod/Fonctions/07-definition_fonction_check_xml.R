#-------------------------------------------------------#
#                                                       #
#           07-definition_foction_check_xml.R           #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#



# Verification des id exportes ----
  # 1- export csv des id (unique du lot) si il manque un id 
    # reprise avec jointure sur les id non presents
  # 2 - check si presence NCT + export fichier de suivi + (ajout tag NCT)
  

check_xml <- function(data_lot,  i_lot){

  
  # verification presence "NCT" pour chaque publication pubmed 
    # test de la présence d'une valeur contenant NCT dans la balise AccessionNumber
  Test_presence_nct <- data_lot %>% 
    filter(grepl("AccessionNumber", Nom_balise)) %>%
    filter(grepl("NCT", Valeur)) %>% 
    pull(id_pubmed)
  
  if (length(Test_presence_nct) == 0) {val_test_NCT <- FALSE} else {val_test_NCT <- TRUE}
  
  # Tag date
  date_check_nct <- as.character(Sys.time())
  
  # Tag LOT
  lot <- paste0("LOT_", i_lot)
  
  
  ## on reconsolide les tests
  res_test <- data.frame(test_NCT= val_test_NCT,
                         date_check_nct= date_check_nct,
                         lot = lot)
    
    
  return(res_test)

}













