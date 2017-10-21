source("..\\02_2017MaiJun\\05_EncodeDecode.R")

if(!require(tm)) { install.packages('tm') }
if(!require(qdap)) { install.packages('qdap') }
# if(!require(profvis)) { install.packages('profvis') }

if(!require(tidyverse)) { install.packages('tidyverse') }
if(!require(tidytext)) { install.packages('tidytext') }
if(!require(tidyr)) { install.packages('tidyr') }
if(!require(dplyr)) { install.packages('dplyr') }  

#####################
# funções de limpeza
#####################
# aplicada a vetores de caracteres (apenas inglês)
qdap_clean <- function(x){
  x <- replace_abbreviation(x)
  x <- replace_contraction(x)
  x <- replace_number(x)
  x <- replace_ordinal(x)
  x <- replace_ordinal(x)
  x <- replace_symbol(x)
  x <- tolower(x)
  return(x)
}      

# aplicada a corpus
tm_clean <- function(corpus, stopwords){
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, removeWords, stopwords)
  return(corpus)
}

ini <- 2003
fim <- 2016
partido <- "PT"

# profvis({ # identifica gragalos de processamento

  # lê arquivo com todos os discursos
  pasta <- "..\\CorporaRDS\\"
  arquivo <- paste0("corpora_", partido, "_", ini, "_", fim, ".rds")
  vdisc <- readRDS(paste0(pasta, arquivo))

  # Para fazer um corpus volátil, R precisa interpretar cada 
  # elemento no vetor de discursos **vdisc** como um documento. 
  # O pacote **tm** fornece as chamadas funções de Origem para 
  # fazer essa conversão. A função de Origem chamada VectorSource()
  # é utilizada uma vez que os dados do discurso estão contidos em um vetor.
  docs <- VectorSource(vdisc)
  docs <- VCorpus(docs) # corpus volátil
  
  #### removendo stopwords
  stopw <- readLines("stopwords_pt.txt")
  #### removendo palavras com pouca informação
  stopw <- c(stopw, readLines("stopwords_pt_discurso.txt"))
  #### removendo nomes
  stopw <- c(stopw, readLines("stopwords_pt_nomes.txt"))
  # retira acentos das stopwords
  stopw <- retira_acentos(stopw)
  
  # limpeza com tm_clean
  docs <- tm_clean(docs, stopw)
  
  # deixando apenas os radicais das palavras
  # docs <- tm_map(docs, stemDocument, language = "portuguese")  

  # remonta o vetor de discursos após os discursos
  # terem passado pelo filtro; isso porque o pacote 
  # qdap só pode ser usado sobre vetores
  n <- length(docs)
  vdisc <- vector("character", n)
  for(i in 1:n){
    vdisc[i] <- docs[[i]]$content
  }
  
  # termFreq, do pacote tm, também funciona sobre vetores,
  # porém é mais lenta que freq_terms do pacote qdap
  # system.time(tf <- termFreq(vdisc))
  # ord <- order(tf, decreasing=TRUE)
  # tf <- tf[ord[1:30]]
  # wordcloud(names(tf), tf, max.words = 20)
  
  # system.time(tfq <- freq_terms(vdisc, at.least = 3, top = 20))
  # determina termos mais frequentes com freq_terms (qdap)
  tfq <- freq_terms(vdisc, at.least = 3, top = 200)

  ###########
  # bigramas
  ###########
  # data frame
  bigramas <- data.frame(id_discurso = 1:length(vdisc), 
                         text = vdisc,
                         stringsAsFactors = F)
  # bigramas
  bigramas <- bigramas %>%
    unnest_tokens(bigram, text, token = "ngrams", n = 2)
  
  # ordena bigramas
  bigramas <- bigramas %>%
    dplyr::count(bigram, sort = TRUE)
  
  # remove bigramas com menos de 3 ocorrências
  bigramas <- bigramas[bigramas$n >= 3,]
  
  # remove bigramas sem informação
  bigramas <- bigramas[!(bigramas$bigram %in% readLines("stopbigramas_pt.txt")), ]
  
  dados <- list(docs, tfq, bigramas)
  
# })

arquivo <- paste0("corpora_", partido, "_", ini, "_", fim, "_limpo.rds")
saveRDS(dados, paste0(pasta, arquivo))




