#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   read_file_by_line                                       #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction permet de lire un fichier xml ligne par ligne                          #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  dir_input   : repertoire du fichier xml a lire                                        #
#  #  file_input  : fichier xml a lire                                                      #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #   un dataframe qui reprend le fichier lu                                              #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


## Lit un fichier ligne par ligne et récupère le résultat dans data_lines
read_file_by_line <- function(dir_input, file_input){
  
  data_lines = ""
  
  if(dir.exists(dir_input)){
    input_fullname = paste0(dir_input,file_input)
    if(file.exists(input_fullname)){
      con = file(input_fullname, "r", blocking = FALSE)
      data_lines = readLines(con)
      close(con)
    }else{
      print("Le fichier n'existe pas dans le répertoire donné en entrée.")
    }
  }else{
    print("Le répertoire donné en entrée n'existe pas.")
  }
  
  return(data_lines)
}