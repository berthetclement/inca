


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

