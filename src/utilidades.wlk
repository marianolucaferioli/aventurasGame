import wollok.game.*

/** Creacion de posiciones aleatorias excluyendo la fila 14 (reservada para barras superiores --> ver barrasSuperiores.wlk) */

object utilidadesParaJuego {
    method posicionArbitraria() {
        return game.at(
            0.randomUpTo(game.width()).truncate(0), 0.randomUpTo(game.height()-1).truncate(0)
        )
    }
}