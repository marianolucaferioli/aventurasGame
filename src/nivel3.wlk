import wollok.game.*
import gerardo.*
import celdasEspeciales.*
import barrasSuperiores.*
import elementos.*
import direcciones.*
import utilidades.*
import bichosYComida.*
import nivelPerder.*
import ganarJuego.*


object inicioNivel3 {
	method configurate() {
		
		game.addVisual(interfazInicioNivel3)
		
		keyboard.enter().onPressDo({ interfazInicioNivel3.seleccionar() })
	}
}

object interfazInicioNivel3 {
	var property seleccion = 1
	
	method position() = game.at(0,0)
	
	method image() {
		var imagen
		
		if (seleccion == 1) {
			imagen = "comienzo_nivel3_1.png"
		} else if (seleccion == 2) {
			imagen = "comienzo_nivel3_2.png"
		}
		return imagen 
	}
	
	method seleccionar() {
		if (seleccion == 1) {
			self.seleccion(2)
		} else if (seleccion == 2) {
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
		const plagas = #{/*Son llamadas en tiempo de ejecución*/}	// acepta hasta 15 plagas
		
		// Cada 3 segundos invoca una nueva plaga
		game.onTick(3000, "Invocar plaga", {
			if (plagas.size() < 15) {
				const unaPlaga = geroParca.llamarPlaga()
				plagas.add(unaPlaga)
				game.addVisual(unaPlaga)
				unaPlaga.moverAleatorioCada(400)	// cada 400 milisegundos se mueve
			}
		})
		
		game.onTick(1, "Corroborar plagas", {	// Libera espacio para nuevas plagas
			plagas.forEach{plaga => 
				if (not game.hasVisual(plaga)) {
					plagas.remove(plaga)
				}
			}
		})
		
		/** Granadas brindadas por Pepucha */
		const granadas = #{/*La genera en tiempo de ejecución */}  // acepta hasta 1 granada
		 // cada 4 segundos crea una granada (si no hay ninguna en el mapa ni en el bolsillo de gerardo)
		game.onTick(4000, "Invocar granada", {	
			if (granadas.size() < 1 and not gerardo.tieneGranada()) {
				const granada = pepucha.brindarGranada()
				game.addVisual(granada)
				granadas.add(granada)
			}
		})
		
		game.onTick(1, "Corroborar granadas", {		// Libera espacio para nuevas granadas
			granadas.forEach{granada => 
				if (not game.hasVisual(granada)) {
					granadas.remove(granada)
				}
			}
		})
		
		/** Corazones brindados por Pepucha */
		const corazones = #{} // acepta hasta 3 corazones
		 // cada 3 segundos
		game.onTick(3000, "Invocar corazon", {
			if (corazones.size() < 3) {
				const corazon = pepucha.brindarCorazon()
				game.addVisual(corazon)
				corazones.add(corazon)
			}
		})
		
		game.onTick(1, "Corroborar corazones", {		// Libera espacio para nuevos corazones
			corazones.forEach{corazon => 
				if (not game.hasVisual(corazon)) {
					corazones.remove(corazon)
				}
			}
		})
		
		/** Agregado y seteo de Gerardo y barra superior */	
		game.addVisual(gerardo)
		self.setGerardo()
		self.agregarBarra()
		
		
		/** En este nivel gerardo no pierde energía */
		keyboard.up().onPressDo({ 
			gerardo.move(up)
			gerardo.sumarEnergia(1)		// Para que no le reste energía en este nivel
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
	
		// Agarra granadas o las tira según corresponda (si tiene una granada en mano, no puede agarrrar un corazón)
		keyboard.e().onPressDo({  
			if (gerardo.tieneGranada()) {
				gerardo.tirarGranada()
			} else {
				gerardo.agarrar()
			}
		})
		
		// Resetea el nivel actal
		keyboard.r().onPressDo({ self.restart() })	
		// Para probar ganar
		keyboard.t().onPressDo({self.ganarALaFuerza()})
		// Para probar perder
		keyboard.y().onPressDo({self.perderALaFuerza()})	
		
		game.onTick(1, "Mostrar granada", { self.mostrarGranada() })
	
		/** Agregado y seteo de Gero "La parca" Picón */
		game.addVisual(geroParca)
		geroParca.salud(5)
		geroParca.position(game.origin())
		
		game.onCollideDo(geroParca, {e => e.interactuar()})
		
		game.onCollideDo(gerardo, {objeto => gerardo.interactuar(objeto)})
		
		game.onTick(1000, "Mover gero", { geroParca.moverHaciaGerardo() })
		
		game.onTick(1, "Ganar", { self.ganarSiCorresponde() })
		
		game.onTick(1, "Perder", { self.perderSiCorresponde() })
	}
	
	method setGerardo() {
		gerardo.position(game.center())
		gerardo.energia(50)
		gerardo.salud(100)
		gerardo.tieneGranada(false)
	}
	
	method agregarBarra() {
		// Salud y energía de Gerardo
		game.addVisual(barraDeSalud)
		game.addVisual(barraSaludGero)
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
	
	method moverAleatorio(objeto, milisegundos) {
		if (game.hasVisual(objeto)) {
			game.onTick(milisegundos, "Movimiento aleatorio", { objeto.moverAleatorio() })
		}
	}
	
	method ganarSiCorresponde() {
		if (gerardo.puedeGanarNivel3()) {
			game.schedule(2000, {
				game.say(gerardo, "Ganamo Pepucha!")
				game.schedule(3500, {
					game.clear()
					inicioGanarJuego.configurate()
				})
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
	
	method ganarALaFuerza() {
		geroParca.salud(0)
		game.removeVisual(geroParca)
		game.schedule(2000, {
			game.say(gerardo, "Ganamo Pepucha!")
			game.schedule(3500, {
				game.clear()
				inicioGanarJuego.configurate()
			})
		})	
	}
	
	method perderALaFuerza() {
		game.schedule(2000, {game.say(gerardo, "Gero la p*** madre!")})
		game.schedule(3500, {
			game.clear()
			nivelPerder.configurate()
		})
	}
}