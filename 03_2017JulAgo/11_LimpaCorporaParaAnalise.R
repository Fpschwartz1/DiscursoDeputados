# remove todas as variáveis da memória
# rm(list = ls(all = TRUE))

source("..\\02_2017MaiJun\\05_EncodeDecode.R")

# parâmetros
# ini <- 2003
# fim <- 2003
# partido <- "PT"

# pacotes
if(!require(tm)) { install.packages('tm') }
if(!require(qdap)) { install.packages('qdap') }
if(!require(stringi)) { install.packages('stringi') }
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
tm_clean <- function(corpus, stopw, stopngram){
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeNumbers, ucp=TRUE)
  corpus <- tm_map(corpus, removePunctuation, ucp=TRUE)
  
  # remove plural e retira acentos
  corpus <- tm_map(corpus, content_transformer(remove_plural))
  corpus <- tm_map(corpus, content_transformer(retira_acentos))

  # remove stopwords
  corpus <- tm_map(corpus, removeWords, stopw)
  
  # remove espaços
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, content_transformer(str_trim))
  
  # remove n-grams
  corpus <- tm_map(corpus, content_transformer(remove_ngramas), stopngram)

  # retira palavras de tamanho {1}
  corpus <- tm_map(corpus, content_transformer(function(x) gsub('\\b[a-z]{1}\\b', '', x)))
    
  # remove espaços
  corpus <- tm_map(corpus, stripWhitespace)
  corpus <- tm_map(corpus, content_transformer(str_trim))

  return(corpus)
}

remove_ngramas <- function(texto, ngramas){
  n <- length(ngramas)
  if(n >= 1){
    for(i in 1:n) {
      texto <- gsub(ngramas[i], "", texto)
      # stripWhitespace
      if(length(texto) > 0){ # se não for character(0)
        texto <- str_split(texto, ' ')[[1]]
        texto <- texto[texto != ""]
        texto <- stri_c_list(list(texto), sep=" ")
      } else {
        texto <- ""
        break
      }
    }
  }
  return(texto)
}


# profvis({ # identifica gragalos de processamento

