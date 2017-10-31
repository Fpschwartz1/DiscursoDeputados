# CRONOGRAMA: julho e agosto de 2017

## Scripts R

### 09_UnificaArquivosDiscursos.R

Lê arquivos "discurso_AAAA.csv", compreendidos entre ano inicial e final informados, e consolida todos os discrusos em um único arquivo "discurso_ini_fim.rds" na pasta "..\\DadosRDS". Converte os respectivos arquivos "discurso_AAAA_dit.csv" para o formato "rds" e grava na mesma pasta.

### 10_CorporaPorCriterios.Rmd

A partir dos critérios ano inicial, ano final e partido, cria córpora "corpora_partido_ini_fim.rds" com os discursos de inteiro teor na pasta "..\\CorporaRDS".

### 11_LimpaCorporaParaAnalise.R

Efetua as etapas essenciais do PLN: transformações para minúscula; remoção de números, pontuação e espaços; remoção de stopwords (palavras com pouca informação) a partir de dicionário com 200 palavras específicas do discurso parlamentar, além de conjunto com nomes próprios encontrados no discurso parlamentar (arquivos "stop####_pt.txt").

O resultado final é armazenado em arquivo cujo nome é formado pela estrutura "corpora_partido_ini_fim_limpo.rds".

### 12_NuvemDePalavrasFreq.Rmd

Cria a matriz de frequência de termos e documentos; identifica as palavras mais frequentes; efetua a penalização de palavras por meio do algoritmo de inversão da frequência de documentos; filtra termos escassos; constrói nuvens de palavras.

Exemplos:  
["12_NuvemDePalavrasFreq_PT_2003_2016.html"](http://htmlpreview.github.com/?https://github.com/Fpschwartz1/DiscursoDeputados/blob/master/03_2017JulAgo/12_NuvemDePalavrasFreq_PT_2003_2016.html)  
["12_NuvemDePalavrasFreq_PT_2016_2017.html"](http://htmlpreview.github.com/?https://github.com/Fpschwartz1/DiscursoDeputados/blob/master/03_2017JulAgo/12_NuvemDePalavrasFreq_PT_2016_2017.html)
