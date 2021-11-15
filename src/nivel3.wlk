import wollok.game.*
import gerardo.*
import celdasEspeciales.*
import barrasSuperiores.*
import elementos.*
import direcciones.*
import fondo.*
import bichosYComida.*
import nivelPerder.*
//import ganarJuego.*

object inicioNivel3 {
	method configurate() {
		
		game.addVisual(interfazInicioNivel3)
		
		keyboard.enter().onPressDo({ interfazInicioNivel3.seleccionar() })
	}
}

object interfazInicioNivel3 {
	var property seleccion = "comienzo_1"
	
	method position() = game.at(0,0)
	
	method image() {
		var imagen
		
		if (seleccion == "comienzo_1") {
			imagen = "comienzo_nivel3_1.png"
		} else if (seleccion == "comienzo_2") {
			imagen = "comienzo_nivel3_2.png"
		}
		return imagen 
	}
	
	method seleccionar() {
		if (seleccion == "comienzo_1") {
			self.seleccion("comienzo_2")
		} else if (seleccion == "comienzo_2") {
			game.clear()
			nivel3.configurate()
		}
	}
}

object nivel3 {
	method configurate() {
		
		/** Fondo nivel */
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "ladrillo.png"))
		
		/** Agregado de Gerardo e interacción con los objetos */	
		game.addVisual(gerardo)
		
		game.onCollideDo(gerardo, {objeto => gerardo.interactuar(objeto)})
		
		self.setGerardo()
		
		self.agregarBarra()
		
		
		/** En este nivel gerardo no pierde energía */
		keyboard.up().onPressDo({ 
			gerardo.move(up)
			gerardo.sumarEnergia(1)
		})
		keyboard.down().onPressDo({ 
			gerardo.move(down)
			gerardo.sumarEnergia(1)
		})
		keyboard.right().onPressDo({ 
			gerardo.move(right)
			gerardo.sumarEnergia(1)
		})
		keyboard.left().onPressDo({ 
			gerardo.move(left)
			gerardo.sumarEnergia(1)
		})
	
		// Agarra granadas o las tira según corresponda
		keyboard.e().onPressDo({  
			if (gerardo.tieneGranada()) {
				gerardo.tirarGranada()
			} else {
				gerardo.agarrar()
			}
			
		})
		// Resetea el nivel actal
		keyboard.r().onPressDo({ self.restart() })		
		
		game.onTick(1, "Mostrar granada", { self.mostrarGranada() })
	
		game.addVisual(geroParca)
		geroParca.position(game.origin())
		
		game.onTick(1000, "Mover gero", { geroParca.moverHaciaGerardo() })
	}
	
	method setGerardo() {
		gerardo.energia(50)
		gerardo.salud(100)
		gerardo.tieneGranada(false)
	}
	
	method agregarBarra() {
		// Salud y energía de Gerardo
		game.addVisual(barraDeSalud)
	}
	
	method mostrarGranada() {
		if (gerardo.tieneGranada() and not game.hasVisual(cont_granada)) {
			game.addVisual(cont_granada)
		} else if ( not gerardo.tieneGranada() and game.hasVisual(cont_granada)) {
			game.removeVisual(cont_granada)
		}
	}
	
	method restart() {
		game.clear()
		self.configurate()
	}
}






















