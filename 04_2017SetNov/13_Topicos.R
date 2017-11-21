
# parâmetros da análise
ini <- 2016
fim <- 2016
partido <- "PSDB"

pasta_topicos <- "..\\Topicos\\"
arq_topicos <- paste0(pasta_topicos, "topicos_", partido, "_", ini, "_", fim, ".rds")

# se o arquivo de tópicos não existir, efetua toda a análise
if(!file.exists(arq_topicos)){
  if(!require(tm)) { install.packages('tm') }
  if(!require(qdap)) { install.packages('qdap') }
  if(!require(RWeka)) { install.packages('RWeka') }
  
  if(!require(tidyverse)) { install.packages('tidyverse') }
  if(!require(tidytext)) { install.packages('tidytext') }
  if(!require(tidyr)) { install.packages('tidyr') }
  if(!require(dplyr)) { install.packages('dplyr') }
  
  # lê arquivo de corpora 
  pasta_corpora <- "..\\CorporaRDS\\"
  arq_corpora <- paste0("corpora_", partido, "_", ini, "_", fim, "_limpo.rds")
  lista <- readRDS(paste0(pasta_corpora, arq_corpora))
  docs <- lista[[1]]
  
  # monta vetor de textots para utilização do pacote quanteda
  if(!require(quanteda)) { install.packages('quanteda') }
  
  docs <- docs$content
  n <- length(docs)
  vdisc <- vector("character", n)
  for(i in 1:n){
    vdisc[i] <- docs[[i]]$content
  }
  
  # funções do pacote quanteda
  myCorpus <- corpus(vdisc)
  myDfm <- dfm(myCorpus) # , stem = TRUE)
  ## Creating a dfm from a corpus ...
  ##    ... lowercasing
  ##    ... tokenizing
  ##    ... indexing documents
  ##    ... indexing features
  ##    ... stemming features (English)
  
  # remove termos pouco frequentes
  # http://stats.stackexchange.com/questions/160539/is-this-interpretation-of-sparsity-accurate/160599#160599
  sparsityThreshold <- round(ndoc(myDfm) * (1 - 0.99999))
  myDfm <- dfm_trim(myDfm, min_docfreq = sparsityThreshold)
  nfeature(myDfm)
  
  rm(docs, lista, myCorpus, n, sparsityThreshold, vdisc, pasta_corpora, arq_corpora)
  
  # modelo Latent Dirichlet Allocation - LDA
  if(!require(topicmodels)) { install.packages('topicmodels') }
  
  SEED <- 2010
  k <- 5
  myDfm <- quantedaformat2dtm(myDfm)
  
  # Variational Expectation Maximization - VEM
  lda <- LDA(myDfm, k, control = list(seed = SEED))
  VEM <- terms(lda, 10)
  print("VEM")
  rm(lda)
  
  # VEM - fixed
  lda = LDA(myDfm, k = k, control = list(estimate.alpha = FALSE, seed = SEED))
  VEM_fixed <- terms(lda, 10)
  print("VEM - fixed")
  rm(lda)
  
  # Gibbs
  lda = LDA(myDfm, k = k, method = "Gibbs",
            control = list(seed = SEED, burnin = 1000,
                           thin = 100, iter = 1000))
  GIBBGS <- terms(lda, 10)
  print("Gibbs")
  rm(lda)
  
  termos <- list(VEM, VEM_fixed, GIBBGS)
  
  saveRDS(termos, arq_topicos)  
}

if(!require(knitr)) { install.packages('knitr') }
if(!require(markdown)) { install.packages('markdown') }
if(!require(rmarkdown)) { install.packages('rmarkdown') }

arq_html <- paste0(pasta_topicos, "topicos_", partido, "_", ini, "_", fim, ".html")

rmarkdown::render('13_Topicos.Rmd', output_file = arq_html)


# Exemplo de clusterização
# https://rstudio-pubs-static.s3.amazonaws.com/265713_cbef910aee7642dc8b62996e38d2825d.html
