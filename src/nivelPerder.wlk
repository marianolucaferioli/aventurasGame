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
			if (musicaFondoNivel3.played()){
				musicaFondoNivel3.parar()
			} else {
				musicaFondoNivel2.parar()	
			}
			inicio.configurate()
			musicaFondoNivel11.sonar()
		})
	}
} 