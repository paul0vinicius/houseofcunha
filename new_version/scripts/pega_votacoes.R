#!/usr/bin/env Rscript
library(dplyr)
library(readr)
library(purrr)
library(rcongresso)

source("constroi_dataframe.R")

args = commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  stop(
    "Uso: pega_votacoes.R <arquivo_de_proposicoes> <arquivo_de_votacoes>"
    )
}

arquivo_proposicoes <- args[1]
arquivo_votacoes <- args[2]

props <- arquivo_proposicoes %>%
  read_csv(col_types = cols(
    tipo = col_character(),
    numero = col_integer(),
    ano = col_integer()
    ))

ids_votacoes <- read_csv(arquivo_votacoes)$id_votacao

tryCatch({
  props <- props %>%
    pmap(fetch_id_proposicao) %>%
    map_df(fetch_proposicao)
}, error=function(e){
  print("Alguma proposição não foi encontrada.")
  stop()
})

tryCatch({
  votacoes_relevantes <- fetch_votacao(ids_votacoes)
}, error=function(e){
  print("Alguma votação não foi encontrada.")
  stop()
})

constroi_dataframe(props, votacoes_relevantes) %>%
  format_csv() %>%
  writeLines(stdout())
