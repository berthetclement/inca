#-------------------------------------------------------#
#                                                       #
#            03-definition_fonction_fetchAPI.r          #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#


# Decoupe avec une valeur de pas les id telecharges (fetch) 
# Retourne un objet liste contenant les lots (multiple fichiers xml)

fetchAPI <- function(search_object, pos_start, pos_stop, step_by, db_name, web_histo= NULL, parse=FALSE){
  if(all(class(search_object) %in% c("esearch", "list"))){
    cat("\nTotal ID : ", search_object$count, "\n")
    longueur <- pos_stop-pos_start+1
    cat("\nTotal ID fetch: ", longueur, "\n")
    recs <- list()
    i=1
    for( seq_start in seq(pos_start,pos_stop,step_by)){
      recs[[i]] <- entrez_fetch(db=db_name, 
                                web_history=web_histo,
                                rettype="xml", 
                                retmax=step_by, 
                                retstart=seq_start-1,
                                parsed = parse)
      i=i+1
      # Sys.sleep(10)
      # cat(recs, file="ouput_xml.fasta", append=TRUE)
      cat(seq_start+(step_by-1), "sequences downloaded\r")
    }
  }else 
    stop("put result object from entrez_search function")
  
  return(recs)
  
}