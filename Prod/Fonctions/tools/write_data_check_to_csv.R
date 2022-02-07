## Ecrit un data frame dt dans un fichier filename situé dans le répertoire dir_file

write_data_check_to_csv <- function(dt, dir_file, filename){
  
  fullname_file = paste0(dir_file, filename)
  write.table(dt, fullname_file, sep = ";", append = TRUE, fileEncoding = "utf-8", row.names = FALSE, col.names = !file.exists(fullname_file))
}
