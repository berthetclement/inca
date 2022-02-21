#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   write_data_check_to_csv                                 #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction ecrit un data frame dt dans un fichier filename situé dans le          #
#  #  répertoire dir_file                                                                   #                   #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  # dt        : le dataframe a exporter                                                    #
#  # dir_file  : le répertoire ou l'on veut exporter                                        #
#  # filename  : le nom du fichier de l'export                                              #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #  un fichier csv avec les donnees exportees                                            #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


write_data_check_to_csv <- function(dt, dir_file, filename){
  
  fullname_file = paste0(dir_file, filename)
  write.table(dt, fullname_file, sep = ";", append = TRUE, fileEncoding = "utf-8", row.names = FALSE, col.names = !file.exists(fullname_file))
}
