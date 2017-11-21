rm(list = ls(all = TRUE))

source("..\\02_2017MaiJun\\05_EncodeDecode.R")

library(stringr)
library(XML)

# função para recuperar membros da mesa nas legislaturas de ini a fim
# fl_partes: TRUE - quebra o nome em suas partes
membros_mesa <- function(ini = 52, fim = 55, fl_partes = FALSE){
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
  
    lnomes <- nomes
      
    ###########################################
    # usado no caso de quebrar o nome em partes
    if(fl_partes){
      # quebra o nome em suas partes: nome, nomes do meio, sobrenome
      nomes <- str_split(nomes, ' ')
      
      # cria vetor único com as partes
      lnomes <- NULL
      for(i in 1:length(nomes)){
        lnomes <- c(lnomes, nomes[[i]])
      }
    }
    ###########################################
    
    # elimina repetições
    lnomes <- as.character(levels(as.factor(lnomes)))
    # ajusta caracteres de acentuação
    lnomes <- enc2native(lnomes)
    lnomes <- str_to_lower(lnomes) 
  
    nomes_mesa <- c(nomes_mesa, lnomes)
    nomes_mesa <- as.character(levels(as.factor(nomes_mesa)))
    
    # Encoding(lnomes$nome)
    # enc2native(lnomes$nome)
    # enc2utf8(lnomes$nome)
    # iconv(lnomes$nome, from="UTF-8", to="latin1")
  }
  
  if(fl_partes){ # quebrar o nome em partes
    nomes_mesa <- nomes_mesa[nomes_mesa != "da" & nomes_mesa != "de"]
    nomes_mesa <- stri_c_list(list(nomes_mesa), sep=" ")
    nomes_mesa <- remove_plural(nomes_mesa)
    nomes_mesa <- str_split(nomes_mesa, ' ')[[1]]
  } else{ # quando NÃO quebrar o nome em partes
    nomes_mesa <- sapply(nomes_mesa, remove_plural)
  }
  
  nomes_mesa <- retira_acentos(nomes_mesa)
  
  nomes_df <- data.frame(nomes = nomes_mesa)
  write.table(nomes_df, "stopwords_membros_mesa.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
}

membros_mesa()

