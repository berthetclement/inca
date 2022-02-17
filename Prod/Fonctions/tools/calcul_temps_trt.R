#-------------------------------------------------------------------------------------------#
#                                                                                           #
#                                   calcul_temps_trt.R                                      #
#                                                                                           #
#                                                                                           #
## Objectif :                                                                               #
#  # Fonction qui permet de calculer le temps des traitements d'une étape                   #
#  # En début de traitementt on définit :  heure_debut <- Sys.time()                        #      
#  # Puis on execute la fonction après le traitement                                        #
#                                                                                           #
## Paramtres en entrees :                                                                   #
#  # fullname_file : chemin complet du fichier qui compliera tous les tps de traitements    #
#  # label         : le nom de l'étape                                                      #
#  # heure_debut   : date_yime du début du traitement                                       #
#                                                                                           #
## En sortie :                                                                              #
#   # # un dataframe  avec 4 colonnes (label, heure de début, heure de fin, durée en mn)    #
#   # # une ligne complémentaire dans le fichier de suivi                                   #
#   # #         ==>Le fichier s'initialise en cas de premier lancement                      #
#                                                                                           #
#-------------------------------------------------------------------------------------------#



calcul_temps_trt <- function(fullname_file,label,heure_debut) {
  
   # on cree un dataframe avec les informations necessaires
   df_temp <- data.frame(etape = label,
                         heure_debut = heure_debut,
                         heure_fin = Sys.time()
                        )
   # on calcule le temps de traitement                      
   df_temp$duree_min <- difftime(df_temp$heure_fin,df_temp$heure_debut,units = "mins")
   
   # on enrichit le fichier de suivi (ou on le cree si premier lancement)
   write.table(df_temp,
                fullname_file,
                sep = ";",
                append = TRUE,
                fileEncoding = "utf-8",
                row.names = FALSE,
                col.names = !file.exists(fullname_file))

  
 return(df_temp) 
}
  
   
