library(stringr)
source("22_TesteHipotese.R")

## exemplo usado no relatório posdoc
qui_quadrado_cont(matrix(c(25, 45, 15, 25, 10, 30), ncol=2, byrow = TRUE))

## Tabela 5.3 do relatório posdoc
df <- readRDS("..\\CorpusRDS\\corpus_PT_2016_2016_limpo.rds")
# tabela de contingência
tc <- matrix(0, 2, 2)
# celula11
tc[1,1] <- df$bigramas$n[df$bigramas$bigram == 'ensino medio']
# celula12
tc[1,2] <- df$tfq$FREQ[df$tfq$WORD == 'medio'] - df$bigramas$n[df$bigramas$bigram == 'ensino medio']
# celula21
tc[2,1] <- df$tfq$FREQ[df$tfq$WORD == 'ensino'] - df$bigramas$n[df$bigramas$bigram == 'ensino medio']
# celula22
df$ntokens - tc[1,2] - tc[2,1]
# qui-qudrado
qui_quadrado_cont(tc)


## livro MANNING e SCHÜTZE (1999) 
X2 <- qui_quadrado_cont(matrix(c(8, 4667, 15820, 14287181),2,2))
qchisq(0.05, 1, lower.tail=FALSE)
pchisq(X2, 1, lower.tail=FALSE)

## livro MANNING e SCHÜTZE (1999), pg. 171
qui_quadrado_cont(matrix(c(59,6,8,570934),2,2))


#############################
# Verificação de collocations
#############################
ano <- 2016
PT <- readRDS(paste0("..\\CorpusRDS\\corpus_PT_", ano, "_", ano, "_limpo.rds"))
PSDB <- readRDS(paste0("..\\CorpusRDS\\corpus_PSDB_", ano, "_", ano, "_limpo.rds"))
PMDB <- readRDS(paste0("..\\CorpusRDS\\corpus_PMDB_", ano, "_", ano, "_limpo.rds"))
PSOL <- readRDS(paste0("..\\CorpusRDS\\corpus_PSOL_", ano, "_", ano, "_limpo.rds"))
PCDOB <- readRDS(paste0("..\\CorpusRDS\\corpus_PCDOB_", ano, "_", ano, "_limpo.rds"))
PTB <- readRDS(paste0("..\\CorpusRDS\\corpus_PTB_", ano, "_", ano, "_limpo.rds"))

bigramasPT <- testa_collocations(PT$bigramas, PT$tfq, PT$ntokens, 20)
bigramasPSDB <- testa_collocations(PSDB$bigramas, PSDB$tfq, PSDB$ntokens, 20)
bigramasPMDB <- testa_collocations(PMDB$bigramas, PMDB$tfq, PMDB$ntokens, 20)
bigramasPSOL <- testa_collocations(PSOL$bigramas, PSOL$tfq, PSOL$ntokens, 20)
bigramasPCDOB <- testa_collocations(PCDOB$bigramas, PCDOB$tfq, PCDOB$ntokens, 20)
bigramasPTB <- testa_collocations(PTB$bigramas, PTB$tfq, PTB$ntokens, 20)

##################################################
# Medida de similaridade e homogeneidade de corpus
##################################################
# Executa teste qui-quadrado para avaliação de similaridade
# Aqui a medida de similaridade é efetuada em corpus homogêneos (discurso parlamentar)
# Rejeitar Ho (p < 0.05) significa dissimilaridade
lp <- list(PT, PSDB, PMDB, PSOL, PCDOB, PTB)
names(lp) <- c("PT", "PSDB", "PMDB", "PSOL", "PCDOB", "PTB")

# partidos
# |T, PSDB, PMDB, PSOL, PCDOB, PTB
mp <- matrix(
    c("PT", "PSDB", "PT", "PMDB", "PT", "PSOL", "PT", "PCDOB", "PT", "PTB",
      "PSDB", "PMDB", "PSDB", "PSOL", "PSDB", "PCDOB", "PSDB", "PTB",
      "PMDB", "PSOL", "PMDB", "PCDOB", "PMDB", "PTB",
      "PSOL", "PCDOB", "PSOL", "PTB",
      "PCDOB", "PTB"),
    ncol = 2,
    byrow = TRUE
)

# Tabela 
n <- 500
df <- NULL
for(i in 1:nrow(mp)){

  tfq1 <- lp[[mp[i,1]]]$tfq
  tfq2 <- lp[[mp[i,2]]]$tfq
  ntokens1 <- lp[[mp[i,1]]]$ntokens
  ntokens2 <- lp[[mp[i,2]]]$ntokens
  uni <- corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n)
  uniHo <- 'aceita Ho'
  if(uni[2] < 0.05) uniHo <- 'rejeita Ho'
  
  
  tfq1 <- lp[[mp[i,1]]]$bigramas
  tfq2 <- lp[[mp[i,2]]]$bigramas
  ntokens1 <- nrow(tfq1)
  ntokens2 <- nrow(tfq2)
  big <- corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n)
  bigHo <- 'aceita Ho'
  if(big[2] < 0.05) bigHo <- 'rejeita Ho'
  
  df <- rbind(df, data.frame(partido1=mp[i,1], partido2=mp[i,2], 
                             uni_X2=uni[1], uni_p=uni[2], uniHo = uniHo,
                             big_X2=big[1], big_p=big[2], bigHo = bigHo))
}

# ver temas 
li <- c(6,13)
for(i in li){
  tfq1 <- lp[[mp[i,1]]]$tfq
  tfq2 <- lp[[mp[i,2]]]$tfq
  ntokens1 <- lp[[mp[i,1]]]$ntokens
  ntokens2 <- lp[[mp[i,2]]]$ntokens
  corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n, TRUE)

  tfq1 <- lp[[mp[i,1]]]$bigramas
  tfq2 <- lp[[mp[i,2]]]$bigramas
  ntokens1 <- nrow(tfq1)
  ntokens2 <- nrow(tfq2)
  corpus_similaridade(tfq1, tfq2, ntokens1, ntokens2, n, TRUE)
}




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



  














