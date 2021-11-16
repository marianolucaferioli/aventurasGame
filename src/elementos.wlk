import wollok.game.*
import celdasEspeciales.*
import gerardo.*
import direcciones.*
import utilidades.*
import nivel2.*
import bichosYComida.*

/** Clase padre (abstracta) */
class Elemento {				
	
	var property position = game.center()		// Inicia el en centro para luego darle una posicion aleatoria
	
	method puedeSuperponer() = false		// ver elemento.setNewRandomPosition() (ln. 30)
	
	method sePuedePisar() = false			// ver bichosYComidas.wlk --> bicho.moverAleatorio()
	
	method image()
	
	/** ************************** **/
	
	// Validaciones de tipos
	method esGerardo() = false
	
	method esCaja() = false
	
	method esLlave() = false
	
	method esCeldaEspecial() = false
	
	method esComida() = false
	
	method esBicho() = false
	
	method esGranada() = false
	
	method esGeroParca() = false
	
	/** ************************** **/
	
	method setNewRandomPosition() {
		const newPosition = utilidadesParaJuego.posicionArbitraria()
		
		// no permite crear elementos en la celda del medio ni en la celda origen donde se crea el fondo
		if (game.getObjectsIn(newPosition).any{elem => not(elem.puedeSuperponer())} or newPosition == game.center()) {
			self.setNewRandomPosition()
		}
		position = newPosition
	}
	
	method interactuar()
	
	method serAgarrado() {}
	
	method ingresarCaja() {}
}

/** *********************************************************************** **/

class Llave inherits Elemento {
	override method image() = "llavecita.png"
	
	override method esLlave() = true
	
	override method interactuar() {
		game.say(gerardo, "Upa, y esto?")
	}
	
	override method serAgarrado() {
		gerardo.sumarLlaves(1)
		game.say(gerardo, "Vamo encontré una!")
		game.removeVisual(self)
	}
}

/** *********************************************************************** **/

class Deposito inherits Elemento {
	var property llavesRecuperadas = 0
	var property cajasRecuperadas = 0
	
	override method image() = "deposito.png"
	
	// Permite que elementos pasen SOBRE el
	override method sePuedePisar() = true		
	
	// ver nivel1 --> depósito.onCollideDo(caja -> ingresarCaja())
	override method ingresarCaja() {			
		// tener en cuenta que no es posible ingresar mas de una caja a la vez
		const cajas = game.getObjectsIn(self.position()).filter({objeto => objeto.esCaja()})
		
		cajasRecuperadas += cajas.size()
		gerardo.sumarCajas(cajas.size())
		
		cajas.forEach{caja => game.removeVisual(caja)}
		
		if (gerardo.puedeGanarNivel1()) {
			game.say(gerardo, "Listo el pollo!")
		} else {
			game.say(gerardo, "Atroden la caja!")
			game.say(self, "Gracias viejo!")
		}
	}
	
	override method interactuar() {
		// interactua tantas veces como llaves tenga
		if (gerardo.llavesEncontradas() > 0) {
			self.agarrarLlaves()
			self.interactuar()
		}
	}
	
	method agarrarLlaves() {
		if (gerardo.llavesEncontradas() > 0) {
			gerardo.entregarLlaves()
		}
	}
}

/** *********************************************************************** **/

class Caja inherits Elemento {
			
	override method image() = "caja.png"
	
	override method esCaja() = true
	
	override method interactuar() {
		// Efecto pacman de las cajas
		if (self.hayCeldaLibreAl(gerardo.direccion())) {
			self.move(gerardo.direccion())
		} else {
			gerardo.move(gerardo.direccion().opuesto())
			game.say(gerardo, "No puedo mover la caja che!")
		}
	}
	
	method move(dir) {
		if (dir.isUp()) {self.moveUp()}
		else if (dir.isDown()) {self.moveDown()}
		else if (dir.isRight()) {self.moveRight()}
		else {self.moveLeft()}
	}
	
	method moveUp() {
		if (not (self.position().y() == game.height() - 2)) {
			position = self.position().up(1)
		} else {
			position = new Position(x = self.position().x(), y = 0)
		}
	}
	
	method moveDown() {
		if (not (self.position().y() == 0)) {
			position = self.position().down(1)
		} else {
			position = new Position(x = self.position().x(), y = game.height()-2)
		}
	}
	
	method moveRight() {
		if (not (self.position().x() == game.width() - 1)) {
			position = self.position().right(1)
		} else {
			position = new Position(x = 0, y = self.position().y())
		}
	}
	
	method moveLeft() {
		if (not (self.position().x() == 0)) {
			position = self.position().left(1)
		} else {
			position = new Position(x = game.width()-1 , y = self.position().y())
		}
	}
		
