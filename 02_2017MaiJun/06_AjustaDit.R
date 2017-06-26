source("05_EncodeDecode.R")

str_retirar <- function(texto){
  texto <- substr(texto, 1, 100)
  loc <- str_locate_all(texto, '\\}')[[1]]
  retirar <- ""
  if(nrow(loc) > 0){
    retirar <- substr(texto, 1, loc[nrow(loc), ncol(loc)])
    loc <- str_locate_all(retirar, '\\{')[[1]]
    for(l in 1:nrow(loc)){
      retirar <- paste0(substr(retirar, 1, loc[l, 1]-1), '\\',
                        substr(retirar, loc[l, 1], str_length(retirar)))
      loc <- loc + 1
    }
    loc <- str_locate_all(retirar, '\\}')[[1]]
    for(l in 1:nrow(loc)){
      retirar <- paste0(substr(retirar, 1, loc[l, 1]-1), '\\',
                        substr(retirar, loc[l, 1], str_length(retirar)))
      loc <- loc + 1
    }
  }
  retirar
}

for(ano in 2017){
  arquivo <- paste0("..\\..\\Dados\\discurso_", ano,"_dit.csv")
  discursos <- read.csv2(arquivo, sep=";", header = FALSE, colClasses = "character")
  
  colnames(discursos) <- c("AnoSeq", "DataHora", "Discurso")
  
  # retirar informações de formatação do texto como
  # exemplo: "\\{\\{ MS Sans Serif;\\}\\{ Symbol;\\}\\{ MS Sans Serif;\\}\\{ Arial;\\}\\}\\{;\\}"
  
  for(i in 1:nrow(discursos)){
    if(!is.na(discursos$Discurso[i]) & (discursos$Discurso[i] != "")){
      discurso <- decode_rtf(discursos$Discurso[i])
      discurso <- gsub("\\*", "", discurso)
      discurso <- gsub("\\\\", "", discurso)
      discurso <- gsub('\"', "'", discurso)
      
      discurso <- gsub(str_retirar(discurso), "", discurso)
      
      discursos$Discurso[i] <- encode_rtf(discurso)
    }
  }
  
  #for(i in 1:nrow(discursos)){
  #  if(!is.na(discursos$Discurso[i]) & (discursos$Discurso[i] != "")){
  #    discurso <- decode_rtf(discursos$Discurso[i])
  #    if(substr(discurso,1,1) == '{'){
  #      print(discurso)
  #    }
  #  }
  #}
  
  # grava o último bloco de linhas no arquivo
  write.table(x=discursos, sep=";",
              file=arquivo,
              row.names=FALSE)
  
  print(ano)
}