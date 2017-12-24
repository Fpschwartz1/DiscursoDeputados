
qui_quadrado <- function(tbl_cont){
  # tbl_cont: tabela de contingência
  
  # dimensões da matriz
  d <- dim(tbl_cont)
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
  sum(X2)
}

tbl_contingencia <- function(){
  
  
  
}




# apostila
qui_quadrado(matrix(c(25,45,15,25,10,30),3,2))
# livro
X2 <- qui_quadrado(matrix(c(8, 4667, 15820, 14287181),2,2))
pchisq(X2, 1, lower.tail=FALSE)
qchisq(0.05, 1, lower.tail=FALSE)
# livro
qui_quadrado(matrix(c(59,6,8,570934),2,2))
