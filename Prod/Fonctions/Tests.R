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


check_data_supp <- function(dt, horodatage, source_file){
   
  dt_check = (dt %>% group_by(id_supp) 
                %>% summarise(Nbrows = n(), Min_depth = min(Profondeur))
                %>% mutate(Test_Nbrows = Nbrows > 50, Test_Min_depth = Min_depth == 2, Date_Traitement = horodatage, XML_Source = source_file)
		        %>% select(-Nbrows,-Min_depth)
	        )
  
  return(dt_check)
}


check_data_desc <- function(dt, horodatage, source_file){
   
  dt_check = (dt %>% group_by(id_desc) 
                %>% summarise(Nbrows = n())
                %>% mutate(Test_Nbrows = Nbrows > 2000, Date_Traitement = horodatage, XML_Source = source_file)
		        %>% select(-Nbrows)
	        )
  
  return(dt_check)
}


check_data_qual <- function(dt, horodatage, source_file){
   
  dt_check = (dt %>% group_by(id_qual) 
                %>% summarise(Nbrows = n())
                %>% mutate(Test_Nbrows = Nbrows > 20, Date_Traitement = horodatage, XML_Source = source_file)
		        %>% select(-Nbrows)
	        )
  
  return(dt_check)
}


check_data_pa <- function(dt, horodatage, source_file){
   
  dt_check = (dt %>% group_by(id_pa) 
                %>% summarise(Nbrows = n())
                %>% mutate(Test_Nbrows = Nbrows > 2000, Date_Traitement = horodatage, XML_Source = source_file)
		        %>% select(-Nbrows)
	        )
  
  return(dt_check)
}

