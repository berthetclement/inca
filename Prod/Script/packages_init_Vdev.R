
#-------------------------------------------------------#
#                                                       #
#                packages_init.R                        #
#                                                       #
#                                                       #
# Ce programme permet d'installer les versions          #
# utilisée lors des développements sauf pour XML        #
# XML n'est utilisé qu'en dépendance de rentrez         #
#-------------------------------------------------------#

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
      install_version(df_packages$Package[i], 
                      version = df_packages$Version[i], 
                      dependencies = TRUE, 
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
list_pckg <- read.csv2("C:\\Users\\stephane.lenoble\\Downloads\\list_package_projet.csv", stringsAsFactors = FALSE)

# etape 2 : installation des packages avec versions specifiques
# pb de compilation package XML 
# install_pckg_version(list_pckg)



names_pckg <- list_pckg$Package
lapply(names_pckg, check_install_pckg)

library(remotes)
library()
library(XML)

df_packages = list_pckg

## DBI : OK si en 2
## dplyr : OK si 5
## XML : KO ==> on passe en dernière version : 8
## xml2 : OK en 1
## odbc : OK en 3  
## RPostgreSQL : OK en 4
## stringr : OK en 6
## tidyr : OK en 7
## rentrez en 9 
## data.table en 10

#Sys.setenv(LOCAL_CPPFLAGS = "-I/mingw$(WIN)/include/libxml2")

## on installe xml2  
install_version(df_packages$Package[10], 
                version = df_packages$Version[10], 
                dependencies = TRUE, 
                upgrade = FALSE)

## DBI
install_version(df_packages$Package[2], 
                version = df_packages$Version[2], 
                dependencies = TRUE, 
                upgrade = FALSE)

## odbc
install_version(df_packages$Package[4], 
                version = df_packages$Version[4], 
                dependencies = TRUE, 
                upgrade = FALSE)


## RPostgreSQL
install_version(df_packages$Package[6], 
                version = df_packages$Version[6], 
                dependencies = TRUE, 
                upgrade = FALSE)

## dplyr
install_version(df_packages$Package[3], 
                version = df_packages$Version[3], 
                dependencies = TRUE, 
                upgrade = FALSE)

## stringr
install_version(df_packages$Package[7], 
                version = df_packages$Version[7], 
                dependencies = TRUE, 
                upgrade = FALSE)


## tidyr
install_version(df_packages$Package[8], 
                version = df_packages$Version[8], 
                dependencies = TRUE, 
                upgrade = FALSE)


## XML
# install_version(df_packages$Package[9],
#                 version = df_packages$Version[9],
#                 dependencies = TRUE,
#                 upgrade = FALSE)

install.packages(df_packages$Package[9], dependencies =TRUE)

## rentrez
install_version(df_packages$Package[5],
                version = df_packages$Version[5],
                dependencies = TRUE,
                upgrade = FALSE)

## data.table
install_version(df_packages$Package[1],
                version = df_packages$Version[1],
                dependencies = TRUE,
                upgrade = FALSE)



