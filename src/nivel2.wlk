import wollok.game.*
import gerardo.*
import celdasEspeciales.*
import barrasSuperiores.*
import elementos.*
import direcciones.*
import utilidades.*
import bichosYComida.*
import nivelPerder.*
import nivel3.*
import sonidos.*

object inicioNivel2 {
	method configurate() {
		
		game.addVisual(interfazInicioNivel2)
		
		keyboard.enter().onPressDo({ interfazInicioNivel2.seleccionar() })
	}
}

object interfazInicioNivel2 {
	var property seleccion = 1
	
	method position() = game.at(0,0)
	
	method image() {
		var imagen
		
		if (seleccion == 1) {
			imagen = "comienzo_nivel2_1.png"
		} else if (seleccion == 2) {
			imagen = "comienzo_nivel2_2.png"
		} else if (seleccion == 3) {
			imagen = "comienzo_nivel2_3.png"
		}
		return imagen 
	}
	
	method seleccionar() {
		if (seleccion == 1) {
			self.seleccion(2)
		} else if (seleccion == 2) {
			self.seleccion(3)
		} else if (seleccion == 3) {
			game.clear()
			nivel2.configurate()
		}
	}
}

/** ************************* INICIO DE NIVEL2 ************************** **/

object nivel2 {
	method configurate() {
		
		/** Fondo nivel */
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "ladrillo.png"))
		
		/** Bichos */
		const alumnos = #{cande, marian, gero, enzo}	// Así nos conoce la cara profe!
		
		/** Salud y energía (corazones y cocas) */
		const corazon1 = new Corazon()
		const corazon2 = new Corazon()
		const corazon3 = new Corazon()
		
		const corazones = #{corazon1, corazon2, corazon3}
		
		const coca1 = new Cocacola()
		const coca2 = new Cocacola()
		const coca3 = new Cocacola()
		
		const cocas = #{coca1, coca2, coca3}
		
		///////////////////////////////////////////////////////////////
		
		/**  Agregado de elementos */
		alumnos.forEach{alumno => game.addVisual(alumno)}
		corazones.forEach{corazon => game.addVisual(corazon)}
		cocas.forEach{coca => game.addVisual(coca)}
		
		/** Seteo de posiciones aleatorias según parámetros especificados */ 
		alumnos.forEach{alumno => alumno.setNewRandomPosition()}
		corazones.forEach{corazon => corazon.setNewRandomPosition()}
		cocas.forEach{coca => coca.setNewRandomPosition()}
		
		/** Activación de mensajes y movimiento de alumnos */
		alumnos.forEach{alumno => game.onTick(5000, "Atrapame si podés!", { alumno.atrapameSiPodes() })} // ver alumno.atrapameSiPodes()
		
		alumnos.forEach{alumno => self.moverAleatorio(alumno, 1000)}
		
		/////////
		
		/** Agregado y seteo de gerardo y barra superior */
		game.addVisual(gerardo)
		self.setGerardo()
		self.agregarBarra()
		
		/** Interacción de Gerardo con los objetos */
		game.onCollideDo(gerardo, {objeto => gerardo.interactuar(objeto)})
		
		/** Definición de teclas */
		keyboard.up().onPressDo({ gerardo.move(up)})
		keyboard.down().onPressDo({gerardo.move(down)})
		keyboard.right().onPressDo({ gerardo.move(right)})
		keyboard.left().onPressDo({ gerardo.move(left)})
		
		// Agarra elementos agarrables
		keyboard.e().onPressDo({gerardo.agarrar()})
		// Resetea el nivel acutal
		keyboard.r().onPressDo({ self.restart() })
		// Para probar ganar
		keyboard.t().onPressDo({self.ganarALaFuerza()})
		// Para probar perder
		keyboard.y().onPressDo({self.perderALaFuerza()})
	
		/** Mostrar monedas obtenidas y puerta */
		game.onTick(1, "Mostrar monedas", { self.mostrarMonedas() })		

		game.onTick(1, "Mostrar puerta", { self.aparecerPuerta() })
		
		/** Perder si corresponde ( para ganar --> puerta.interactuar() )  */
		game.onTick(1, "Perder si corresponde", { self.perderSiCorresponde() })		
	}
	
	method setGerardo() {
		
		// Gerardo
		gerardo.energia(30)
		gerardo.salud(100)
		gerardo.monedas(0)
		
		// Posición y dirección
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
	
	/** Gana si interactúa */
	method aparecerPuerta() {
		if (gerardo.puedeGanarNivel2() and not puertaNivel2.estaEnElNivel()) {
			puertaNivel2.estaEnElNivel(true)
			game.addVisual(puertaNivel2)
			puertaNivel2.setNewRandomPosition()
			game.say(puertaNivel2, "Venga profe nomás...!")
		}
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
	
	method ganarALaFuerza() {
		game.schedule(2000, {
			game.addVisual(puertaNivel2)
			gerardo.position(puertaNivel2.position())
			game.say(puertaNivel2, "Venga profe nomás...")
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
}

/** ********************** FIN DEL NIVEL 2 CONFIGURACION DEL 3 ************************** **/

object finNivel2 {
	method configurate() {
		
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "ganarNivel2.png"))
		
		keyboard.enter().onPressDo({
			game.clear()
			inicioNivel3.configurate()
			//Esto es necesario para parar la música del nivel 2 la primera o segunda vez que suena.
			if (musicaFondoNivel22.played()){
				musicaFondoNivel22.parar()
			} else if (musicaFondoNivel2.played()){
				musicaFondoNivel2.parar()
			}
			//Esto es necesario para que vuelva a sonar la música del nivel 3 por segunda vez.
			if (not musicaFondoNivel3.played()){
				musicaFondoNivel3.sonar()
			} else if (not musicaFondoNivel33.played()){
				musicaFondoNivel33.sonar()
			}
		})
	}
}