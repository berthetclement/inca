##test d'import de la publication

test_reprise_necessaire <- function (id_a_charger,file_unique_xml) {
  ## on se positionne au niveau PubmedArticle
  N1 <- xml_children(file_unique_xml)[1]
  ## on récupère la valeur du PMID
  N2 <- xml_text(xml_children(N1)[1])
  ## on teste la présence dans les fichiers à intégrer
  test <- N2 %in% id_a_charger
  
  return(test)
}