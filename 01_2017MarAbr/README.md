# CRONOGRAMA: março e abril de 2017

## Scripts R

### 01_LeituraXMLSessaoDiscurso.R

Carrega a lista de discursos em plenário a partir do sítio de dados abertos da Câmara dos Deputados ([ListarDiscursoPlenário](http://www2.camara.leg.br/transparencia/dados-abertos/dados-abertos-legislativo/webservices/sessoesreunioes-2/listardiscursosplenario)). Para cada ano é gerado um arquivo denominado "discurso_AAAA.csv", com os seguintes campos: codigoSessao, dataSessao, numeroSessao, tipoSessao, codigoFase, descricaoFase, numeroQuarto, numeroInsercao, numeroOrador, nomeOrador, partidoOrador, ufOrador, txtIndexacao, sumario.

### 02_LeituraXMLDiscursoInteiroTeor.R

Carrega o inteiro teor dos discursos a partir do sítio de dados abertos da Câmara dos Deputados ([ObterInteiroTeorDiscursosPlenario](http://www2.camara.leg.br/transparencia/dados-abertos/dados-abertos-legislativo/webservices/sessoesreunioes-2/obterinteiroteordiscursosplenario)). Para cada ano é gerado um arquivo denominado "discurso_AAAA_dit.csv", com os seguintes campos: id, horaInicioDiscurso, discurso.

### 03_VerificacaoDeIntegridade.R

Verifica integridade por meio do batimento entre o número de linhas dos arquivos "discurso_AAAA.csv" e "discurso_AAAA_dit.csv".

### 04_AjustaDiscursoComTextoLongo.R

Ajusta para o limite de tamanho de uma string os textos de inteiro teor que extrapolam esse limite. Foram identificados apenas dois discursos no ano de 2011 (ver registros no arquivo "TextoLongo.csv").

Neste script foram desenvolvidas duas funções para a codificação txt-[Base64](https://pt.wikipedia.org/wiki/Base64) e decodificação Base64-txt.

### Dados

[Lista dos arquivos](https://1drv.ms/f/s!AiIkZUb8XZnDi04C4OHCMQYBgyxK) gerados após a execução dos scripts anteriores.

Observação: o pesquisador interessado em reproduzir os resultados aqui encontrados deve executar os scripts na sequência em que estão apresentados.