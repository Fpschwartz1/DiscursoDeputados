# CRONOGRAMA: maio e junho de 2017

## Scripts R

### 05_EncodeDecode.R

Contém a função *encode_rtf* que codifica texto *rtf* para *base64* e a função *decode_rtf* que decodifica *base64* para *rtf*.

### 06_AjustaDiscursoInteiroTeor.R

Retira caracteres de formatação de texto como, por exemplo, os da sequência a seguir: "\\{\\{ MS Sans Serif;\\}\\{ Symbol;\\}\\{ MS Sans Serif;\\}\\{ Arial;\\}\\}\\{;\\}".

Também insere cabeçalho aos arquivos "discurso_AAAA_dit.csv", denominando as colunas como "AnoSeq", "DataHora" e "Discurso".

### 07_CorporaRetiraQuadrosFiguras.R

Contém a função *retiga_fig* que recebe como parâmetros o *discurso* e os demarcadores de início e fim da figura, quadro ou tabela.

### 08_CriaCorporaDiscursoInteiroTeor.R

Lê os arquivos "discurso_AAAA_dit.csv", decodifica cada discurso para *rtf*, utiliza a função *retira_fig* passando os demarcadores de início e fim e grava no aqruivo "Discursos_AAAA.txt" um texto único (**corpus**) com todos os discursos do respecitvo ano.

### Dados

[Lista dos arquivos](https://1drv.ms/f/s!AiIkZUb8XZnDi04C4OHCMQYBgyxK) gerados após a execução dos scripts anteriores.

Observação: o pesquisador interessado em reproduzir os resultados aqui encontrados deve executar os scripts na sequência em que estão apresentados.

## Scripts Python

Os scripts Python foram escritos no Jupyter Notebook e têm por objetivo o teste de recursos do pacote [NLTK](http://www.nltk.org/).

### 09_CorporaDesempenhoLeitura.ipynb

Afere o tempo de leitura dos arquivos "Discursos_AAAA.txt" e o tempo necessário para a tokenização com o pacote NLTK.

### 10_CorporaTokenizacaoNgramas.ipynb

Urtiliza recursos do pacote NLTK a partir da criação de **corpora** composto por todos os arquivos "Discursos_AAAA.txt", efetua a tokenização, a distribuição de frequência e a concordância de palavras.

