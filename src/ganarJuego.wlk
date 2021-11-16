import wollok.game.*
import sonidos.*

object inicioGanarJuego {
	method configurate() {
		//musicaFondoNivel3.parar()
		//musicaFondoGanar.sonar()
		game.addVisual(interfazGanar)
		
		keyboard.enter().onPressDo({ interfazGanar.seleccionar() })		
	}
}

object interfazGanar {
	var property seleccion = 1
	
	method position() = game.at(0,0)
	
	method image() {
		var imagen
		
		if (seleccion == 1) {
			imagen = "ganar_1.png"
		} else if (seleccion == 2) {
			imagen = "ganar_2.png"
		}
		return imagen 
	}
	
	method seleccionar() {
		if (seleccion == 1) {
			self.seleccion(2)
		} else if (seleccion == 2) {
			game.stop()
		}
	}
}