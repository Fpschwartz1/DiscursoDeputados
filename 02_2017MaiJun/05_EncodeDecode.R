
################################################
# Codifica e decodifica RTF
################################################

if(!require(RCurl)) { install.packages('RCurl') }
if(!require(stringr)) { install.packages('stringr') }

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
