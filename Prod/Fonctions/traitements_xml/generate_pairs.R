#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                     generate_pairs                                        #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  #  Cette fonction permet le Calcul des paires d'indexes consécutifs associés aux balises #
#  # délimitant le split                                                                    #
#  #                                                                                        #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  d_lines   : le dataframe issu du xml a decouper                                       #
#  #  delims    : le delimiter identifie                                                    #
#                                                                                           #
## En sortie :                                                                              #
#   #   les paires d'indices permettant de decouper                                         #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#

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