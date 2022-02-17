#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   write_file_by_line                                      #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction permet d'ecrire un fichier xml ligne par ligne                         #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  data        : dataframe a exporter                                                    #
#  #  dir_input   : repertoire du fichier xml a ecrire                                      #
#  #  file_input  : fichier xml a lire                                                      #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #   un fichier xml qui reflete le dataframe                                             #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


## Ecrit data dans un fichier ligne par ligne
write_file_by_line <- function(data, dir_output, file_output){
  
  if(dir.exists(dir_output)){
    output_fullname = paste0(dir_output,file_output)
    con = file(output_fullname, "w", blocking = FALSE)
    writeLines(data, con = con, sep = "", useBytes = FALSE)
    close(con)
  }
  
}
