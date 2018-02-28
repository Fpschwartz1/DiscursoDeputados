# CRONOGRAMA: dezembro de 2017, janeiro e fevereiro de 2018

## Scripts R

### 20_Histogramador.R

Implementa as funções: **freq_discurso**, que conta as ocorrências de um dado termo em cada discurso proferido no período informado; **histograma**, que consolida essas ocorrências em intervalos de classe que podem corresponder a um dia, semana, mês, bimestre, trimestre, quadrimestre ou ano; e **comparatermo_distfreq**, que faz chamadas às duas anteriores e plota gráficos comparados, entre dois partidos informados, de ocorrências do termo no tempo, de densidade de probabilidade e histogramas.

### 22_TesteHipotese.R

Implementa as funções: **qui_quadrado_cont**, que efetua o teste qui-quadrado em tabelas de contingência; **testa_collocations**, que verificar se os bigramas mais frequentes do discurso são ou não *collocations*; **corpus_similaridade**, que compara dois *corpus* por meio do teste qui-quadrado.

Expressões de duas ou mais palavras que correspondam a uma forma convencional de dizer as coisas são chamadas de colocações, ou *collocations*.

### 23_ExecutaTestesHipotese.R

Utiliza as funções definidas no script "22_TesteHipotese.R" para reproduzir tabelas e resultados registrados no elatório de pesquisa.

### 23_ExecutaTestesHipotese.Rmd

Executa testes de hipótese para a verificação de *collocations* e da similaridade entre discursos. Aplica a técnica proposta de aferição do Índice de Identidade Ideológica e plota os resultados para o período de 2001 a 2015. Utiliza o arquivo 'coalizoes.csv' para identificar os partidos pertencentes à coalizão governamental em cada ano.

### 24_SupLearning_DadosTreinamentoTeste.R

Cria conjuntos de dados de treinamento (arquivo 'disc_classificacao.csv') e de teste (arquivos 'coalizao_AAAA.csv') utilizados no algoritmo de aprendizagem de máquina supervisionada. Grava os resultados na pasta '..\SupLearning'. Utiliza o Utiliza o arquivo 'coalizoes_consolidado.csv' para identificar os partidos pertencentes à coalizão governamental em cada ano.

## Scripts Python

### 25_SupervisedLearning.ipynb

Executa os algorítmos de aprendizagem de máquina supervisionada.
