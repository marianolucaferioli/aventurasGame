import wollok.game.*
import gerardo.*
import celdasEspeciales.*
import barrasSuperiores.*
import elementos.*
import direcciones.*
import fondo.*
import bichosYComida.*
import nivelPerder.*
import nivel2.*
import sonidos.*

object inicioNivel1 {
	method configurate() { 
		
		game.addVisual(interfazInicioNivel1)
		
		keyboard.enter().onPressDo({ interfazInicioNivel1.seleccionar() })
	}
}

object interfazInicioNivel1 {
	var property seleccion = "comienzo_1"
	
	method position() = game.at(0,0)
	
	method image() {
		var imagen
		
		if (seleccion == "comienzo_1") {
			imagen = "comienzo_nivel1_1.png"
		} else if (seleccion == "comienzo_2") {
			imagen = "comienzo_nivel1_2.png"
		} else if (seleccion == "comienzo_3") {
			imagen = "comienzo_nivel1_3.png"
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
			nivel1.configurate()
		}
	}
}

/** ************************* INICIO DE NIVEL1 ************************** **/

object nivel1 {
	method configurate() {
		
		/** Fondo nivel */
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "ladrillo.png"))
		
		/** Celdas especiales */
		const celdaBuena = new CeldaBuena()
		const celdaMala = new CeldaMala()
		const celdaDeAparicion = new CeldaDeAparicion()
		const celdaDeTeletransportacion = new CeldaDeTeletransportacion()
		
		const celdasEspeciales = #{celdaBuena, celdaMala, celdaDeAparicion, celdaDeTeletransportacion}
		
		/** Depósitos */ 
		const depo1 = new Deposito(llavesRecuperadas = 0, cajasRecuperadas = 0)
		const depo2 = new Deposito(llavesRecuperadas = 0, cajasRecuperadas = 0)
		const depo3 = new Deposito(llavesRecuperadas = 0, cajasRecuperadas = 0)
		
		const depositos = #{depo1, depo2, depo3}
		
		/** Cajas */
		const caja1 = new Caja() 
		const caja2 = new Caja()
		const caja3 = new Caja()
		
		const cajas = #{caja1, caja2, caja3}
		
		/** Llaves */
		const llave1 = new Llave()
		const llave2 = new Llave()
		const llave3 = new Llave()
		
		const llaves = #{llave1, llave2, llave3}
		
		/** Bichos */
		const pulga = new Pulga()
		const garrapata = new Garrapata()
		const cucaracha = new Cucaracha()
		const mosquito = new Mosquito() 
		
		const bichosMalos = #{pulga, garrapata, cucaracha, mosquito}
		
		/** Comida */
		const garbanzo = new Garbanzo()	
		const empanada = new Empanada()
		const birra = new Birra()
		const cocacola = new Cocacola()
		
		const comidas = #{garbanzo, empanada, birra, cocacola}
		
		/** Pepucha */
		//const pepucha = new Pepucha()
	
		///////////////////////////////////////////////////////////////
		
		/**  Agregado de elementos */
		celdasEspeciales.forEach{celda => game.addVisual(celda)}
		cajas.forEach{caja => game.addVisual(caja)}
		depositos.forEach{depo => game.addVisual(depo)}
		llaves.forEach{llave => game.addVisual(llave)}
		bichosMalos.forEach{bicho => game.addVisual(bicho)}
		comidas.forEach{comida => game.addVisual(comida)}

		/** Agregado de pepucha */
		game.addVisual(pepucha)
		
		/** Seteo de posiciones aleatorias según parámetros especificados */ 
		celdasEspeciales.forEach{celda => celda.setNewRandomPosition()}
		cajas.forEach{caja => caja.setNewRandomPosition()}
		depositos.forEach{depo => depo.setNewRandomPosition()}
		llaves.forEach{llave => llave.setNewRandomPosition()}
		bichosMalos.forEach{bicho => bicho.setNewRandomPosition()}
		comidas.forEach{comida => comida.setNewRandomPosition()}
		
		/** Seteo de atributes y posición de Pepucha */
		pepucha.setNewRandomPosition()
		pepucha.setPepucha()
		
		/** Activacion del movimiento aleatorio para "bichos" */
		self.moverAleatorio(pepucha, 1000)
		
		bichosMalos.forEach{ bicho => bicho.moverAleatorioCada(1000) }		// SI ROMPE SACAR
		 
		/////////
		
		/** Seteo de atributos de gerardo y agregado de barra superior */
		self.setGerardo()
		self.agregarBarra()
		
		/** Agregado de Gerardo e interacción con los objetos */	
		game.addVisual(gerardo)
		
		game.onCollideDo(gerardo, {objeto => gerardo.interactuar(objeto)})
		// Unicamente funciona con elementos que son "caja"
		cajas.forEach{caja => game.onCollideDo(caja, {depo => depo.ingresarCaja()})}
		
		
		/** Definicion de teclas */
		keyboard.up().onPressDo({ gerardo.move(up) })
		keyboard.down().onPressDo({ gerardo.move(down) })
		keyboard.right().onPressDo({ gerardo.move(right) })
		keyboard.left().onPressDo({ gerardo.move(left) })
		
		// Agarra elementos agarrables
		keyboard.e().onPressDo({  gerardo.agarrar() })
		// Resetea el nivel acutal
		keyboard.r().onPressDo({ self.restart() })		
		// Para probar ganar
		keyboard.t().onPressDo({self.ganarALaFuerza()})
		// Para probar perder
		keyboard.y().onPressDo({self.perderALaFuerza()})
		
		/** Mostrar llaves y cajas recuperadas */
		game.onTick(1, "Mostrar llaves", { self.mostrarLlaves()})
		
		game.onTick(1, "Mostrar cajas", { self.mostrarCajas() })
		
		/** Ganar o perder cuando corresponda */
		game.onTick(1, "Ganar", { self.ganarSiCorresponde() })
		
		game.onTick(1, "Perder", { self.perderSiCorresponde() })
	}
	
		/** ******************************** **/
	
	method setGerardo() {
		
		// Gerardo
		gerardo.energia(30)
		gerardo.salud(100)
		gerardo.llavesEncontradas(0)
		gerardo.cajasEncontradas(0)
		gerardo.llavesEntregadas(0)
		
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
	
	method mostrarCajas() {
		const cajas = gerardo.cajasEncontradas() 
		
		if (cajas == 1 and not game.hasVisual(cont_caja1)) { game.addVisual(cont_caja1) }
		if (cajas == 2 and not game.hasVisual(cont_caja2)) { game.addVisual(cont_caja2) }
		if (cajas == 3 and not game.hasVisual(cont_caja3)) { game.addVisual(cont_caja3) }
	}
	
	method mostrarLlaves() {
		const llaves = gerardo.llavesEncontradas()
		
		if (llaves == 1 and not game.hasVisual(cont_llave1)) { game.addVisual(cont_llave1) }
		if (llaves == 2 and not game.hasVisual(cont_llave2)) { game.addVisual(cont_llave2) }
		if (llaves == 3 and not game.hasVisual(cont_llave3)) { game.addVisual(cont_llave3) }
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
		if (gerardo.llavesEntregadas() == 3 and gerardo.cajasEncontradas() == 3) {
			game.schedule(2000, {
				game.say(gerardo, "Listo el pollo!")
			})
			game.schedule(5000, {
				game.clear()
				finNivel1.configurate()
			})
		}
	}
	
	method perderSiCorresponde() {
		if (gerardo.salud() == 0) {
			game.say(gerardo, "Ay la Pepucha!")
			game.schedule(1000, {
				game.clear()
				nivelPerder.configurate()
			})
		}
	}
	
	method ganarALaFuerza() {
		game.schedule(2000, {
				game.say(gerardo, "Listo el pollo!")
			})
			game.schedule(5000, {
				game.clear()
				finNivel1.configurate()
			})
	}
	
	method perderALaFuerza() {
		game.say(gerardo, "Ay la Pepucha!")
			game.schedule(1000, {
				game.clear()
				nivelPerder.configurate()
			})
	}
}

/** ********************** FIN DEL NIVEL 1 CONFIGURACION DEL 2 ************************** **/

object finNivel1 {
	method configurate() {
		
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "ganarNivel1.png"))
		
		keyboard.enter().onPressDo({
			game.clear()
			inicioNivel2.configurate()
			//Esto es necesario para parar la música del nivel 1 la primera o segunda vez que suena.
			if (musicaFondoNivel11.played()){
				musicaFondoNivel11.parar()
			} else if (musicaFondoNivel1.played()){
				musicaFondoNivel1.parar()
			}
			//Esto es necesario para que vuelva a sonar la música del nivel 2 por segunda vez.
			if (not musicaFondoNivel2.played()){
				musicaFondoNivel2.sonar()
			} else if (not musicaFondoNivel22.played()){
				musicaFondoNivel22.sonar()
			}
		})
	}
}