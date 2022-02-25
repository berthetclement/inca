
#-------------------------------------------------------#
#                                                       #
#                packages_init.R                        #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#                                                       #
#-------------------------------------------------------#




# Construction de la liste des packages necessaires au projet 
  # ne pas executer sur machine cliente

# # liste des packages identifies pour le projet
# list_pckg <- c("rentrez", "XML", "xml2", "data.table", "dplyr", "tidyr", "stringr", "odbc", "DBI", "RPostgreSQL","lubridate")
# 
# # liste les packages installes sur la machine
# inst_pckg <- as.data.frame(installed.packages())
# 
# # recuperer informations des packages du projet
# target_packg <- inst_pckg %>%
#   filter(Package %in% list_pckg) %>%
#   select(Package, Version, Suggests, Depends, Imports)
# 
# # ecriture du fichier en INPUT
# write.table(target_packg, file = "Prod/Input/list_package_projet.csv", sep = ";", col.names = TRUE, row.names = FALSE)


#-----------------------#
#    FONCTIONS UTILES   #
#-----------------------#

# installation et check (sans prise en compte de la version, la derniere dispo sur cran par defaut)
check_install_pckg <- function(name_package){
  if (!require(name_package, character.only = TRUE)){
    # installation
    install.packages(name_package, dependencies =TRUE)
    
    # verification installation
    if(!require(name_package, character.only = TRUE)) 
      stop("Package not found")
  }
}


install_pckg_version <- function(df_packages){
  nrow <- dim(df_packages)[1]
  for(i in seq(1, nrow)){
    if (!require(df_packages$Package[i], character.only = TRUE)){
      # installation
        remotes::install_version(df_packages$Package[i], 
                                 version = df_packages$Version[i], 
                                 dependencies =TRUE, 
                                 upgrade = FALSE)
  
      # verification installation
      if(!require(df_packages$Package[i], character.only = TRUE)) 
        stop("Package not found")
    }
  }
}

#-----------------------#
#    INSTALLATION       #
#-----------------------#

# etape 1 : intall remote pour prise en charge des versions 
check_install_pckg("remotes")
list_pckg <- read.csv2("Prod/Input/list_package_projet.csv")

# etape 2 : installation des packages avec versions specifiques
  # pb de complation package XML 
  # install_pckg_version(list_pckg)

names_pckg <- list_pckg$Package
lapply(names_pckg, check_install_pckg)


