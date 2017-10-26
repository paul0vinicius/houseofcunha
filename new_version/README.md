# QMR usando o rcongresso

## Pastas

Abaixo uma estrutura geral das pastas:

### input

Essa pasta guarda basicamente as proposicoes a serem selecionadas e as votacoes escolhidas.

#### proposicoes_house_of_cunha.csv
Todas as proposições que foram utilizadas para a análise do House of Cunha e que estão disponíveis na nova API.

#### proposicoes_qmr.csv
Todas as proposições referentes ao QMR.

#### ids_votacoes.csv
Todas as votações referentes às proposições que estão sendo usadas no QMR.

### output

#### votacoes_selecionadas.csv
Arquivo de saída utilizado para gerar as análises do QMR. Contém 37 colunas cabendo ao usuário fazer um `select()` das colunas que lhe interessa.

### scripts

#### constroi_dataframe.R
RScript responsável pelo join entre as colunas de votações e proposições garantindo a corretude e geração do dataframe `votacoes_selecionadas.csv`.

#### pega_votacoes.R
RScript responsável por importar os arquivos de proposições e votações, além de utilizar as funções do `rcongresso` para obter informações sobre estas.

#### run.sh
Executa os outros scripts e produz o dataframe `votacoes_selecionadas.csv` armazenando-o na pasta `output`.

## Como Usar:
Execute o script `run.sh` na pasta `scripts` para gerar o dataframe.
