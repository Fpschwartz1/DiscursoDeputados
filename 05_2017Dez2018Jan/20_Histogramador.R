# pacotes
if(!require(stringr)) { install.packages('stringr') }
if(!require(stringi)) { install.packages('stringi') }
# if(!require(ggplot2)) { install.packages('ggplot2') }

source("..\\02_2017MaiJun\\05_EncodeDecode.R")

# conta ocorrências do tema em cada discurso no período ini-fim
freq_discurso <- function(tema, ini, fim, partido, codigoFase=NULL){
  # ini: data inicial dd/mm/aaaa
  # fim: data final dd/mm/aaaa
  # partido: partido cujos discursos serão utilizados no histograma
  # codigoFase: PE - Pequeno Expediente, GE - Grande Expediente, ...
  
  ini <- as.Date(ini, "%d/%m/%Y")
  fim <- as.Date(fim, "%d/%m/%Y")
  
  print(sprintf("Partido: %s (%s - %s)", partido, ini, fim))
  
  # lê arquivo com todos os discursos do corpora
  pastaorig <- "..\\CorporaRDS\\"
  discursos <- readRDS(paste0(pastaorig, "discurso_2000_2017.rds"))
  discursos$dataSessao <- as.Date(discursos$dataSessao, "%d/%m/%Y")
  names(discursos)[1] <- "seq"
  
  # se o vetor de código das fases das sessões for nulo, 
  # carrega com todos os códigos da base: "AB" "BC" "CG" "EN" "GE" "HO" "OD" "PE"
  if(is.null(codigoFase)){
    codigoFase <- levels(as.factor(discursos$codigoFase))
  }
  
  # filtra conjunto de discursos por critérios
  discursos <- discursos[  discursos$dataSessao >= ini
                         & discursos$dataSessao <= fim
                         & discursos$partidoOrador == partido
                         & discursos$codigoFase %in% codigoFase
                         , c("seq", "dataSessao")]

  discursos$ano <- str_sub(discursos$dataSessao, 1, 4)
  discursos$AnoSeq <- paste0(discursos$ano, str_sub(paste0('00000', discursos$seq), -5))

  # recupera inteiro teor do discurso
  anos <- levels(as.factor(discursos$ano))
  discursos_it <- NULL
  for(ano in anos){
    arq <- paste0(pastaorig, "discurso_", ano,"_dit.rds")
    discurso_ano <- readRDS(arq)
    discurso_ano <- discurso_ano[discurso_ano$AnoSeq %in% discursos$AnoSeq, ]

    discursos_it <- rbind(discursos_it, discurso_ano)
  }
  discursos <- merge(discursos, discursos_it, by.x = "AnoSeq", by.y = "AnoSeq")
  
  rm(discursos_it, discurso_ano)

  # calcula frequência do tema em cada discurso
  discursos$freq <- 0
  n <- nrow(discursos)
  for(i in 1:n){

    if(!is.na(discursos$Discurso[i]) & (discursos$Discurso[i] != "")){
      discurso <- str_to_lower(decode_rtf(discursos$Discurso[i]))
      discursos$freq[i] <- str_count(discurso, tema)
    }

  }

  # converte DataHora para o formato "%d/%m/%Y %H:%M:%S"
  discursos$DataHora <- strptime(discursos$DataHora, "%d/%m/%Y %H:%M:%S")
  
  # substitui NAs coluna dataSessao
  ind <- is.na(discursos$DataHora)
  discursos$DataHora[ind] <-     
    strptime(paste0(str_sub(discursos$dataSessao[ind], 9, 10),"/",
                    str_sub(discursos$dataSessao[ind], 6, 7),"/",
                    str_sub(discursos$dataSessao[ind], 1, 4),
                    " 00:00:01"
                   ),
             "%d/%m/%Y %H:%M:%S")
  # ordena por DataHora crescente
  discursos <- discursos[order(discursos$DataHora),]
  
  list(discursos, ini, fim)
}

histograma <- function(freq_disc, intervalo_classe = "sem"){
  # freq_disc: lista com data.frame, ini e fim resultantes da função freq_discurso
  # intervalo_classe: "dia", "sem", "mes", "ano"

  inc <- c(1, 7, 30, 60, 90, 120, 365*2)
  names(inc) <- c("dia", "sem", "mes", "bim", "tri", "qua", "ano")
  
  inc <- inc[intervalo_classe]

  ini <- freq_disc[[2]]
  fim <- freq_disc[[3]]

  n <- as.integer(ceiling((fim - ini) / inc))

  histog <- vector("integer", n)
  
  for(i in 0:n){
    f <- freq_disc[[1]][freq_disc[[1]]$dataSessao >= ini & freq_disc[[1]]$dataSessao < ini + inc, "freq"]
    histog[i] <- sum(f)
    
    ini <- ini + inc
  }

  histog
}


