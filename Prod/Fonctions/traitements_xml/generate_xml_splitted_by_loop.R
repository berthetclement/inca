#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                 generate_xml_splitted_by_loop                             #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction permet le Calcul des paires d'indexes consécutifs associés aux balises #
#  # délimitant le split                                                                    #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  d_lines     : le dataframe issu du xml a decouper                                     #
#  #  dir_output  : le repertoire de sortie                                                 #
## En sortie :                                                                              #
#   #   X fichiers XML extraits du fichier XML initial                                      #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

generate_xml_splitted_by_loop <- function(d_lines, dir_output){
  
  print("Calcul de la balise header et de la balise footer")
  tags = get_header_footer_delimiters(d_lines)
  
  print("Génération des paires")
  delim_pairs = generate_pairs(d_lines, tags$delimiters)
  print(paste(length(delim_pairs),"fichiers à générer"))
  
  print("Split des données et écriture dans un .xml spécifique")  
  lapply(1:length(delim_pairs), 
         FUN = function(i){
           print(paste("Fichier :",i))
           generate_xml_splitted(d_lines, delim_pairs[i], dir_output, paste0("split_part_",i,".xml"), tags$header, tags$footer)
         }
  )
  
}