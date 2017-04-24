# GESTÃO DO CONHECIMENTO LEGISLATIVO COM FOCO NA ANÁLISE DO DISCURSO PARLAMENTAR POR MEIO DA TÉCNICA DO PROCESSAMENTO DE LINGUAGEM NATURAL

### Autor: Fabiano Peruzzo Schwartz

## Introdução

O presente repositório se destina ao armazenamento das entregas de pesquisa programadas para o período de março de 2017 a fevereiro de 2018, no contexto de estágio pós-doutoral em andamento no Departamento de Engenharia Elétrica da Universidade de Brasília sob a supervisão do Prof. Dr. Francisco Assis de Oliveira Nascimento. O estudo propõe a construção de algoritmos computacionais capazes de extrair informações dos aspectos estruturais do discurso parlamentar, de forma a se produzir conhecimento sobre a dinâmica do Processo Legislativo e sobre a tendência do discurso no contexto temporal. Esse conhecimento pode contribuir para a compreensão das orientações políticas e seus desdobramentos.

## Problema de Pesquisa

Processo Legislativo é o conjunto de atos realizados pelos órgãos do Poder Legislativo, de acordo com regras previamente fixadas, para a elaboração de normas jurídicas, sejam emendas à Constituição, leis complementares, leis ordinárias e outros tipos normativos dispostos no art. 59 da Constituição Federal.

Dados protocolares do Processo Legislativo são tratados de forma estruturada e contam a parte da história restrita às fases previstas na regra. Contudo, os caminhos da discussão que levam à forma final do texto normativo ficam dispersos no registro taquigráfico dos discursos e debates, ou seja, em dado não-estruturado. Isso dificulta o resgate da linha argumentativa pró e contra determinado tema discutido no âmbito das sessões plenárias. Tal resgate, quando necessário, consiste em remontar, muitas vezes de forma manual, a sequência dos fatos, memórias e aspectos comportamentais dos agentes envolvidos em determinado evento, com a finalidade de se compreender a lógica das decisões. Esse processo é, em geral, moroso e impreciso, o que caracteriza fundamentalmente o problema de pesquisa a ser abordado. A captação e gestão do conhecimento implícito no discurso parlamentar podem ser aprimoradas pelo uso de recursos computacionais e técnicas avançadas de processamento linguístico.

## Objetivo

O objetivo geral deste trabalho de pesquisa concentra-se no desenvolvimento de algoritmos computacionais, baseados em Processamento de Linguagem Natural e aprendizagem de máquina, com a finalidade de organizar, classificar, recuperar e divulgar o conhecimento implícito da atividade política contida no discurso parlamentar.

Como objetivos específicos, podem ser destacados:

1.	a estruturação de base textual (*corpus*) dos discursos parlamentares compreendendo as legislaturas de número 52, 53, 54 e 55;
2.	a construção dos sintagramas , ou n-gramas, com grupos de duas a cinco palavras;
3.	o desenvolvimento de classificadores por meio de técnicas de aprendizagem de máquina para a identificação de características do discurso, como: padrões e reconhecimento da fala, estilo comunicativo do orador, vocabulário temático (léxico), etc; 
4.	a extração e interpretação de informações dos aspectos estruturais do discurso parlamentar para a produção de conhecimento; 
5.	a resolução de ambiguidades do discurso; e
6.	a simplificação de texto e estudo da aplicação do PLN ao processo de retextualização .

## Cronograma

Mês/Ano |	Atividade
--------|----------------------------------------------------------------------
Mar/2017| Compilação das bases textuais das legislaturas 52 e 53
Abr/2017| Compilação das bases textuais das legislaturas 54 e 55
Mai/2017| Estruturação do corpus e testes de desempenho
Jun/2017| Organização dos n-gramas e desenvolvimento de classificadores
Jul/2017| Testes de pacotes lexicais e estruturação de vocabulário temático
Ago/2017| Desenvolvimento de algoritmos para análise morfológica
Set/2017| Desenvolvimento de algoritmos para análise sintática
Out/2017| Desenvolvimento de algoritmos para análise semântica
Nov/2017| Desenvolvimento de algoritmos para análise pragmática
Dez/2017| Construção de interface para utilização dos algoritmos
Jan/2018| Avaliação dos algoritmos desenvolvidos em situações práticas reais
Fev/2018| Elaboração do relatório de pesquisa
