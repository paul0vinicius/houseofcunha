#!/usr/bin/env Rscript
library(dplyr)
library(readr)
library(purrr)
library(rcongresso)

source("constroi_dataframe.R")

args = commandArgs(trailingOnly = TRUE)
if (length(args) != 1) {
  stop(
    "Uso: pega_votacoes.R <arquivo_de_proposicoes>"
    )
}

arquivo_proposicoes <- args[1]

props <- arquivo_proposicoes %>%
  read_csv(col_types = cols(
    tipo = col_character(),
    numero = col_integer(),
    ano = col_integer()
    ))

tryCatch({
  props <- props %>%
    pmap(fetch_id_proposicao) %>%
    map_df(fetch_proposicao)
}, error=function(e){
  print("Alguma proposição não foi encontrada.")
})

# ids_proposicoes <- props_tipo_numero_ano_new %>%
#   rowwise() %>%
#   do(
#     fetch_id_proposicao(.$tipo, .$numero, .$ano)
#   )

# tryCatch({
#   a %>%
#     rowwise() %>%
#     do(
#       fetch_id_proposicao(.$tipo, .$numero, .$ano)
#     )
# }, error=function(e){
#   print("Alguma proposição deu ruim")
# })


ids <- props$id %>%
  as.vector()

ultimas_votacoes <- fetch_votacoes(ids) %>%
  ultima_votacao()

ids_ult_vot <- ultimas_votacoes$id %>%
  as.vector()

votacoes_relevantes <- fetch_votacao(ids_ult_vot)

constroi_dataframe(props, votacoes_relevantes) %>%
  format_csv() %>%
  writeLines(stdout())
