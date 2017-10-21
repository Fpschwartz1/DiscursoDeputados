###############################################
# Verfica e ajusta os discursos com texto longo
###############################################

# 2011
# "Erro - 305:17775"
# xmlSAX2Characters: huge text nodeExtra content at the end of the document

# pasta para a leitura dos arquivos
pasta <- "..\\..\\Dados\\"

# lê arquivo com identificação dos textos longos
textoLongo <- read.csv2(paste0(pasta, "TextoLongo.csv"), sep=";", header = FALSE, colClasses = "character")
names(textoLongo) <- c("ano", "sequencial", "url")

# lista identificação dos textos longos
for(i in 1:nrow(textoLongo)){
  print(paste(textoLongo$ano[i], textoLongo$sequencial[i], textoLongo$url[i]))
}


################################################
# Inspeção visual e ajuste
################################################

library(RCurl)
library(stringr)
library(magrittr)
library(XML)

# decodificacao do formato RTF - Base64 para txt
# https://www.base64decode.org/
decode_rtf <- function(txt) {
  txt %>%
    base64Decode %>%
    str_replace_all("\\\\'e0", "à") %>%
    str_replace_all("\\\\'e1", "á") %>%
    str_replace_all("\\\\'e2", "ã") %>%
    str_replace_all("\\\\'e3", "ã") %>%
    str_replace_all("\\\\'e9", "é") %>%
    str_replace_all("\\\\'e7", "ç") %>%
    str_replace_all("\\\\'ed", "í") %>%
    str_replace_all("\\\\'f3", "ó") %>%
    str_replace_all("\\\\'f5", "õ") %>%
    str_replace_all("\\\\'f4", "ô") %>%
    str_replace_all("\\\\'ea", "ê") %>%
    str_replace_all("\\\\'fa", "ú") %>%
    str_replace_all("(\\\\[[:alnum:]']+|[\\r\\n]|^\\{|\\}$)", "") %>%
    str_replace_all("\\{\\{[[:alnum:]; ]+\\}\\}", "") %>%
    str_trim
}

encode_rtf <- function(txt) {
  txt %>%
    str_replace_all("à", "\\\\'e0") %>%
    str_replace_all("á", "\\\\'e1") %>%
    str_replace_all("ã", "\\\\'e2") %>%
    str_replace_all("ã", "\\\\'e3") %>%
    str_replace_all("é", "\\\\'e9") %>%
    str_replace_all("ç", "\\\\'e7") %>%
    str_replace_all("í", "\\\\'ed") %>%
    str_replace_all("ó", "\\\\'f3") %>%
    str_replace_all("õ", "\\\\'f5") %>%
    str_replace_all("ô", "\\\\'f4") %>%
    str_replace_all("ê", "\\\\'ea") %>%
    str_replace_all("ú", "\\\\'fa") %>%
    str_trim %>%
    base64Encode 
}

##########################################################################
# Lê arquivo "discurso_2011_dit.csv" para inserção dos discursos ajustados
##########################################################################
discursos2011 <- read.csv2(paste0(pasta, "discurso_2011_dit.csv"), sep=";", header = FALSE, colClasses = "character")

################################################################################################
# discurso do deputado EUDES XAVIER, PT, CE de 06/10/2011 excluidos os quadros - sequencial 5305
################################################################################################
url <- "http://www.camara.leg.br/SitCamaraWS/SessoesReunioes.asmx/obterInteiroTeorDiscursosPlenario?codSessao=275.1.54.O&numOrador=2&numQuarto=12&numInsercao=0"

readlines <- readLines(url, warn = FALSE)

doc <- htmlTreeParse(readlines, asText = TRUE, useInternalNodes = TRUE)
htmltxt <- paste(capture.output(doc, file=NULL), collapse="\n")

txt <- strsplit(htmltxt, "discursortfbase64>")[[1]][2]
txt <- strsplit(txt, "</")[[1]][1]
txt <- decode_rtf(txt)
txt <- str_sub(txt, 35, 2499)
txt
txt <- encode_rtf(txt)[1]

discursos2011[ discursos2011$V1 == "201105305", "V2"] <- "6/10/2011 14:33:00"
discursos2011[ discursos2011$V1 == "201105305", "V3"] <- txt
discursos2011[ discursos2011$V1 == "201105305", ]

#########################################################################################
# discurso do deputado MARCON, PT, RS de 22/9/2011 excluidos os quadros - sequencial 6454
#########################################################################################
url <- "http://www.camara.leg.br/SitCamaraWS/SessoesReunioes.asmx/obterInteiroTeorDiscursosPlenario?codSessao=256.1.54.O&numOrador=3&numQuarto=1&numInsercao=0"

readlines <- readLines(url, warn = FALSE)

doc <- htmlTreeParse(readlines, asText = TRUE, useInternalNodes = TRUE)
htmltxt <- paste(capture.output(doc, file=NULL), collapse="\n")

txt <- strsplit(htmltxt, "discursortfbase64>")[[1]][2]
txt <- strsplit(txt, "</")[[1]][1]
txt <- decode_rtf(txt)
txt <- str_sub(txt, 93, 4105)
txt
txt <- encode_rtf(txt)[1]

discursos2011[ discursos2011$V1 == "201106454", "V2"] <- "22/9/2011 09:00:00"
discursos2011[ discursos2011$V1 == "201106454", "V3"] <- txt
discursos2011[ discursos2011$V1 == "201106454", ]

####################################################################
# Grava o arquivo "discurso_2011_dit.csv" com os discursos ajustados
####################################################################

write.table(x=discursos2011,
            sep=";",
            file="discurso_2011_dit.csv",
            append=FALSE,
            row.names=FALSE,
            col.names=FALSE)



# testa atualização do discurso 
# 
# rm(discursos2011)
# discursos2011 <- read.csv2("discurso_2011_dit.csv", sep=";", header = FALSE, colClasses = "character")
# discursos2011[ discursos2011$V1 == "201105305", "V3"]
# decode_rtf(discursos2011[ discursos2011$V1 == "201105305", "V3"])
# discursos2011[ discursos2011$V1 == "201106454", "V3"]
# decode_rtf(discursos2011[ discursos2011$V1 == "201106454", "V3"])



