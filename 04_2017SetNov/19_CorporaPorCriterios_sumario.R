# pacotes
if(!require(stringr)) { install.packages('stringr') }
if(!require(stringi)) { install.packages('stringi') }

source("..\\02_2017MaiJun\\05_EncodeDecode.R")

corpora_sumario <- function(ini, fim, partido){
  print(sprintf("Partido: %s (%d - %d)", partido, ini, fim))
  
  # lê arquivo com todos os discursos
  pastaorig <- "..\\DadosRDS\\"
  discursos <- readRDS(paste0(pastaorig, "discurso_2000_2017.rds"))
  names(discursos)[1] <- "seq"
  
  
  ### Verifica frequência de [sessões](http://www2.camara.leg.br/comunicacao/assessoria-de-imprensa/sessoes-do-plenario) por tipo e restringe às sessões relevantes
  # frequência por tipo de sessao
  tipo_sessao <- table(discursos$tipoSessao)
  # filtra sessões relevantes
  tipo_sessao <- as.character(levels(as.factor(discursos$tipoSessao)))
  tipo_sessao <- tipo_sessao[c(3:8, 12, 14:15, 18:19)]
  discursos <- discursos[discursos$tipoSessao %in% tipo_sessao, ]
  print('Tipos de sessão')
  print(tipo_sessao)
  
  ### Lê arquivo de discursos e aplica critérios iniciais de filtragem
  pastadest <- "..\\CorporaRDS\\"
  arquivo <- paste0(pastadest, "corpora_", partido, "_", ini, "_", fim, ".rds")
  discursos <- discursos[  str_sub(discursos$dataSessao,7,10) >= ini 
                           & str_sub(discursos$dataSessao,7,10) <= fim 
                           & discursos$partidoOrador == partido
                           , 
                           ]
  print(paste('Dimensões do arquivo de discurso:', stri_c_list(list(dim(discursos)), sep=" ")))
  

  vdisc <- discursos[ , "sumario"]
  vdisc <- vdisc[vdisc != ""]
  vdisc <- vdisc[!is.na(vdisc)]
    
  saveRDS(vdisc, arquivo)
}

# remove todas as variáveis, menos os parâmetros ini, fim e partido
# rm(list = ls(all = TRUE)[!(ls(all = TRUE) %in% c("ini", "fim", "partido"))])

