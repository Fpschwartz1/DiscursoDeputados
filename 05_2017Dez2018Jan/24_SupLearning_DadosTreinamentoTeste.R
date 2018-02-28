################################################################
# cria dataframe de treinamento para aprendizagem supervisionada
# a ser processado com o pacote scikit-learn, escrito em Python
################################################################
partidos <- c("PT", "PSDB") # "PMDB", "PCDOB", "PTB")
anos <- 2015

# inicia o data.frame com a coluna discurso e uma coluna para cada partido
df_disc <- data.frame(matrix(ncol = length(partidos)+2, nrow = 0))
names(df_disc) <- c("ano", "discurso", partidos)

for(ipart in 1:length(partidos)){

  for(ano in anos){
    arquivo <- readRDS(paste0("..\\CorpusRDS\\corpus_", partidos[ipart], "_", ano, "_", ano, "_limpo.rds"))
    
    n <- length(arquivo$docs$content)
    vdisc <- vector("character", n)
    
    # carrega vetor de discursos
    for(i in 1:n){
      vdisc[i] <- arquivo$docs$content[[i]][[1]]
    }
    
    # cria matriz de indicadores iniciando com zeros
    m_indicadores <- matrix(0, n, length(partidos))
    
    # preenche a coluna do partido corrente com 1s
    m_indicadores[,ipart] <- 1
    
    df_ind <- data.frame(m_indicadores)
    df_ind <- cbind(rep(ano, n), vdisc, df_ind)
    names(df_ind) <- names(df_disc)
    
    df_disc <- rbind(df_disc, df_ind)
    
  }
}
write.csv(df_disc, paste0("..\\SupLearning\\disc_classificacao.csv"), row.names = FALSE)

################################################################
# cria dataframes de teste para aprendizagem supervisionada
# a ser processado com o pacote scikit-learn, escrito em Python
################################################################
coalizoes <- read.csv("coalizoes_consolidado.csv")
anos <- 2001:2015

for(ano in anos){
  
  partidos <- coalizoes[coalizoes$Ano == ano & coalizoes$lflCoalizao, "Partido"]
  
  # inicia o data.frame com a coluna discurso e a coluna partido
  df_disc <- data.frame(matrix(ncol = 2, nrow = 0))
  names(df_disc) <- c("partido", "discurso")
  
  for(ipart in 1:length(partidos)){
  
    arq <- paste0("..\\CorpusRDS\\corpus_", partidos[ipart], "_", ano, "_", ano, "_limpo.rds")
    
    if(file.exists(arq)){
      arquivo <- readRDS(arq)
      
      n <- length(arquivo$docs$content)
      vdisc <- vector("character", n)
      
      # carrega vetor de discursos
      for(i in 1:n){
        vdisc[i] <- arquivo$docs$content[[i]][[1]]
      }
      
      df_ind <- data.frame(partido = rep(partidos[ipart] , n), discurso = vdisc)
      
      df_disc <- rbind(df_disc, df_ind)
      
    }
    
  }
  
  write.csv(df_disc, paste0("..\\SupLearning\\coalizao_", ano, ".csv"), row.names = FALSE)
}

