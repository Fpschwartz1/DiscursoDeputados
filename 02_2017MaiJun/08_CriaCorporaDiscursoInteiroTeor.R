source("05_EncodeDecode.R")
source("07_CorporaRetiraQuadrosFiguras.R")

for(ano in 2003:2017){
  print(paste("Início:", ano))
  
  # marcador de inicio e fim da figura
  ini <- "010009000003"
  fim <- "ffff030000000000"
  
  if(ano == 2003){
    ini <- "0105000002000000"
    fim <- "FFFF030000000000\\}\\}"
  }

  if(ano == 2007){
    ini <- "010009000003"
    fim <- "030000000000\\}"
  }

  if(ano == 2009){
    ini <- "010009000003"
    fim <- "FFFF030000000000"
  }
  
  arquivo <- paste0("..\\..\\Dados\\discurso_", ano,"_dit.csv")
  discursos <- read.csv2(arquivo, sep=";", colClasses = "character")
  
  fileConn <- paste0("..\\..\\Corpora\\Discursos_",ano,".txt")
  
  for(i in 1:nrow(discursos)){

        # retira discursos 'sujos' com excesso de caracteres de controle
    if( (ano == 2012) & (i %in% 6862:6879) ) next
    
    if(!is.na(discursos$Discurso[i]) & (discursos$Discurso[i] != "")){
      
      discurso <- decode_rtf(discursos$Discurso[i])
      
      # if(grepl("possam alimentar os rebanhos de suínos e aves", discurso)) break #
      
      discurso <- retira_fig(discurso, ini, fim)
     
      write(discurso, fileConn, append = TRUE, sep="\n")
    
    }
  }

  print(paste("Fim:", ano))
}
