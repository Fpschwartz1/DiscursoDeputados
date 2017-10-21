source("05_EncodeDecode.R")

if(!require(qdap)) { install.packages('qdap') }

pasta <- "..\\..\\Dados\\"

# monta a string de formatacao a ser retirada
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

for(ano in c(2000,2002)){
  print(paste("Início:", ano))
  
  arquivo <- paste0(pasta, "discurso_", ano,"_dit.csv")
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
      discurso <- gsub("Helvetica-Oblique;\\}\\}\\{;\\}", "", discurso)
      
      discurso <- gsub(str_retirar(discurso), "", discurso)
      discurso <- bracketX(discurso)
      
      discursos$Discurso[i] <- encode_rtf(discurso)
    }
  }
  
  # verifica se restou algum discurso iniciado com caracteres
  # de formatação e apresenta no console para inspeção visual
  for(i in 1:nrow(discursos)){
    if(!is.na(discursos$Discurso[i]) & (discursos$Discurso[i] != "")){
      # o indicador de caracter de formtação é o '{'
      discurso <- decode_rtf(discursos$Discurso[i])
      if(substr(discurso,1,1) == '{'){
        print(paste(ano, ' - ', i))
      }
    }
  }
  
  # grava o último bloco de linhas no arquivo
  write.table(x=discursos, sep=";",
              file=arquivo,
              row.names=FALSE)
  
  print(paste("Fim:", ano))
}