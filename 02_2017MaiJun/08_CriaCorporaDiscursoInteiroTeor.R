source("05_EncodeDecode.R")
source("07_CorporaRetiraQuadrosFiguras.R")

for(ano in 2000:2002){
  print(paste("Início:", ano))
  
  arquivo <- paste0("..\\..\\Dados\\discurso_", ano,"_dit.csv")
  discursos <- read.csv2(arquivo, sep=";", colClasses = "character")
  
  fileConn <- paste0("..\\..\\Corpora\\Discursos_",ano,".txt")
  
  for(i in 1:nrow(discursos)){

    # retira discursos 'sujos' com excesso de caracteres de controle
    if( (ano == 2012) & (i %in% 6862:6879) ) next
    
    if(!is.na(discursos$Discurso[i]) & (discursos$Discurso[i] != "")){
      
      discurso <- decode_rtf(discursos$Discurso[i])
      
      # if(grepl("possam alimentar os rebanhos de suínos e aves", discurso)) break #
      
      discurso <- retira_fig(discurso, ano)
     
      write(discurso, fileConn, append = TRUE, sep="\n")
    
    }
  }

  print(paste("Fim:", ano))
}
