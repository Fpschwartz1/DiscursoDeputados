###############################################################
# Verifica integridade entre lista de discursos e inteiro teor
# por meio do batimento entre o número de linhas
###############################################################

for(ano in 2003:2017){

  # lista de discursos
  ld <- read.csv2(paste0("discurso_",ano,".csv"), sep=";", colClasses = "character")
  # inteiro teor
  it <- read.csv2(paste0("discurso_",ano,"_dit.csv"), header = FALSE, sep=";", colClasses = "character")
  
  print(paste0('Ano: ', ano, '  Lista: ', nrow(ld), ' - Inteiro Teor: ', nrow(it), ' ', nrow(ld)==nrow(it)))
  
  ld <- NULL
  it <- NULL
}

