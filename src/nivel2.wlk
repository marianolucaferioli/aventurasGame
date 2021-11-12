import wollok.game.*
import gerardo.*
import celdasEspeciales.*
import utilidades.*
import barrasSuperiores.*
import elementos.*
import direcciones.*
import fondo.*
import bichosYComida.*
import nivelPerder.*

object inicioNivel2 {
	method configurate() {
		
		game.addVisual(interfazInicioNivel2)
		
		keyboard.enter().onPressDo({ interfazInicioNivel2.seleccionar() })
	}
}

object interfazInicioNivel2 {
	var property seleccion = "comienzo_1"
	
	method position() = game.at(0,0)
	
	method image() {
		var imagen
		
		if (seleccion == "comienzo_1") {
			imagen = "comienzo_nivel2_1.png"
		} else if (seleccion == "comienzo_2") {
			imagen = "comienzo_nivel2_2.png"
		} else if (seleccion == "comienzo_3") {
			imagen = "comienzo_nivel2_3.png"
		}
		return imagen 
	}
	
	method seleccionar() {
		if (seleccion == "comienzo_1") {
			self.seleccion("comienzo_2")
		} else if (seleccion == "comienzo_2") {
			self.seleccion("comienzo_3")
		} else if (seleccion == "comienzo_3") {
			game.clear()
			nivel2.configurate()
		}
	}
}

/** *********************************************************************** **/

object nivel2 {
	method configurate() {
		
		// Fondo
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "ladrillo.png"))
		
		// Bichos
		const alumnos = #{cande, marian, gero, enzo}	// Así nos conoce la cara profe!
		
		const corazon1 = new Corazon()
		const corazon2 = new Corazon()
		const corazon3 = new Corazon()
		
		const corazones = #{corazon1, corazon2, corazon3}
		
		const coca1 = new Cocacola()
		const coca2 = new Cocacola()
		const coca3 = new Cocacola()
		
		const cocas = #{coca1, coca2, coca3}
		
		
		alumnos.forEach{alumno => game.addVisual(alumno)}
		corazones.forEach{corazon => game.addVisual(corazon)}
		
		alumnos.forEach{alumno => alumno.setNewRandomPosition()}
		corazones.forEach{corazon => corazon.setNewRandomPosition()}
		
		cocas.forEach{coca => game.addVisual(coca)}
		cocas.forEach{coca => coca.setNewRandomPosition()}
		
		alumnos.forEach{alumno => game.onTick(5000, "Mostrar monedas", { alumno.atrapameSiPodes() })}
		
		
		// Gerardo
		game.addVisual(gerardo)
		
		game.onCollideDo(gerardo, {objeto => gerardo.interactuar(objeto)})

		keyboard.up().onPressDo({ gerardo.move(up)})
		keyboard.down().onPressDo({gerardo.move(down)})
		keyboard.right().onPressDo({ gerardo.move(right)})
		keyboard.left().onPressDo({ gerardo.move(left)})
		
		keyboard.e().onPressDo({gerardo.agarrar()})
		
		keyboard.r().onPressDo({ self.restart() })
		
		self.setGerardo()
		
		self.agregarBarra()
		
		self.mostrarMonedas()
		
		alumnos.forEach{alumno => self.moverAleatorio(alumno, 1000)}
		
		
		
		game.onTick(1, "Mostrar monedas", { self.mostrarMonedas() })		

		game.onTick(1, "Mostrar puerta", { self.aparecerPuerta() })
		
		// el ganar si corresponde es que aparezca la puerta y la pise
		
		game.onTick(1, "Perder si corresponde", { self.perderSiCorresponde() })		
		
		// Para probar ganar
		keyboard.t().onPressDo({self.ganarALaFuerza()})
		// Para probar perder
		keyboard.y().onPressDo({self.perderALaFuerza()})
	}
	
	method setGerardo() {
		
		// Gerardo
		gerardo.energia(30)
		gerardo.salud(100)
		gerardo.monedas(0)
		
		// esto si se quiere setear
		gerardo.position(game.center())
		gerardo.direccion(right)
	}
	
	method agregarBarra() {
		// Salud y energía de Gerardo
		game.addVisual(barraDeSalud)
		game.addVisual(rayito)
		game.addVisual(contadorEnergia1)
		game.addVisual(contadorEnergia2)
	}
	
	method mostrarMonedas() {
		const monedas = gerardo.monedas()
		
		if (monedas == 1 and not game.hasVisual(cont_moneda1)) { game.addVisual(cont_moneda1) }
		if (monedas == 2 and not game.hasVisual(cont_moneda2)) { game.addVisual(cont_moneda2) }
		if (monedas == 3 and not game.hasVisual(cont_moneda3)) { game.addVisual(cont_moneda3) }
		if (monedas == 4 and not game.hasVisual(cont_moneda4)) { game.addVisual(cont_moneda4) }
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
	
	method ganarALaFuerza() {
		game.schedule(2000, {
				game.addVisual(puertaNivel2)
				gerardo.position(puertaNivel2.position())
				game.say(puertaNivel2, "Felicitaciones!")
			})
			game.schedule(5000, {
				game.clear()
				finNivel2.configurate()
			})
	}
	
	method perderALaFuerza() {
		game.say(gerardo, "Que alumnos malos!")
			game.schedule(2000, {
				game.clear()
				nivelPerder.configurate()
			})
	}
	
	method perderSiCorresponde() {
		if (gerardo.salud() == 0 or gerardo.energia() == 0) {
			game.say(gerardo, "Pero que alumnos malos!")
			game.schedule(3000, {
				game.clear()
				nivelPerder.configurate()
			})
		}
	}
	
	method aparecerPuerta() {
		if (gerardo.monedas() == 4 and not puertaNivel2.estaEnElNivel()) {
			puertaNivel2.estaEnElNivel(true)
			game.addVisual(puertaNivel2)
			puertaNivel2.setNewRandomPosition()
			game.say(puertaNivel2, "Ya podés entrar Gerardo!")
		}
	}
	
}

object finNivel2 {
	method configurate() {
		/** configurar */
		return 0
	}
}






/**


implementar alumnos
--> alumnos.interactuar --> resta salud Y da moneda

--> mostrar monedas

--> tras obtencion 4 monedas aparece puerta --> ganar nivel

--> agregar corazones
 */
