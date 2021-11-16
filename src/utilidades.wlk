import wollok.game.*
import elementos.*

object utilidadesParaJuego {
	
	/** 
		Creacion de posiciones aleatorias excluyendo la fila 14 
		(reservada para barras superiores --> ver barrasSuperiores.wlk) 
	*/
	
    method posicionArbitraria() {
        return game.at(
            0.randomUpTo(game.width()).truncate(0), 0.randomUpTo(game.height()-1).truncate(0)
        )
    }
}

class FondoNivel inherits Elemento {
	
	/** 
		Creación de fondos para los niveles.
		Notar que como todo elemento, no se puede pisar, ni es ninguno de los tipos descriptos pero si se puede superponer (ver movimiento elementos).
	*/
	
	var property image
	
	override method interactuar() {}
	
	override method puedeSuperponer() = true
}