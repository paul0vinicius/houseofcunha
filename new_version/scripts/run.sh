#!/usr/bin/env bash

set -u
set -e

echo "GETTING THE PROPOSITIONS AND VOTINGS"
./pega_votacoes.R "../input/proposicoes_qmr.csv" "../input/ids_votacoes.csv" > "../output/votacoes_selecionadas.csv"
echo "DONE. YOUR CSV WAS SAVED AT OUTPUT FOLDER" 
