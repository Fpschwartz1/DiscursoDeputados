rm(list = ls(all = TRUE))

source("..\\02_2017MaiJun\\05_EncodeDecode.R")

library(stringr)
library(XML)

# função para recuperar membros da mesa nas legislaturas de ini a fim
membros_mesa <- function(ini = 52, fim = 55){
  nomes_mesa <- NULL
  
  # recupera os nomes dos membros da Mesa
  for(leg in ini:fim){
  
    # monta a URL com base na legislatura
    url <-  paste0("https://dadosabertos.camara.leg.br/api/v2/legislaturas/", leg, "/mesa")
    
    # enquanto não conseguir ler os dados do ano/período no link, tenta novamente 
    repeat{
      data <- try(readLines(url, encoding = "UTF-8", warn = FALSE), FALSE)
      if(typeof(data) == "character") break
      print("Erro ao acessar a URL")
      Sys.sleep(0.5)
    }
    
    # recupera o nome parlamentar
    nomes <- str_split(data, '\"nome\":\"')
    nomes <- as.character(sapply(nomes[[1]], function(x){
      str_sub(x, start = 1, end = str_locate(x,'\"')[1]-1)
    }))[-1]
  
    # elimina repetições
    nomes <- as.character(levels(as.factor(nomes)))
    # ajusta caracteres de acentuação
    nomes <- enc2native(nomes)
    nomes <- str_to_lower(nomes) 
  
    nomes_mesa <- c(nomes_mesa, nomes)
    nomes_mesa <- as.character(levels(as.factor(nomes_mesa)))
    
    # Encoding(lnomes$nome)
    # enc2native(lnomes$nome)
    # enc2utf8(lnomes$nome)
    # iconv(lnomes$nome, from="UTF-8", to="latin1")
  }
  # remove plural
  nomes_mesa <- sapply(nomes_mesa, remove_plural)
  # retira acentos
  nomes_mesa <- retira_acentos(nomes_mesa)
  
  nomes_df <- data.frame(nomes = nomes_mesa)
  write.table(nomes_df, "stopwords_membros_mesa.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
  
  print('gerado arquivo stopwords_membros_mesa.txt')
}

membros_mesa()
