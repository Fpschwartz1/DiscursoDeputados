rm(list = ls(all = TRUE))
source("10_CorporaPorCriterios.R")
source("11_LimpaCorporaParaAnalise.R")

pt1 <- proc.time()

discursos <- readRDS("..\\DadosRDS\\discurso_2000_2017.rds")

for(partido in c("PMDB","PT","PSDB","PSOL","PCDOB","PTB","PV")){ 
  for(ano in c(2006,2010,2014)){
    
    # parâmetros
    ini <- ano
    fim <- ano
 
    corpora_por_criterios(discursos, ini, fim, partido, c("GE", "PE"))
    
    limpa_corpora(ini, fim, partido)
    
    #pasta <- "..\\CorporaRDS\\"
    #arq_html <- paste0(pasta, "analise_", partido, "_", ini, "_", fim, ".html")
    #rmarkdown::render('12_NuvemDePalavrasFreq.Rmd', 
    #                  output_file = arq_html,
    #                  params = list(ini = ini, fim = fim, partido = partido))
  }
}

pt2 <- proc.time()
print(paste('Tempo de processamento:', stri_c_list(list((pt2 - pt1)[3]), sep=" ")))
