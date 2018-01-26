source("22_TesteHipotese.R")

## apostila
# qui_quadrado_cont(matrix(c(25,45,15,25,10,30),3,2))
## livro
# X2 <- qui_quadrado_cont(matrix(c(8, 4667, 15820, 14287181),2,2))
# pchisq(X2, 1, lower.tail=FALSE)
# qchisq(0.05, 1, lower.tail=FALSE)
## livro
# qui_quadrado_cont(matrix(c(59,6,8,570934),2,2))

library(stringr)

# partidos
# https://www.suapesquisa.com/partidos/
partidos <- c("PCDOB", "PMDB", "PSDB", "PSOL", "PT", "PTB", "PV")

# carregar coalizões
coalizoes <- read.csv("coalizoes.csv", sep=";")
# anos eleitorais
anos <- c("2006", "2010", "2014")

# considerar coalizões em anos eleitorais
mcoa <- matrix(0, length(partidos), length(anos))
rownames(mcoa) <- partidos
colnames(mcoa) <- anos
# cria matriz de coalizões
for(i in partidos){
  for(j in anos){
    mcoa[i, j] <- mean(coalizoes[  str_to_upper(coalizoes$Partido) == i
                            & coalizoes$Ano == j,
                            "flagCoalizao"
                            ])
  }
}
mcoa <- mcoa > 0

#####################################
# constrói tabelas de dissimilaridade
#####################################
# Executa teste qui-quadrado para avaliação de similaridade
# Aqui a medida de similaridade é efetuada em corpus homogêneos (discurso parlamentar)
# Rejeitar Ho (p < 0.05) significa dissimilaridade
#####################################
# qtd de termos comparados
n <- 500
# lista com tabelas de dissimilaridade
ltdis <- vector("list", length(anos))
names(ltdis) <- anos
# para cada ano
for(ano in anos) {
  # lista de data.frames com discursos partido-ano
  ldfpa <- vector("list", length(partidos))
  names(ldfpa) <- partidos
  
  for(partido in partidos){
    ldfpa[[partido]] <- readRDS(paste0("..\\CorporaRDS\\corpora_", partido, "_", ano, "_", ano, "_limpo.rds"))
  }
  
  # quantidade de partidos
  np <- length(partidos)
  
  # matriz de dissimilaridade
  mdis <- matrix(0, np, np)
  rownames(mdis) <- colnames(mdis) <- partidos
  
  # atribui 1 para a diagonal
  for(i in 1:nrow(mdis)) mdis[i,i] <- 1
  
  for(i in 1:(nrow(mdis)-1)){
    for(j in (i+1):nrow(mdis)){
      mdis[i, j] <- corpus_similaridade(ldfpa[[partidos[i]]]$bigramas,
                                        ldfpa[[partidos[j]]]$bigramas,
                                        nrow(ldfpa[[partidos[i]]]$bigramas),
                                        nrow(ldfpa[[partidos[j]]]$bigramas),
                                        n)[2]
      mdis[i, j] <- mdis[j, i] <- round(mdis[i, j],5)
      
    }
  }

  # maiúsculo significa coalizão
  rownames(mdis)[!mcoa[,ano]] <- colnames(mdis)[!mcoa[,ano]] <- str_to_lower(partidos[!mcoa[,ano]])

  #########################################
  # indicadores de similaridade de discurso
  #########################################
  
  # similiridade na coalizão
  icoa <- vector("numeric",np)
  for(l in 1:np){
    if(mcoa[l,ano]){
      aux <- mdis[l,][-l]
      icoa[l] <- mean(aux[mcoa[,ano][-l]])
    } else {
      icoa[l] <- NA
    } 
  }
  icoa
  
  # similiridade na oposição
  iopo <- vector("numeric",np)
  for(l in 1:np){
    if(!mcoa[l,ano]){
      aux <- mdis[l,][-l]
      iopo[l] <- mean(aux[!mcoa[,ano][-l]])
    } else {
      iopo[l] <- NA
    } 
  }
  iopo
  
  # similiridade entre coalizão e oposição
  ico <- vector("numeric",np)
  for(l in 1:np){
    if(mcoa[l,ano]){ # partido de coalizão?
      # determina média dos partidos de oposição    
      ico[l] <- mean(mdis[l,!mcoa[,ano]])
    } else { # partido de oposição?
      ico[l] <- mean(mdis[l,mcoa[,ano]])
    } 
  }
  ico
  
  mdis <- cbind(mdis, icoa, iopo, ico)
    
  ltdis[[ano]] <- mdis

}



  




