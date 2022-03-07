

# test 1 

library(rentrez)

so_many_snails <- entrez_search(db="pubmed", 
                                "(ClinicalTrials.gov[Secondary Source ID])", retmax=200, use_history = TRUE)

id_mise_en_forme <- paste0(so_many_snails$ids, collapse = ",")

upload <- entrez_post(db="pubmed", id=so_many_snails$ids, web_history = so_many_snails$web_history)

first <- entrez_fetch(db="pubmed", rettype="xml", web_history=upload,
                      retmax=10)

list_target <- XML::xmlToList(first)

lapply(list_target, function(x){x$MedlineCitation$PMID$text})

second <- entrez_fetch(db="pubmed", rettype="xml", file_format="xml", web_history=upload,
                       retstart=10, retmax=10)
list_target2 <- XML::xmlToList(second)

lapply(list_target2, function(x){x$MedlineCitation$PMID$text})

third <- entrez_fetch(db="pubmed", rettype="xml", file_format="xml", web_history=upload,
                      retstart=10, retmax=10)

## pubmed ----

key_term_search <- "(ClinicalTrials.gov[Secondary Source ID])"

r_search <- entrez_search(db= "pubmed", term= key_term_search, retmax= 9999999, use_history = FALSE )


c("33847874", "31584608", "30466410", "28449809") %in% r_search$ids

# une liste de NCT 
  # depart NCT00000102

list_nb <- seq(102,203)
list_nct <- paste0("NCT00000", list_nb)

requete_fetch <- paste0(list_nct, collapse = " OR ")


list_id_pubmed_nct <- entrez_search(db="pubmed", term = requete_fetch, retmax=9999999, use_history = TRUE)
list_id_pubmed_nct$ids

list_id_pubmed_nct$ids %in% r_search$ids

# epost

ids_1 <- c("30466410", "28449809")


upload <- entrez_post(db="pubmed", id=list_id_pubmed_nct$ids)
first <- entrez_fetch(db="pubmed", rettype="xml", web_history=upload,
                      retmax=9999999)
list_target <- XML::xmlToList(first)

text <- grep(pattern = "NCT", list_target, value = TRUE)

grep(pattern = "NCT[0-9]{8}", text, value = TRUE)


res_nct <- str_extract(text, pattern = "NCT[0-9]{8}")

table(res_nct)

# utilisatation classique 
fetch_data <- entrez_fetch(db="pubmed", rettype="xml", web_history=list_id_pubmed_nct$web_history,                      
                           retmax=9999999)


list_target <- XML::xmlToList(fetch_data)

text <- grep(pattern = "NCT", list_target, value = TRUE)

grep(pattern = "NCT[0-9]{8}", text, value = TRUE)


res_nct <- str_extract(text, pattern = "NCT[0-9]{8}")

table(res_nct);sum(table(res_nct))


# test ok avec debug ----


library(rentrez)
library(XML)
library(xml2)

so_many_snails <- entrez_search(db="pubmed", 
                                "(ClinicalTrials.gov[Secondary Source ID])", retmax=200)

# id_mise_en_forme <- paste0(so_many_snails$ids, collapse = ",")

upload <- entrez_post(db="pubmed", id=so_many_snails$ids)

first <- entrez_fetch(db="pubmed", rettype="xml", web_history=upload,
                      retmax=1000)

list_target <- XML::xmlToList(first)

res_test <- lapply(list_target, function(x){x$MedlineCitation$PMID$text})







