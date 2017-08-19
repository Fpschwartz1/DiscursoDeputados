if(!require(stringr)) { install.packages('stringr') }

# retira quadros, tabelas e figuras
retira_fig <- function(discurso, ano){

  # marcador de inicio e fim da figura
  ini <- "010009000003"
  fim <- "ffff030000000000"
  
  if(ano == 2003){
    ini <- "0105000002000000"
    fim <- "FFFF030000000000\\}\\}"
  }
  
  if(ano == 2007){
    ini <- "010009000003"
    fim <- "030000000000\\}"
  }
  
  if(ano == 2009){
    ini <- "010009000003"
    fim <- "FFFF030000000000"
  }

  li <- str_locate_all(discurso, ini)
  lf <- str_locate_all(discurso, fim)
  
  disc <- NULL
  if( (dim(li[[1]])[1] == dim(lf[[1]])[1]) & (dim(li[[1]])[1] > 0) ){
    n <- dim(li[[1]])[1]
    
    for(i in 1:n){
  
      if(i == 1){
        disc <- paste0(disc, str_sub(discurso, 1, li[[1]][i,1] - 1) )
      } else if(i == n) {
        disc <- paste0(disc, str_sub(discurso, lf[[1]][i,2] + 1, str_length(discurso)) )
      } else{
        disc <- paste0(disc, str_sub(discurso, lf[[1]][i-1,2] + 1, li[[1]][i,1] - 1) )
      }
    }
  }

  if(is.null(disc)){
    discurso
  }else {
    disc
  }
}

