
################################################
# Codifica e decodifica RTF
################################################

if(!require(RCurl)) { install.packages('RCurl') }
if(!require(stringr)) { install.packages('stringr') }
if(!require(stringi)) { install.packages('stringi') }

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

retira_acentos <- function(txt) {
  txt %>%
    str_replace_all("à", "a") %>%
    str_replace_all("á", "a") %>%
    str_replace_all("ã", "a") %>%
    str_replace_all("â", "a") %>%
    str_replace_all("é", "e") %>%
    str_replace_all("ê", "e") %>%
    str_replace_all("í", "i") %>%
    str_replace_all("ó", "o") %>%
    str_replace_all("õ", "o") %>%
    str_replace_all("ô", "o") %>%
    str_replace_all("ú", "u") %>%
    str_replace_all("ü", "u") %>%
    str_replace_all("ç", "c")
}

# remoção de plural - deve ser chamada antes da retirada de acentos
# https://www.normaculta.com.br/singular-e-plural/
#
# palavras terminadas em
# http://www.palavras.net/search.php?f=eis
# 
# expressões regulares
# https://docs.python.org/3.4/howto/regex.html
# https://www.mathworks.com/help/matlab/ref/regexprep.html?requestedDomain=www.mathworks.com
# https://msdn.microsoft.com/en-US/library/2k3te2cs(v=vs.90).aspx
# https://docs.microsoft.com/en-us/dotnet/standard/base-types/substitutions-in-regular-expressions
remove_plural <- function(txt){
  txt <- str_split(txt, ' ')[[1]]
  txt <- txt[txt != ""]
  
  # -ões, -ãos, -ães no plural para -ão no singular 
  txt <- gsub('\\b(.*)ões\\>\\b', '\\1ão', txt)
  txt <- gsub('\\b(.*)ãos\\>\\b', '\\1ão', txt)
  txt <- gsub('\\b(.*)ães\\>\\b', '\\1ão', txt)
  
  # -ais, -éis, -óis, -uis no plural para -al, -el, -ol, -ul no singular
  txt <- gsub('pais', 'pai', txt) # exceção
  txt <- gsub('\\b(.*)ais\\>\\b', '\\1al', txt)
  txt <- gsub('\\b(.*)éis\\>\\b', '\\1el', txt)
  txt <- gsub('\\b(.*)seis\\>\\b', '\\1seiis', txt) # exceção
  txt <- gsub('\\b(.*)eis\\>\\b', '\\1el', txt)
  txt <- gsub('\\b(.*)óis\\>\\b', '\\1ol', txt)
  txt <- gsub('\\b(.*)uis\\>\\b', '\\1ul', txt)
  
  # substantivos terminados em -r, -z e -s formam plural acrescentado-se -es
  txt <- gsub('\\b(.*)sses\\>\\b', '\\1sse', txt) # exceção
  txt <- gsub('\\b(.*)([rsz])es\\>\\b', '\\1\\2', txt)
  
  # -ens -ins -ons -uns
  txt <- gsub('\\b(.*)([éeiou])ns\\>\\b', '\\1\\2m', txt)
  
  # -qu
  txt <- gsub('\\b(.*)quas\\>\\b', '\\1qua', txt)
  txt <- gsub('\\b(.*)ques\\>\\b', '\\1que', txt)
  txt <- gsub('\\b(.*)quis\\>\\b', '\\1qui', txt)
  txt <- gsub('\\b(.*)quos\\>\\b', '\\1quo', txt)
  
  # -gu
  txt <- gsub('\\b(.*)guas\\>\\b', '\\1gua', txt)
  txt <- gsub('\\b(.*)gues\\>\\b', '\\1gue', txt)
  txt <- gsub('\\b(.*)guis\\>\\b', '\\1gui', txt)
  txt <- gsub('\\b(.*)güis\\>\\b', '\\1gui', txt)
  txt <- gsub('\\b(.*)guos\\>\\b', '\\1guo', txt)
  
  # vogais + s antecedidos de consoante
  txt <- gsub('\\b(.*)([bcçdfghjklmnpqrstwvxyz])([aá])s\\>\\b', '\\1\\2a', txt)
  txt <- gsub('\\b(.*)([bcdfghjklmnpqtwvxy])([eé])s\\>\\b', '\\1\\2e', txt)
  txt <- gsub('\\b(.*)([bcdfghjklmnpqrstwvxyz])is\\>\\b', '\\1\\2i', txt)
  txt <- gsub('\\b(.*)([bcçdfghjklmnpqrstwvxyz])([oó])s\\>\\b', '\\1\\2o', txt)

  # exemplo: de black para place
  # gsub('\\bb([a-zA-Z]*)k\\b', 'p\\1e', 'black')

  stri_c_list(list(txt), sep=" ")
}
