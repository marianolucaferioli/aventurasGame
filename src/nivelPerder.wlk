import wollok.game.*
import inicio.*
import utilidades.*
import nivel1.*
import sonidos.*

object nivelPerder {
	
	/** En cualquier nivel que pierda se configura */
	
	method configurate() {
		
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "gameOver.png"))
	
		keyboard.enter().onPressDo({
			game.clear()
			interfazInicioNivel1.seleccion(1)
			//No considera si vuelve a perder luego de un reinicio.
			if (musicaFondoNivel3.played()){
				musicaFondoNivel3.parar()
			} else if (musicaFondoNivel2.played()){
				musicaFondoNivel2.parar()	
			} else {
				musicaFondoNivel1.parar()	
			}
			inicio.configurate()
			musicaFondoNivel11.sonar()
		})
	}
} 