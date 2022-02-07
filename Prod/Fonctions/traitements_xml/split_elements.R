library(stringr)

BLOCK_SIZE = 1000


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


## Ecrit data dans un fichier ligne par ligne
write_file_by_line <- function(data, dir_output, file_output){
  
  if(dir.exists(dir_output)){
    output_fullname = paste0(dir_output,file_output)
    con = file(output_fullname, "w", blocking = FALSE)
    writeLines(data, con = con, sep = "", useBytes = FALSE)
    close(con)
  }
  
}


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


## Calcul des paires d'indexes consécutifs associés aux balises délimitant le split 
generate_pairs <- function(d_lines, delims){
  
  consecutive_pairs = list()
  
  len_d_lines = length(d_lines)
  # Détection de la balise TAG_TO_DETECT
  idx_start_tag = which(d_lines %in% delims)
  len_start_tag = length(idx_start_tag)
  
  if(len_start_tag >= BLOCK_SIZE){
    idx_start_tag_by_block = c(idx_start_tag[seq(1,len_start_tag,BLOCK_SIZE)],len_d_lines)
  }else if(len_start_tag < BLOCK_SIZE && len_start_tag > 0){
    idx_start_tag_by_block = c(min(idx_start_tag), len_d_lines)
  }
  
  consecutive_pairs = Map(c,idx_start_tag_by_block[-length(idx_start_tag_by_block)], idx_start_tag_by_block[-1])
  
  return(consecutive_pairs)
}


## Ecriture dans file_output des données de d_lines pour une paire d'indexes consécutifs 
generate_xml_splitted <- function(d_lines, pair, dir_output, file_output, header, footer){
  
  unlist_pair = unlist(pair)
  from = unlist_pair[1]
  to = unlist_pair[2] - 1
  d_lines_filtered = d_lines[from:to]
  
  xml_data = paste(header, paste(d_lines_filtered, collapse = '\n'), footer, sep = "\n")
  
  write_file_by_line(xml_data, dir_output, file_output)
}


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


run_xml_splitter <- function(dir_input, file_input, dir_output){
  
  print("Lecture des données")
  xml_lines = read_file_by_line(dir_input, file_input)
  generate_xml_splitted_by_loop(xml_lines, dir_output)
  
}