limpa_corpora <- function(ini, fim, partido, fl_partes = FALSE){
  # ini: ano inicial
  # fim: ano final
  # partido: partido
  # fl_partes: TRUE - quando a lista de nomes está quebrada em suas partes
  
  print(paste0(partido, " - ", ini, " a ", fim))
  
  # lê arquivo com todos os discursos
  pasta <- "..\\CorporaRDS\\"
  arquivo <- paste0("corpora_", partido, "_", ini, "_", fim, ".rds")
  if(file.exists(paste0(pasta, arquivo))){
    vdisc <- readRDS(paste0(pasta, arquivo))  
  } else {
    return(FALSE)
  }

  # Para fazer um corpus volátil, R precisa interpretar cada 
  # elemento no vetor de discursos **vdisc** como um documento. 
  # O pacote **tm** fornece as chamadas funções de Origem para 
  # fazer essa conversão. A função de Origem chamada VectorSource()
  # é utilizada uma vez que os dados do discurso estão contidos em um vetor.
  docs <- VectorSource(vdisc)
  docs <- VCorpus(docs) # corpus volátil

  #### removendo stopwords
  stopw <- readLines("..\\03_stopwords\\stopwords_portugues.txt")
  #### removendo palavras com pouca informação
  stopw <- c(stopw, readLines("..\\03_stopwords\\stopwords_discurso.txt"))
  #### removendo partidos
  stopw <- c(stopw, readLines("..\\03_stopwords\\stopwords_partidos.txt"))
  #### removendo plural das stopwords
  stopw <- sapply(stopw, remove_plural)
  #### removendo acentos das stopwords
  stopw <- retira_acentos(stopw)
  #### retira repetições de palavras
  stopw <- as.character(levels(as.factor(stopw)))

  # removendo n-gramas: bigramas, nomes e outros
  # stopngram deve ser contruido na ordem em que está
  stopngram <- readLines("..\\03_stopwords\\stopwords_bigramas.txt")
  stopngram <- c(stopngram, readLines("..\\03_stopwords\\stopwords_membros_mesa.txt"))
  stopngram <- c(stopngram, readLines("..\\03_stopwords\\stopwords_nomes_compostos.txt"))
  stopngram <- c(stopngram, readLines("..\\03_stopwords\\stopwords_nomes_simples.txt"))
  #### removendo plural dos ngramas
  stopngram <- sapply(stopngram, remove_plural)
  #### removendo acentos dos ngramas
  stopngram <- retira_acentos(stopngram)
  #### retira repetições dos ngramas
  stopngram <- as.character(levels(as.factor(stopngram)))

  # limpeza com tm_clean
  print('limpeza do corpus')
  docs <- tm_clean(docs, stopw, stopngram)
  
  # deixando apenas os radicais das palavras
  # docs <- tm_map(docs, stemDocument, language = "portuguese")  

  # remonta o vetor de discursos após os discursos
  # terem passado pelos primeiros filtros; isso porque o pacote 
  # qdap só pode ser usado sobre vetores
  print('reconstrução do vetor de discursos')
  n <- length(docs)
  vdisc <- vector("character", n)
  for(i in 1:n){
    if(length(docs[[i]]$content) > 0){
      vdisc[i] <- docs[[i]]$content
    } else { 
      vdisc[i] <- ""
    }
  }
  vdisc <- vdisc[vdisc != ""]
  vdisc <- vdisc[!is.na(vdisc)]
  
  # reconstrução do corpus para eliminar documentos em branco
  docs <- VectorSource(vdisc)
  docs <- VCorpus(docs) # corpus volátil

  # termFreq, do pacote tm, também funciona sobre vetores,
  # porém é mais lenta que freq_terms do pacote qdap
  # system.time(tf <- termFreq(vdisc))
  # ord <- order(tf, decreasing=TRUE)
  # tf <- tf[ord[1:30]]
  # wordcloud(names(tf), tf, max.words = 20)
  
  # system.time(tfq <- freq_terms(vdisc, at.least = 3, top = 20))
  # determina termos mais frequentes com freq_terms (qdap)
  print('termos mais frequentes')
  tfq <- freq_terms(vdisc, at.least = 3, top = 2000)

  # criando uma tdm com "term frequency-inverse document frequency".
  # The TfIdf score increases by term occurrence but is penalized by
  # the frequency of appearance among all documents. From a common 
  # sense perspective, if a term appears often it must be important. 
  # This attribute is represented by term frequency (i.e. Tf), which
  # is normalized by the length of the document. However, if the term
  # appears in all documents, it is not likely to be insightful. This 
  # is captured in the inverse document frequency (i.e. Idf).
  print('aplicando a frequência inversa de documentos')
  tdm <- TermDocumentMatrix(docs, control = list(wordLengths = c(3,30), weighting = weightTfIdf))
  ntokens <- tdm$nrow
  
  # Why would you want to adjust the sparsity of the TDM/DTM?
  # TDMs and DTMs are sparse, meaning they contain mostly zeros.
  # A good TDM has between 25 and 70 terms. The lower the sparse value,
  # the more terms are kept. The closer it is to 1, the fewer are kept. 
  # This value is a percentage cutoff of zeros for each term in the TDM.
  fcz <- 0.9999 # frequência de corte de zeros: % de zeros admissível para cada termo
  tdm_aux <- removeSparseTerms(tdm, fcz)
  while(tdm_aux$nrow == tdm$nrow){
    fcz <- fcz - 0.0001
    tdm_aux <- removeSparseTerms(tdm_aux, fcz)
  }
  if(tdm_aux$nrow > 0){
    tdm <- tdm_aux
  }
  rm(tdm_aux)
  ntokens_fcz <- tdm$nrow
  tdm <- as.matrix(tdm)
  freq_tdm <- rowSums(tdm)
  freq_tdm <- sort(freq_tdm, decreasing = TRUE)[1:2000]
  freq_tdm <- data.frame(WORD = names(freq_tdm), FREQ = freq_tdm)
  

  #BigramTokenizer <- function(x){
  #    unlist(lapply(ngrams(words(x), 2), paste, collapse = " "), use.names = FALSE)
  #}
  #tdm <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
  #inspect(removeSparseTerms(tdm[, 1:10], 0.7))
  
  ###########
  # bigramas
  ###########
  print('bigramas mais frequentes')
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
  # bigramas <- bigramas[!(bigramas$bigram %in% readLines("stopbigramas_pt.txt")), ]
  
  dados <- list(docs = docs, tfq = tfq, ntokens = ntokens, bigramas = bigramas, 
                sparse_fcz = fcz, ntokens_fcz = ntokens_fcz, freq_tdm = freq_tdm)
  # tfq, ntokens e bigramas: usados para determinação de collocations e métrica de similaridade de corpus
  # freq_tdm: passou pelos filtros TfIdf e Sparse e pode ser usado para métrica de similaridade de corpus

# })

  arquivo <- paste0("corpora_", partido, "_", ini, "_", fim, "_limpo.rds")
  saveRDS(dados, paste0(pasta, arquivo))
  
  return(TRUE)
}

# remove todas as variáveis, menos os parâmetros ini, fim e partido
# rm(list = ls(all = TRUE)[!(ls(all = TRUE) %in% c("ini", "fim", "partido"))])
