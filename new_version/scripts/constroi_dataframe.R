library(rcongresso)
library(dplyr)
library(magrittr)

constroi_dataframe <- function(proposicao, votacao) {
  colnames(proposicao)[1] <- "id_proposicao"
  colnames(proposicao)[2] <- "uri_proposicao"

  colnames(votacao)[1] <- "id_votacao"
  colnames(votacao)[2] <- "uri_votacao"

  votos <- fetch_votos(votacao$id_votacao)

  orientacao_governo <- votacao %>%
    dplyr::rowwise() %>%
    dplyr::do(
      fetch_orientacoes(.$id_votacao) %>%
        dplyr::filter(.$nomeBancada=="GOV.") %>%
        dplyr::select(orientacao_governo = voto, id_votacao)
    )

  pos_bancadas <- votacao %>%
    dplyr::rowwise() %>%
    dplyr::do(get_votos_partidos(.$id_votacao))

  votos %>%
    dplyr::left_join(votacao, by="id_votacao") %>%
    dplyr::left_join(proposicao, by=c("uriProposicaoPrincipal" = "uri_proposicao")) %>%
    dplyr::left_join(pos_bancadas, by=c("parlamentar.siglaPartido" = "partido", "id_votacao")) %>%
    dplyr::left_join(orientacao_governo, by="id_votacao")
}
