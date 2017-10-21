###############################################################
# Verifica integridade entre lista de discursos e inteiro teor
# por meio do batimento entre o número de linhas
###############################################################

# pasta para a leitura dos arquivos
pasta <- "..\\..\\Dados\\"

for(ano in c(2017,2017)){

  # lista de discursos
  ld <- read.csv2(paste0(pasta, "discurso_",ano,".csv"), sep=";", colClasses = "character")
  # inteiro teor
  it <- read.csv2(paste0(pasta, "discurso_",ano,"_dit.csv"), header = FALSE, sep=";", colClasses = "character")
  
  print(paste0('Ano: ', ano, '  Lista: ', nrow(ld), ' - Inteiro Teor: ', nrow(it), ' ', nrow(ld)==nrow(it)))
  
  ld <- NULL
  it <- NULL
}

