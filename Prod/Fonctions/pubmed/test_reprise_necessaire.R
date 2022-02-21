#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   test_reprise_necessaire                                 #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  # Cette fonction a pour vocation a tester la necessité de travailler une publication     #
#  #  presente dans un XML. Elle intervient en cas de reprise                               #      
#  #                                                                                        #
#                                                                                           #
## Parametres en entrees :                                                                  #
#  #  id_a_charger    : liste des publications restants a charger                           #
#  #  file_unique_xml : donnee xml "enfant" issu du lot a charger et liee a une publication #
#  #                                                                                        #
#                                                                                           #
## En sortie :                                                                              #
#   #                                                                                       #
#   #   renvoie un booleen : 1 publication a charger 0 publication a ne pas charger         #
#   #                                                                                       #
#   #                                                                                       #
#   #                                                                                       #
#                                                                                           #
#-------------------------------------------------------------------------------------------#


test_reprise_necessaire <- function (id_a_charger,file_unique_xml) {
  ## on se positionne au niveau PubmedArticle
  N1 <- xml_children(file_unique_xml)[1]
  ## on récupère la valeur du PMID
  N2 <- xml_text(xml_children(N1)[1])
  ## on teste la présence dans les fichiers à intégrer
  test <- N2 %in% id_a_charger
  
  return(test)
}