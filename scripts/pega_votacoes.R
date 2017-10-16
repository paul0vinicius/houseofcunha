#!/usr/bin/env Rscript
library(dplyr)
library(readr)
library(purrr)
library(rcongresso)

args = commandArgs(trailingOnly = TRUE)
if (length(args) != 1) {
  stop(
    "Uso: pega_votacoes.R <arquivo_de_proposicoes>"
    )
}

arquivo_proposicoes <- args[1]

arquivo_proposicoes %>%
  read_csv(col_types = cols(
    tipo = col_character(),
    numero = col_integer(),
    ano = col_integer()
    )) %>%
  rowwise() %>%
  do(
    tibble(id = fetch_id_proposicao(.$tipo, .$numero, .$ano))
  )

# ids_proposicoes <- props_tipo_numero_ano_new %>%
#   rowwise() %>%
#   do(
#     fetch_id_proposicao(.$tipo, .$numero, .$ano)
#   )

props <- arquivo_proposicoes %>%
  pmap(fetch_id_proposicao) %>%
  map_df(fetch_proposicao)

ids <- props$id %>%
  as.vector()

ultimas_votacoes <- fetch_votacoes(ids) %>%
  ultima_votacao()

ids_ult_vot <- ultimas_votacoes$id %>%
  as.vector()

votacoes_relevantes <- fetch_votacao(ids_ult_vot)

# constroi_dataframe(proposicoes, votacoes_relevantes) %>%
#   format_csv() %>%
#   writeLines(stdout())