comparatermo_distfreq <- function(tema, ini, fim, 
                                 partidos=c('PT', 'PSDB'), cores=c('red', 'skyblue'),
                                 codigoFase=NULL,
                                 breaksP1="Sturges",
                                 breaksP2="Sturges"){

  ano <- str_sub(ini, 7, 10)
  
  # recupera discursos do partido no período 
  # e calcula a frequência do tema em cada discurso
  freqP1 <- freq_discurso(tema, ini, fim, partidos[1], codigoFase)
  freqP2 <- freq_discurso(tema, ini, fim, partidos[2], codigoFase)

  # plota a frequência dos discursos no tempo
  plot(freqP1[[1]]$DataHora, freqP1[[1]]$freq, type='l', col=cores[1],
       xlab='Tempo',ylab='Frequência',main=paste("Tema", tema, "-", ano))
  lines(freqP2[[1]]$DataHora, freqP2[[1]]$freq, col=cores[2])
  grid()
  # http://www.sthda.com/english/wiki/add-legends-to-plots-in-r-software-the-easiest-way
  legend('topright', legend=partidos, col=cores, lty=c(1:1), lwd=c(5,5))
  
  par(mfrow=c(2,2), cex = 0.7)
  
  # determina a frequência do tema para cada dia do período
  hP1 <- histograma(freqP1, 'dia')
  hP2 <- histograma(freqP2, 'dia')
  
  # histograma
  hist(hP2,col=cores[2], border=F, main='', breaks=breaksP2,
       xlab='Frequência do tema por dia no período', ylab='Frequência')
  hist(hP1,add=T,col=scales::alpha(cores[1],.7),border=F, breaks=breaksP1)
  legend('right', legend=partidos, col=cores, lty=c(1:1), lwd=c(5,5))
  box()
  # densidade de probabilidade
  d1 <- density(hP1)
  d2 <- density(hP2)
  plot(d2, main='', xlab='Frequência do tema por dia no período', ylab='Densidade')
  polygon(d2, col=cores[2], border="blue")
  lines(d1)
  polygon(d1, col=scales::alpha(cores[1],.7), border="blue")
  legend('right', legend=partidos, col=cores, lty=c(1:1), lwd=c(5,5))
  
  # retira dias com frequência igual a zero
  hP1 <- hP1[hP1 > 0]
  hP2 <- hP2[hP2 > 0]
  
  # histograma
  hist(hP2,col=cores[2],border=F, main='', breaks=breaksP2,
       xlab='Frequência do tema por dia no período', ylab='Frequência')
  hist(hP1,add=T,col=scales::alpha(cores[1],.7),border=F, breaks=breaksP1)
  legend('right', legend=partidos, col=cores, lty=c(1:1), lwd=c(5,5))
  box()
  # densidade de probabilidade
  d1 <- density(hP1)
  d2 <- density(hP2)
  plot(d2, main='', xlab='Frequência do tema por dia no período', ylab='Densidade')
  polygon(d2, col=cores[2], border="blue")
  lines(d1)
  polygon(d1, col=scales::alpha(cores[1],.7), border="blue")
  legend('right', legend=partidos, col=cores, lty=c(1:1), lwd=c(5,5))
  
  par(mfrow=c(1,1), cex = .8)
  title(paste0("(a) Distribuição de frequências do tema ", tema, " - ", ano, ": inclui dias com zero ocorrência.\n\n"))
  par(mfrow=c(2,1), cex = .8)
  title(paste0("(b) Distribuição de frequências do tema ", tema, " - ", ano, ": desconsidera dias com zero ocorrência.\n\n"))
  
  par(mfrow=c(1,1), cex = 1)
}


# temas dos quadros 4.1 e 4.2
# "corrupção", "educação/ensino médio", "reforma da previdência", "direito da mulher"

comparatermo_distfreq('corrupção', '01/01/2016', '31/12/2016')
comparatermo_distfreq('educação', '01/01/2016', '31/12/2016')
comparatermo_distfreq('previdência', '01/01/2016', '31/12/2016', breaksP1=100)
comparatermo_distfreq('mulher', '01/01/2016', '31/12/2016', breaksP1=100)





