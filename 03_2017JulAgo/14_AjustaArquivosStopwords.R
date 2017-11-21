rm(list = ls(all = TRUE))

source("..\\02_2017MaiJun\\05_EncodeDecode.R")

arquivo <- c(
  "stopwords_bigramas.txt",
  "stopwords_discurso.txt",
  "stopwords_nomes_compostos.txt",
  "stopwords_nomes_simples.txt",
  "stopwords_partidos.txt",
  "stopwords_portugues.txt"
)

for(arq in arquivo) {
  stopw <- readLines(arq)
  
  stopw <- as.character(levels(as.factor(stopw)))
  
  stopw <- retira_acentos(stopw)
  
  stopw <- stopw[stopw != ""]
  
  stopw <- sapply(stopw, remove_plural)
  
  write.table(stopw, arq, quote = FALSE, row.names = FALSE, col.names = FALSE)
}

