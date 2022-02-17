#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                               get_header_footer_delimiters                                #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction permet le Calcul des balises footer, header et des balises             #
#  # délimitant le split                                                                    #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  d_lines   : le dataframe issu du xml a decouper                                       #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #   une liste avec les differents elements                                              #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#



## Calcul des balises footer, header et des balises délimitant le split
get_header_footer_delimiters <- function(d_lines){
  
  len_d_lines = length(d_lines)
  
  footer_tag = d_lines[len_d_lines] # </SupplementalRecordSet>
  
  footer_open_tag = str_replace(footer_tag,"/","") # <SupplementalRecordSet 
  idx_start_tag_delimiter = min(str_which(d_lines,str_replace_all(footer_open_tag,">",""))) # idx 3
  header_tag_elts = d_lines[1:idx_start_tag_delimiter] # 1:3
  header_tag = paste(header_tag_elts, collapse = "\n") # Ligne1 \n Ligne2 \n Ligne3
  
  delimiter = d_lines[idx_start_tag_delimiter+1] # Ligne4
  regex_delim = str_replace(trimws(delimiter), pattern = "( .*)" , replacement = " .*>") # <SupplementalRecord SRCCLASSE = "1"> -> <SupplementalRecord .*>
  idx_regex_delim = str_which(d_lines, regex_delim)
  delimiters = unique(d_lines[idx_regex_delim])
  
  return(list("header" = header_tag, "footer" = footer_tag, "delimiters" = delimiters))
}
