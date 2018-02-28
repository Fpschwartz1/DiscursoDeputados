# ANÁLISE DO DISCURSO PARLAMENTAR POR MEIO DA TÉCNICA DO PROCESSAMENTO DE LINGUAGEM NATURAL

### Autor: Fabiano Peruzzo Schwartz

## Introdução

O presente repositório se destina ao armazenamento das entregas de pesquisa programadas para o período de março de 2017 a fevereiro de 2018, no contexto de estágio pós-doutoral em andamento no Departamento de Engenharia Elétrica da Universidade de Brasília sob a supervisão do Prof. Dr. Francisco Assis de Oliveira Nascimento. O estudo propõe a construção de algoritmos computacionais capazes de extrair informações dos aspectos estruturais do discurso parlamentar, de forma a se produzir conhecimento sobre a dinâmica do Processo Legislativo e sobre a tendência do discurso no contexto temporal. Esse conhecimento pode contribuir para a compreensão das orientações políticas e seus desdobramentos.

## Problema de Pesquisa

Processo Legislativo é o conjunto de atos realizados pelos órgãos do Poder Legislativo, de acordo com regras previamente fixadas, para a elaboração de normas jurídicas, sejam emendas à Constituição, leis complementares, leis ordinárias e outros tipos normativos dispostos no art. 59 da Constituição Federal.

Dados protocolares do Processo Legislativo são tratados de forma estruturada e contam a parte da história restrita às fases previstas na regra. Contudo, os caminhos da discussão que levam à forma final do texto normativo ficam dispersos no registro taquigráfico dos discursos e debates, ou seja, em dado não-estruturado. Isso dificulta o resgate da linha argumentativa pró e contra determinado tema discutido no âmbito das sessões plenárias. Tal resgate, quando necessário, consiste em remontar, muitas vezes de forma manual, a sequência dos fatos, memórias e aspectos comportamentais dos agentes envolvidos em determinado evento, com a finalidade de se compreender a lógica das decisões. Esse processo é, em geral, moroso e impreciso, o que caracteriza fundamentalmente o problema de pesquisa a ser abordado. A captação e gestão do conhecimento implícito no discurso parlamentar podem ser aprimoradas pelo uso de recursos computacionais e técnicas avançadas de processamento linguístico.

## Objetivo

O objetivo geral deste trabalho de pesquisa tem abordagem prática e se concentra no desenvolvimento e aplicação de algoritmos computacionais, baseados em Processamento de Linguagem Natural, estatística e aprendizagem de máquina, com a finalidade organizar, classificar, recuperar e divulgar o conhecimento implícito da atividade política contida no discurso parlamentar.

Como objetivos específicos, podem ser destacados os de suporte:

1.	a identificação e aplicação das tecnologias disponíveis para o Processamento de Linguagem Natural, com enfoque nos pacotes de funcionalidades disponíveis para as linguagens R e Python;
2.	a estruturação de base textual (*corpus*) dos discursos parlamentares compreendendo as legislaturas de número 51, 52, 53, 54 e 55;
3.	a disponibilização dos dados, scripts de programação e resultados em repositório público com a finalidade de incentivar novos estudos sobre o tema e de prover meios para a reprodutibilidade da pesquisa;

e os de caráter analítico:

4.	a construção dos sintagramas, ou n-gramas, com grupos de duas palavras e validação de *collocations*; 
5.	a identificação de padrões do discurso, análise de convergência ideológica e posicionamento político-partidário na linha do tempo; e
6.	a identificação de grupos por meio da aplicação de classificadores e técnicas de aprendizagem de máquina.

## Cronograma

Mês/Ano |	Atividade
--------|----------------------------------------------------------------------
Mar/2017| Compilação das bases textuais das legislaturas 52 e 53
Abr/2017| Compilação das bases textuais das legislaturas 54 e 55
Mai/2017| Estruturação do *corpora* e testes de desempenho
Jun/2017| Organização dos n-gramas e desenvolvimento de classificadores
Jul/2017| Criação de dicionários de *stopwords* em português e pré-processamento de *corpus*
Ago/2017| Análise exploratória dos dados por meio de nuvens de palavras e gráficos de frequência
Set/2017| Criação de dicionários de *stopwords* do discurso parlamentar e do Processo Legislativo
Out/2017| Análise de cluster hierárquica e modelo de tópicos
Nov/2017| Estudo da distribuição de probabilidades dos temas, teste qui-quadrado e tabelas de contingência
Dez/2017| Análise de *collocations*, similaridade do discurso e aprendizagem de máquina
Jan/2018| Elaboração do relatório de pesquisa
Fev/2018| Elaboração do relatório de pesquisa
