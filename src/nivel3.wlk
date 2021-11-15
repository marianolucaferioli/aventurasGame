import wollok.game.*
import gerardo.*
import celdasEspeciales.*
import barrasSuperiores.*
import elementos.*
import direcciones.*
import fondo.*
import bichosYComida.*
import nivelPerder.*
import ganarJuego.*


object inicioNivel3 {
	method configurate() {
		
		game.addVisual(interfazInicioNivel3)
		
		keyboard.enter().onPressDo({ interfazInicioNivel3.seleccionar() })
	}
}
/** CORREGIR LO DE LAS GRANADAS INTERACTUAR()  */

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

/** ************************* INICIO DE NIVEL 3 ************************** **/

object nivel3 {
	method configurate() {
		
		/** Fondo nivel */
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "ladrillo.png"))
		
		/** Plagas llamadas por Gerónimo */
		var plagas = #{/*Son llamadas en tiempo de ejecución*/}
		
		// Cada 5.5 segundos invoca una nueva plaga
		game.onTick(5500, "Invocar plaga", {
			const unaPlaga = geroParca.llamarPlaga()
			plagas.add(unaPlaga)
			game.addVisual(unaPlaga)
			unaPlaga.moverAleatorioCada(750)
		})
		
		const granadas = #{}  // acepta hasta tres granadas
		 // cada 2.5 segundos
		game.onTick(2500, "Invocar granada", {	
			if (granadas.size() < 3) {
				const granada = pepucha.brindarGranada()
				game.addVisual(granada)
				granadas.add(granada)
			}
		})
		
		game.onTick(1, "Corroborar granadas", {
			granadas.forEach{granada => 
				if (not game.hasVisual(granada)) {
					granadas.remove(granada)
				}
			}
		})
		
		//granadas.forEach{granada => game.onCollideDo(granada, {e => e.interactuar()})}
		
		const corazones = #{} // acepta hasta 3 corazones
		 // cada 2.5 segundos
		game.onTick(2500, "Invocar corazon", {
			if (corazones.size() < 3) {
				const corazon = pepucha.brindarCorazon()
				game.addVisual(corazon)
				corazones.add(corazon)
			}
		})
		
		game.onTick(1, "Corroborar corazones", {
			corazones.forEach{corazon => 
				if (not game.hasVisual(corazon)) {
					corazones.remove(corazon)
				}
			}
		})
		
		/** Agregado de Gerardo e interacción con los objetos */	
		game.addVisual(gerardo)
		
		
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
		
		game.onCollideDo(geroParca, {e => e.interactuar()})
		
		game.onCollideDo(gerardo, {objeto => gerardo.interactuar(objeto)})
		
		game.onTick(1000, "Mover gero", { geroParca.moverHaciaGerardo() })
		
		game.onTick(1, "Ganar", { self.ganarSiCorresponde() })
		
		game.onTick(1, "Perder", { self.perderSiCorresponde() })
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
	
	method ganarSiCorresponde() {
		if (geroParca.salud() == 0) {
			game.schedule(2500, {
				game.say(gerardo, "Ganamo Pepucha!")
				game.clear()
				inicioGanarJuego.configurate()
			})
		}
	}
	
	method perderSiCorresponde() {
		if (gerardo.salud() == 0) {
			game.schedule(2000, {game.say(gerardo, "Gero la p*** madre!")})
			game.schedule(3500, {
				game.clear()
				nivelPerder.configurate()
			})
		}
	}
	
	method moverAleatorio(objeto, milisegundos) {
		if (game.hasVisual(objeto)) {
			game.onTick(milisegundos, "Movimiento aleatorio", { objeto.moverAleatorio() })
		}
	}
}