	method hayCeldaLibreAl(dir) {
		// Si en la direccion en la que se mueve hay algun elemento que no se puede pisar retorna falso
		var hayCeldaLibre = true
		
		if (dir.isUp()) {
			hayCeldaLibre = game.getObjectsIn(self.position().up(1)).all{obj => obj.sePuedePisar()}
		} else if (dir.isDown()) {
			hayCeldaLibre = game.getObjectsIn(self.position().down(1)).all{obj => obj.sePuedePisar()}
		} else if (dir.isRight()) {
			hayCeldaLibre = game.getObjectsIn(self.position().right(1)).all{obj => obj.sePuedePisar()}
		} else {
			hayCeldaLibre = game.getObjectsIn(self.position().left(1)).all{obj => obj.sePuedePisar()}
		}
		return hayCeldaLibre
	}
}

/** *********************************************************************** **/

object puertaNivel2 inherits Elemento {
	
	var property estaEnElNivel = false
	
	override method image() = "puerta.png"
	
	override method interactuar() {
		/** Notar que permite interactuar únicamente si Gerardo puede ganar el nivel 2 ( ver nivel2 --> aparecerPuerta() ) */
		game.say(gerardo, "...Gero?!")
		game.schedule(2000, { finNivel2.configurate() })
	}
	
}

/** *********************************************************************** **/

class Granada inherits Elemento {
	var property estado = 0  // 0 -> no explota / 1 -> explota

	
	override method sePuedePisar() = true
	
	override method esGranada() = true
	
	override method image() {
		var imagen
		
		if (estado == 0) {
			imagen = "granada.png"
		}
		if (estado == 1) {
			imagen = "explosion.png"
		}
		return imagen
	} 
	
	override method serAgarrado() {
		if (not gerardo.tieneGranada()) {
			gerardo.tieneGranada(true)
			gerardo.granadaEnBolsillo(self)
			game.say(gerardo, "Cuidado con esto!")
			game.removeVisual(self)
		}
	}
	
	method serArrojadaEnDireccion(dir) {
		var movimientos = 0
		
		if (dir.isUp()) {
			self.position(gerardo.position().up(1))
			movimientos += 1
			game.addVisual(self)
			game.onTick(500, "Tirar granada", {
				if (movimientos < 3 and game.hasVisual(self) and self.estado() == 0) {
					self.moveUp()
					movimientos += 1
					if (movimientos == 3) {	// lo pregunta antes para cambiar el estado de la granada y asi su imagen
						self.estado(1)
					}
				} else if (movimientos == 3) {
					movimientos += 1
					game.removeVisual(self)
				}
			})
		}
		if (dir.isDown()) {
			self.position(gerardo.position().down(1))
			game.addVisual(self)
			movimientos += 1
			game.onTick(500, "Tirar granada", {
				if (movimientos < 3 and game.hasVisual(self) and self.estado() == 0) {
					self.moveDown()
					movimientos += 1
					if (movimientos == 3) {	// lo pregunta antes para cambiar el estado de la granada y asi su imagen
						self.estado(1)
					}
				} else if (movimientos == 3) {
					movimientos += 1
					game.removeVisual(self)
				}
			})
		}
		if (dir.isRight()) {
			self.position(gerardo.position().right(1))
			game.addVisual(self)
			movimientos += 1
			game.onTick(500, "Tirar granada", {
				if (movimientos < 3 and game.hasVisual(self) and self.estado() == 0) {
					self.moveRight()
					movimientos += 1
					if (movimientos == 3) {
						self.estado(1)
					}
				} else if (movimientos == 3) {
					movimientos += 1
					game.removeVisual(self)
				}
			})
		}
		if (dir.isLeft()) {
			self.position(gerardo.position().left(1))
			game.addVisual(self)
			movimientos += 1
			game.onTick(500, "Tirar granada", {
				if (movimientos < 3 and game.hasVisual(self) and self.estado() == 0) {
					self.moveLeft()
					movimientos += 1
					if (movimientos == 3) {	
						self.estado(1)
					}
				} else if (movimientos == 3) {
					movimientos += 1
					game.removeVisual(self)
				}
			})
		}
	}
	
	/** Nota: Si Gerardo pisa la granada hace boom. */
	override method interactuar() {

		const elementosAfectados = game.colliders(self)
		
		if (elementosAfectados.contains(gerardo)) {
			gerardo.salud(0)
		}
		if (elementosAfectados.contains(geroParca)) {
			geroParca.recibirGranadazo()
			if (geroParca.salud() == 0) {
				game.say(geroParca, "Esto cuándo lo vimos!?")
				game.schedule(1000, {
					game.removeVisual(geroParca)
				})
			}
		}
		estado = 1
	}
	
	method moveUp() {
		if (not (self.position().y() == game.height() - 2)) {
			position = self.position().up(1)
		} else {
			position = new Position(x = self.position().x(), y = 0)
		}
	}
	
	method moveDown() {
		if (not (self.position().y() == 0)) {
			position = self.position().down(1)
		} else {
			position = new Position(x = self.position().x(), y = game.height()-2)
		}
	}
	
	method moveRight() {
		if (not (self.position().x() == game.width() - 1)) {
			position = self.position().right(1)
		} else {
			position = new Position(x = 0, y = self.position().y())
		}
	}
	
	method moveLeft() {
		if (not (self.position().x() == 0)) {
			position = self.position().left(1)
		} else {
			position = new Position(x = game.width()-1 , y = self.position().y())
		}
	}
}