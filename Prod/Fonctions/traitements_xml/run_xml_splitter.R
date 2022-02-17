#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                      run_xml_splitter                                     #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction permet le lancement globale du decoupage d'un fichier XML              #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  dir_input   : le repertoire des donnees en entree                                     #
#  #  file_input  : le fichier XML a decouper                                               #
#  #  dir_output  : le repertoire de sortie                                                 #
## En sortie :                                                                              #
#   #   X fichiers XML extraits du fichier XML initial                                      #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


run_xml_splitter <- function(dir_input, file_input, dir_output){
  
  print("Lecture des données")
  xml_lines = read_file_by_line(dir_input, file_input)
  generate_xml_splitted_by_loop(xml_lines, dir_output)
  
}