#############################
# Verificação de collocations
#############################
bigramasPT <- testa_collocations(PT$bigramas, PT$tfq, PT$ntokens, 20)
bigramasPSDB <- testa_collocations(PSDB$bigramas, PSDB$tfq, PSDB$ntokens, 20)
bigramasPMDB <- testa_collocations(PMDB$bigramas, PMDB$tfq, PMDB$ntokens, 20)
bigramasPSOL <- testa_collocations(PSOL$bigramas, PSOL$tfq, PSOL$ntokens, 20)
bigramasPCDOB <- testa_collocations(PCDOB$bigramas, PCDOB$tfq, PCDOB$ntokens, 20)
bigramasPTB <- testa_collocations(PTB$bigramas, PTB$tfq, PTB$ntokens, 20)


# teste chi
ano <- 2010
PT <- readRDS(paste0("..\\CorpusRDS\\corpus_PT_", ano, "_", ano, "_limpo.rds"))
PSDB <- readRDS(paste0("..\\CorpusRDS\\corpus_PSDB_", ano, "_", ano, "_limpo.rds"))
PMDB <- readRDS(paste0("..\\CorpusRDS\\corpus_PMDB_", ano, "_", ano, "_limpo.rds"))
PSOL <- readRDS(paste0("..\\CorpusRDS\\corpus_PSOL_", ano, "_", ano, "_limpo.rds"))
PCDOB <- readRDS(paste0("..\\CorpusRDS\\corpus_PCDOB_", ano, "_", ano, "_limpo.rds"))
PTB <- readRDS(paste0("..\\CorpusRDS\\corpus_PTB_", ano, "_", ano, "_limpo.rds"))


##################################################
# Medida de similaridade e homogeneidade de corpus
##################################################
# Executa teste qui-quadrado para avaliação de similaridade
# Aqui a medida de similaridade é efetuada em corpus homogêneos (discurso parlamentar)
# Rejeitar Ho (p < 0.05) significa dissimilaridade
n <- 500

# PT e PSDB
tfq1 <- PT$tfq
tfq2 <- PSDB$tfq
ntokens1 <- PT$ntokens
ntokens2 <- PSDB$ntokens
corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n)

tfq1 <- PT$bigramas
tfq2 <- PSDB$bigramas
ntokens1 <- nrow(tfq1)
ntokens2 <- nrow(tfq2)
corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n)

# PT e PMDB
tfq1 <- PT$tfq
tfq2 <- PMDB$tfq
ntokens1 <- PT$ntokens
ntokens2 <- PMDB$ntokens
corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n)

tfq1 <- PT$bigramas
tfq2 <- PMDB$bigramas
ntokens1 <- nrow(tfq1)
ntokens2 <- nrow(tfq2)
corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n)

# PT e PSOL
tfq1 <- PT$tfq
tfq2 <- PSOL$tfq
ntokens1 <- PT$ntokens
ntokens2 <- PSOL$ntokens
corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n)

tfq1 <- PT$bigramas
tfq2 <- PSOL$bigramas
ntokens1 <- nrow(tfq1)
ntokens2 <- nrow(tfq2)
corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n)

# PSDB e PSOL
tfq1 <- PSDB$tfq
tfq2 <- PSOL$tfq
ntokens1 <- PSDB$ntokens
ntokens2 <- PSOL$ntokens
corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n)

tfq1 <- PSDB$bigramas
tfq2 <- PSOL$bigramas
ntokens1 <- nrow(tfq1)
ntokens2 <- nrow(tfq2)
corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n)






