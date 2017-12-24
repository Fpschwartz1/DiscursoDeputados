rm(list = ls(all = TRUE))

source("15_Topicos.R")
require(stringi)

pt1 <- proc.time()

for(partido in c("PT", "PSDB")){
  for(ano in 2001:2017){
    
    # parâmetros
    ini <- ano
    fim <- ano
    
    topicos_discurso(ini, fim, partido)
    
    pasta <- "..\\Topicos\\"
    arq_html <- paste0(pasta, "topicos_", partido, "_", ini, "_", fim, ".html")
    rmarkdown::render('15_Topicos.Rmd', 
                      output_file = arq_html,
                      params = list(ini = ini, fim = fim, partido = partido))
  }
}

pt2 <- proc.time()
print(paste('Tempo de processamento:', stri_c_list(list((pt2 - pt1)[3]), sep=" ")))
