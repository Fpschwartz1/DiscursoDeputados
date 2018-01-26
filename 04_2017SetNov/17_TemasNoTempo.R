# remove todas as variáveis da memória
rm(list = ls(all = TRUE))

if(!require(stringi)) { install.packages('stringi') }

pt1 <- proc.time()

topicos_df <- data.frame(partido = NULL, ano = NULL, unig = NULL, bigr = NULL, lda = NULL)
n <- 8

for(partido in c("PT","PSDB")){
  for(ano in 2001:2017){
    
    # parâmetros
    ini <- ano
    fim <- ano

    corpus <- readRDS(paste0("..\\CorpusRDS\\corpus_", partido, "_", ini, "_", fim, "_limpo.rds"))
    topicos <- readRDS(paste0("..\\Topicos\\topicos_", partido, "_", ini, "_", fim, ".rds"))

    # unigramas mais frequentes
    unig <- as.character(corpus$freq_tdm[1:10, "WORD"])
    
    # escolhe tópico LDA (dentre os 5) que mais se assemelha a unig
    df <- data.frame(topicos)
    df <- as.matrix(df)
    lda <- df %in% unig
    lda <- matrix(lda, nrow = 10)
    lda <- colSums(lda)
    lda <- lda == max(lda)
    if(sum(lda) > 1){
      lda <- df[,lda][,1]
    } else{
      lda <- df[,lda]
    }
    lda <- stri_c_list(list(lda), sep=" ") 

    # unifica unigramas em um único vetor
    unig <- stri_c_list(list(unig), sep=" ") 
    # unifica bigramas em um único vetor
    bigr <- gsub(" ", "_", data.frame(corpus$bigramas[1:n, "bigram"])[ , "bigram"])
    bigr <- stri_c_list(list(bigr), sep=" ")

    topicos_df <- rbind(topicos_df, 
                        data.frame(partido = partido, ano = ano, unig = unig, bigr = bigr, lda = lda))
  }
}

pasta <- "..\\Topicos\\"
arq_html <- paste0(pasta, "topicos.html")
rmarkdown::render('18_TemasNoTempo.Rmd', 
                  output_file = arq_html,
                  params = list(topicos_df = topicos_df))

pt2 <- proc.time()
print(paste('Tempo de processamento:', stri_c_list(list((pt2 - pt1)[3]), sep=" ")))
