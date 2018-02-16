# qui_quadrado_cont: qui-quadrado para tabela de contingência
# usado para testar a independência dos termos que formam o bigrama
#   ou seja, bigramas que sejam collocations
# Ho: Não há associação entre os grupos, ou seja, as variáveis categóricas são independentes.
# H1: Há associação entre os grupos, ou seja, as variáveis categóricas são dependentes.
qui_quadrado_cont <- function(tbl_cont){
  # tbl_cont: tabela de contingência
  
  # dimensões da matriz
  d <- dim(tbl_cont)
  # graus de liberdade
  gl <- (d[1] - 1) * (d[2] - 1)
  # soma das colunas
  scol <- colSums(tbl_cont)
  # soma das linhas
  slin <- rowSums(tbl_cont)
  # tamanho da amostra
  N <- sum(scol) # ou sum(slin)
  # matriz de valores esperados
  e <- matrix(0, d[1], d[2])
  # calculo dos valores esperados
  for(i in 1:d[1]){
    for(j in 1:d[2]){
      e[i, j] <- slin[i] * scol[j] / N
    }
  }
  
  X2 <- (tbl_cont - e)^2 / e
  X2 <- sum(X2)
  c(X2, pchisq(X2, gl, lower.tail=FALSE))
}

# constrói tabela de contingência 2 x 2 para bigramas
tbl_contingencia <- function(bigramas, tfq, ntokens, n = 20){
  # bigramas: data.frame com bigramas e frequência
  # tfq: data.frame com os termos do corpus e frequência
  # ntokens: quantidade total de toquens do corpus
  # n: n primeiros bigramas
  
  # bigramas: constrói vetor de frequência nominado com os bigramas
  nomes <- bigramas$bigram[1:n]
  bigramas <- bigramas$n[1:n]
  names(bigramas) <- nomes
  # tfq: vetor de frequência dos termos constantes dos bigramas
  vtfq <- str_split_fixed(nomes, ' ', 2)
  vtfq <- as.character(levels(as.factor(c(vtfq[,1], vtfq[,2]))))
  vtfq <- tfq[tfq$WORD %in% vtfq, ]
  tfq <- vtfq$FREQ
  names(tfq) <- vtfq$WORD
  rm(vtfq)

  # constrói tabela de contingência
  n <- length(bigramas)
  l <- vector("list", n)
  for(i in 1:n){
    m <- matrix(0,2,2)
    words <- str_split(names(bigramas[i]), ' ')[[1]]

    # corpus_PT_2015_2015_limpo.rds
    #         mulher                          ~mulher
    # negra   bigrama = 314                   tfq[negra]-bigrama = 577-314
    # ~negra  tfq[mulher]-bigrama = 1364-314  ntokens - c(1,2) - c(2,1)
    m[1,1] <- bigramas[i]
    m[2,1] <- tfq[words[1]] - bigramas[i]
    m[1,2] <- tfq[words[2]] - bigramas[i]
    m[2,2] <- ntokens - m[1,2] - m[2,1]
    
    l[[i]] <- m
  }
  l
}

# corpus_similaridade: 
# Ho: As frequências observadas não diferem das frequências esperadas, 
#     isto é, não existe diferença entre as frequências (contagens) dos grupos. 
# H1: As frequências observadas são diferentes das frequências esperadas, 
#     portanto existe diferença entre as frequências dos grupos.
corpus_similaridade <- function(tfq1, tfq2, ntokens1, ntokens2, n = 500){
  # garante que os nomes das colunas sejam WORD e FREQ
  # mesmo quando são enviados bigramas
  names(tfq1) <- c("WORD", "FREQ")
  names(tfq2) <- c("WORD", "FREQ")
  
  words <- tfq1$WORD[1:n]
  words <- words[words %in% tfq2$WORD]
  
  tfq1 <- tfq1[tfq1$WORD %in% words, ]
  tfq2 <- tfq2[tfq2$WORD %in% words, ]
  
  tfq1 <- tfq1[order(tfq1$WORD), ]
  tfq2 <- tfq2[order(tfq2$WORD), ]
  
  # ow1: freq. observada da palavra no corpus 1
  # ow2: freq. observada da palavra no corpus 2
  df <- data.frame(ow1 = tfq1$FREQ, ow2 = tfq2$FREQ)
  # ew1: valor esperado da palavra no corpus 1
  df$ew1 <- (ntokens1 * (df$ow1 + df$ow2)) / (ntokens1 + ntokens2)
  # ew2: valor esperado da palavra no corpus 2
  df$ew2 <- (ntokens2 * (df$ow1 + df$ow2)) / (ntokens1 + ntokens2)
              
  X2 <- sum((df$ow1 - df$ew1)^2 / df$ew1) + sum((df$ow2 - df$ew2)^2 / df$ew2)

  gl <- length(words) - 1
  
  c(X2, pchisq(X2, gl, lower.tail=FALSE)) 
}

# verifica se os bigramas constituem collocations ou aconteceram ao acaso
# o valor esperado determinado nas tabelas de contingência pressupõe independência (Ho)
#   portanto, rejeitar Ho significa ser dependente -> collocation
testa_collocations <- function(bigramas, tfq, ntokens, n = 20, alpha = 0.05){
  # bigramas: data.frame com bigramas e frequência
  # tfq: data.frame com os termos do corpus e frequência
  # ntokens: quantidade total de toquens do corpus
  # n: n primeiros bigramas
  # alpha: nível de significância
  
  # Cria tabelas de contingência de bigramas
  tbls <- tbl_contingencia(bigramas, tfq, ntokens, n)
  # Teste qui-quadrado: rejeitar Ho (p < 0.05) significa ser dependente -> collocation
  teste <- sapply(tbls, qui_quadrado_cont)
  teste <- data.frame(bigramas = bigramas$bigram[1:n], X2 = teste[1,], p = teste[2,], collocation = teste[2,] < alpha)

  # retorna data.frame com bigramas, qui-quadrado X2, p, indicador de collocation
  teste
}


# exemplo do usado no relatório
tb_cont <- matrix(c(25, 45, 15, 25, 10, 30), ncol=2, byrow = TRUE)
qui_quadrado_cont((tb_cont))

