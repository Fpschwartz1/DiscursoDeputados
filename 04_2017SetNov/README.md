# CRONOGRAMA: setembro, outubro e novembro de 2017

## Scripts R

### 15_Topicos.R

Implementa a função **topicos_discurso**, que lê o arquivo "corpora_partido_ini_fim_limpo.rds", a partir dos parãmetros ini, fim e partido informados, remove termos esparsos e aplica o modelo Latent Dirichlet Allocation (LDA) para a identificação de tópicos. São utilizados os métodos de ajuste de VEM (Variational Expectation Maximization) e de Gibbs. Por fim, grava os resultados no arquivo "topicos_partido_ini_fim.rds", na pasta "..\Topicos".

No processamento de linguagem natural, a Alocação Latente de Dirichlet é um modelo estatístico generativo que permite que os conjuntos de observações sejam explicados por grupos identificam partes de dados são semelhantes. 
Por exemplo, se as observações são palavras coletadas em documentos, ele postula que cada documento é uma mistura de um pequeno número de tópicos e que a criação de cada palavra é atribuível a um dos tópicos do documento.
Os modelos de tópicos agrupam tanto documentos que usam palavras semelhantes, quanto palavras que ocorrem em um conjunto de documentos semelhantes.

[Topic model](https://en.wikipedia.org/wiki/Topic_model)  
[LDA](https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation)

### 15_Topicos.Rmd

Lê arquivos do tipo "topicos_partido_ini_fim.rds" e apresenta os tópicos encontrados de acordo com os métodos (VEM e Gibbs) aplicados.

Exemplo:  
["topicos_PSDB_2016_2016.html"](http://htmlpreview.github.com/?https://github.com/Fpschwartz1/DiscursoDeputados/blob/master/04_2017SetNov/topicos_PSDB_2016_2016.html)  
["topicos_PT_2016_2016.html"](http://htmlpreview.github.com/?https://github.com/Fpschwartz1/DiscursoDeputados/blob/master/04_2017SetNov/topicos_PT_2016_2016.html)  

### 16_ExecutaArquivo_15.R

Faz chamadas à função **topicos_discurso** e ao arquivo "15_Topicos.Rmd" de forma a apresentar, em html, os tópicos identificados em determinado período informado.

### 17_TemasNoTempo.R

Consolida no arquivo "topicos.html", na pasta '..\Topicos', os tópicos identificados por meio da observação de unigramas e bigramas, e da aplicação da LDA. 

Exemplo:  
["topicos.html"](http://htmlpreview.github.com/?https://github.com/Fpschwartz1/DiscursoDeputados/blob/master/04_2017SetNov/topicos.html)  

### 18_TemasNoTempo.Rmd

Script Rmd que gera o arquivo "topicos.html".

### 19_CorporaPorCriterios_sumario.R

Visando nova abordagem de análise, produz vetor de discursos contendo apenas os sumários.








