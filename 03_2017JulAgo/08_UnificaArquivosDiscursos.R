source("..\\02_2017MaiJun\\05_EncodeDecode.R")
source("..\\02_2017MaiJun\\07_CorporaRetiraQuadrosFiguras.R")

library(stringr)

discursos <- NULL

ini <- 2000
fim <- 2017

# lê arquivos "discurso_AAAA.csv" e consolida em um só
for(ano in ini:fim){

  print(ano)
  
  arquivo <- paste0("..\\..\\Dados\\discurso_", ano,".csv")
  discurso <- read.csv2(arquivo, sep=";", colClasses = "character")
  
  discurso$tipoSessao <- str_trim(discurso$tipoSessao)
  discurso$codigoFase <- str_trim(discurso$codigoFase)
  discurso$descricaoFase <- str_trim(discurso$descricaoFase)
  discurso$partidoOrador <- str_trim(discurso$partidoOrador)

  discursos <- rbind(discursos, discurso)
}

# grava arquivo consolidado
system.time(saveRDS(discursos, paste0("..\\DadosRDS\\discurso_",ini,"_",fim,".rds")))

# converte arquivos "discurso_AAAA_dit.csv" para RDS
for(ano in ini:fim){

  print(ano)
  
  arquivo <- paste0("..\\..\\Dados\\discurso_", ano, "_dit.csv")
  discurso <- read.csv2(arquivo, sep=";", colClasses = "character")
  saveRDS(discurso, paste0("..\\DadosRDS\\discurso_",ano, "_dit.rds"))  
  
}
