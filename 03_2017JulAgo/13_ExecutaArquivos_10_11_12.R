rm(list = ls(all = TRUE))
# source("10_CorporaPorCriterios.R")
source("11_LimpaCorporaParaAnalise.R")


for(partido in c("PSDB")){
  for(ano in 2014:2014){
    
    # parâmetros
    ini <- ano
    fim <- ano
 
    # corpora_por_criterios(ini, fim, partido)
    
    limpa_corpora(ini, fim, partido)
    
    pasta <- "..\\CorporaRDS\\"
    arq_html <- paste0(pasta, "analise_", partido, "_", ini, "_", fim, ".html")
    rmarkdown::render('12_NuvemDePalavrasFreq.Rmd', 
                      output_file = arq_html,
                      params = list(ini = ini, fim = fim, partido = partido))
  }
}