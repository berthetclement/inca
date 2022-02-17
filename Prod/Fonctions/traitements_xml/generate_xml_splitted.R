#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                     generate_xml_splitted                                 #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction permet l'ecriture dans file_output des données de d_lines pour         #
#  # une paire d'indexes consécutifs Calcul des paires d'indexes consécutifs associés       #
#  # aux balises                                                                            #    
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  d_lines     : le dataframe issu du xml a decouper                                     #
#  #  pair        : les indices de debut et fin du decoupage                                #
#  #  dir_output  : le repertoire de sortie                                                 #
#  #  file_output : le nom du fichier de sortie                                             #
#  #  header      : le header du fichier XML de sortie                                      #
#  #  footer      : le footer du fichier XML de sorti                                       #
#                                                                                           #
## En sortie :                                                                              #
#   #   un fichier XML extrait du fichier XML initial                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

 
generate_xml_splitted <- function(d_lines, pair, dir_output, file_output, header, footer){
  
  unlist_pair = unlist(pair)
  from = unlist_pair[1]
  to = unlist_pair[2] - 1
  d_lines_filtered = d_lines[from:to]
  
  xml_data = paste(header, paste(d_lines_filtered, collapse = '\n'), footer, sep = "\n")
  
  write_file_by_line(xml_data, dir_output, file_output)
}
