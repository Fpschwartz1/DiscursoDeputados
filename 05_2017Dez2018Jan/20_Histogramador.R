# pacotes
if(!require(stringr)) { install.packages('stringr') }
if(!require(stringi)) { install.packages('stringi') }

source("..\\02_2017MaiJun\\05_EncodeDecode.R")
source("NormalCompara.R")
# source("..\\02_2017MaiJun\\07_CorporaRetiraQuadrosFiguras.R")

# conta ocorrências do tema em cada discurso no período ini-fim
freq_discurso <- function(tema, ini, fim, partido, codigoFase = c('PE', 'GE')){
  # ini: data inicial dd/mm/aaaa
  # fim: data final dd/mm/aaaa
  # partido: partido cujos discursos serão utilizados no histograma
  # codigoFase: PE - Pequeno Expediente, GE - Grande Expediente, ...
  
  ini <- as.Date(ini, "%d/%m/%Y")
  fim <- as.Date(fim, "%d/%m/%Y")
  
  print(sprintf("Partido: %s (%s - %s)", partido, ini, fim))
  
  # lê arquivo com todos os discursos
  pastaorig <- "..\\DadosRDS\\"
  discursos <- readRDS(paste0(pastaorig, "discurso_2000_2017.rds"))
  discursos$dataSessao <- as.Date(discursos$dataSessao, "%d/%m/%Y")
  names(discursos)[1] <- "seq"
  
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
      discurso <- decode_rtf(discursos$Discurso[i])
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

# previdência
freqPT <- freq_discurso('reforma da previdência', '01/01/2003', '31/12/2005', 'PT')
freqPSDB <- freq_discurso('previdência', '01/01/2003', '31/12/2005', 'PSDB')  

plot(freqPT[[1]]$dataSessao, freqPT[[1]]$freq, type='l')
lines(freqPSDB[[1]]$dataSessao, freqPSDB[[1]]$freq, col='red')

hPT <- histograma(freqPT)
hPSDB <- histograma(freqPSDB)

dnormalComp(mean(hPT), sd(hPT)/sqrt(length(hPT)),
            mean(hPSDB), sd(hPSDB)/sqrt(length(hPSDB)))

# saúde
freqPT <- freq_discurso('saúde', '01/01/2003', '31/12/2015', 'PT')
freqPSDB <- freq_discurso('saúde', '01/01/2003', '31/12/2015', 'PSDB')  

hPT <- histograma(freqPT, 'ano')
hPSDB <- histograma(freqPSDB, 'ano')
df <- data.frame(k = 1:length(hPT), hPSDB,hPT)
df <- df[df$hPT > 0,]

chisq.test(m)

hist(hPT)



dnormalComp(mean(hPT), sd(hPT)/sqrt(length(hPT)),
            mean(hPSDB), sd(hPSDB)/sqrt(length(hPSDB)))

freqPMDB <- freq_discurso('saúde', '01/01/2003', '31/12/2015', 'PMDB')
hPMDB <- histograma(freqPMDB, 'mes')

dnormalComp(mean(hPSDB), sd(hPT)/sqrt(length(hPSDB)),
            mean(hPMDB), sd(hPMDB)/sqrt(length(hPMDB)))



