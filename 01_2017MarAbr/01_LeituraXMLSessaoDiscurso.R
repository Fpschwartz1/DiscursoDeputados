####################################################
# Carrega a lista de discursos em plenário a partir
# do sítio de dados abertos da Câmara dos Deputados
#
# Listar Discurso Plenário
# http://www2.camara.leg.br/transparencia/dados-abertos/dados-abertos-legislativo/webservices/sessoesreunioes-2/listardiscursosplenario
####################################################

library(XML)
library(stringr)

# marca o momento do início do algorítmo
ptm <- proc.time()
print('Início')
print(ptm)

# O intervalo entre as datas não pode ser superior a 360 dias.
dataIni <- '01/01/' 
dataFim <- '23/12/'

# pasta para a gravação dos arquivos
pasta <- "..\\..\\Dados\\"

trim <- function (x){
            x <- gsub("\n", "", x)
            str_trim(x)
        }

for(ano in 2017:2017){
    
    # monta a URL com base no ano e período
    url <-  paste0("http://www.camara.leg.br/sitcamaraws/SessoesReunioes.asmx/ListarDiscursosPlenario?",
                   "dataIni=",dataIni,ano,"&dataFim=",dataFim,ano,
                   "&codigoSessao=&parteNomeParlamentar=&siglaPartido=&siglaUF="
    )
    
    # enquanto não conseguir ler os dados do ano/período no link, tenta novamente 
    repeat{
      data <- try(xmlParse(url, isURL=TRUE, asTree = TRUE, useInternalNodes = TRUE), TRUE)
      if(typeof(data) == "externalptr") break
      print("Erro ao acessar a URL")
      Sys.sleep(0.5)
    }
    
    # converte formato XML para lista do R
    xml_data <- xmlToList(data)
    
    # sessaoDiscurso <- NULL
    # faseSessao <- NULL
    discurso <- NULL
    
    # para cada sessão no ano/período ...
    for(i in 1:length(xml_data)){
      
      #df1 <- data.frame(
      #  codigo=trim(xml_data[[i]]$codigo),
      #  data=xml_data[[i]]$data,
      #  numero=xml_data[[i]]$numero,
      #  tipo=xml_data[[i]]$tipo
      #)
      #sessaoDiscurso <- rbind(sessaoDiscurso, df1)
      
      # ... verifica se existem fases e ...
      if(length(xml_data[[i]]$fasesSessao)>0){
        
        # ... para cada fase ... 
        for(j in 1:length(xml_data[[i]]$fasesSessao)){
          #df2 <- data.frame(
          #  codigo=trim(xml_data[[i]]$codigo),
          #  codigoFase=xml_data[[i]]$fasesSessao[j]$faseSessao$codigo,
          #  descricao=xml_data[[i]]$fasesSessao[j]$faseSessao$descricao
          #)
          #faseSessao <- rbind(faseSessao, df2)
          
          # ... verifica se existem discursos e faz a leitura dos dados de indexação
          if(length(xml_data[[i]]$fasesSessao[j]$faseSessao$discursos)>0){
            for(k in 1:length(xml_data[[i]]$fasesSessao[j]$faseSessao$discursos)){
              df3 <- data.frame(
                codigoSessao=trim(xml_data[[i]]$codigo),
                dataSessao=xml_data[[i]]$data,
                numeroSessao=xml_data[[i]]$numero,
                tipoSessao=xml_data[[i]]$tipo,
                codigoFase=xml_data[[i]]$fasesSessao[j]$faseSessao$codigo,
                descricaoFase=xml_data[[i]]$fasesSessao[j]$faseSessao$descricao,
                numeroQuarto=xml_data[[i]]$fasesSessao[j]$faseSessao$discursos[k]$discurso$numeroQuarto,
                numeroInsercao=xml_data[[i]]$fasesSessao[j]$faseSessao$discursos[k]$discurso$numeroInsercao,
                numeroOrador=xml_data[[i]]$fasesSessao[j]$faseSessao$discursos[k]$discurso$orador$numero,
                nomeOrador=xml_data[[i]]$fasesSessao[j]$faseSessao$discursos[k]$discurso$orador$nome,
                partidoOrador=xml_data[[i]]$fasesSessao[j]$faseSessao$discursos[k]$discurso$orador$partido,
                ufOrador=xml_data[[i]]$fasesSessao[j]$faseSessao$discursos[k]$discurso$orador$uf,
                txtIndexacao=xml_data[[i]]$fasesSessao[j]$faseSessao$discursos[k]$discurso$txtIndexacao,
                sumario=xml_data[[i]]$fasesSessao[j]$faseSessao$discursos[k]$discurso$sumario
              )
              discurso <- rbind(discurso, df3)
            }
          }
        }
      }
      
      # mostra ano e índice do discurso lido ...
      print(paste0(ano,' - ',i))
      # ... e o tempo decorrido para a leitura
      print(proc.time() - ptm)
      ptm <- proc.time()
    }
      
    #write.csv2(sessaoDiscurso, paste0("sessao_discurso_",ano,".csv"))
    #write.csv2(faseSessao, paste0("fase_sessao_",ano,".csv"))
    write.csv2(discurso, paste0(pasta, "discurso_",ano,".csv"))
}

# http://www.camara.leg.br/SitCamaraWS/Proposicoes.asmx/ObterVotacaoProposicao?tipo=MSC&numero=950&ano=1989

