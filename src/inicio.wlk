import wollok.game.*
import elementos.*
import nivel1.*
import sonidos.*

object inicio {
	method configurate() {
		
		/** 

			Configuración inicial
			Cada elemento de la interfaz pretende conformar un menú interactivo para el inicio
			de cada nivel del juego:  ver interfazInicio.image() y la interaccion con la tecla enter.

		*/
		
		game.addVisual(interfazInicio)
			
		keyboard.up().onPressDo({interfazInicio.seleccionar("seleccionar_iniciar")})
		keyboard.down().onPressDo({interfazInicio.seleccionar("seleccionar_controles")})
		
		keyboard.enter().onPressDo({interfazInicio.seleccionar()})
		
		musicaFondoNivel1.sonar()
	}
}

object interfazInicio {
	var seleccion = "seleccionar_iniciar"
	
	method position() = game.at(0,0)
	
	method image() {
		var imagen
		
		if (seleccion == "seleccionar_iniciar") {
			imagen = "inicio_INICIAR.png"
		} else if (seleccion == "seleccionar_controles") {
			imagen = "inicio_CONTROLES.png"
		} else if (seleccion == "controles") {
			imagen = "panel_CONTROLES.png"
		} else if (seleccion == "comienzo_nivel1") {
			imagen = "comienzo_nivel1.png"
		}
		return imagen
	}
	
	method seleccionar(opcion) {
		seleccion = opcion
	}
	
	method seleccionar() {
		if (seleccion == "seleccionar_controles") {
			self.seleccionar("controles")
		} else if (seleccion == "controles") {
			self.seleccionar("seleccionar_iniciar")
		} else if (seleccion == "seleccionar_iniciar") {
			game.clear()
			inicioNivel1.configurate()
		}
	}
}