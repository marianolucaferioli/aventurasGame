import wollok.game.*
import celdasEspeciales.*
import gerardo.*
import direcciones.*
import utilidades.*
import nivel2.*

class Elemento {				/** Clase padre (abstracta) */
	
	var property position = game.center()		// Inicia el en centro para luego darle una posicion aleatoria
	
	method puedeSuperponer() = false		// ver elemento.setNewRandomPosition() (ln. 30)
	
	method sePuedePisar() = false			// ver bicho.moverAleatorio()
	
	/** ************************** **/
	
	// Validaciones de tipos
	method esCaja() = false
	
	method esLlave() = false
	
	method esCeldaEspecial() = false
	
	method esComida() = false
	
	method esBicho() = false
	
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
	method image() = "llavecita.png"
	
	override method esLlave() = true
	
	override method interactuar() {
		game.say(gerardo, "Upa, y esto?")		// SE BUGUEA CON EL WHEN COLLIDE DO, NUNCA ELIMINA EL GLOBO
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
	
	method image() = "deposito.png"
	
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
			
	method image() = "caja.png"
	
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

object puertaNivel2 inherits Elemento{
	var property estaEnElNivel = false
	
	method image() = "puerta.png"
	
	override method interactuar() {
		/** Notar que permite interactuar únicamente si Gerardo puede ganar el nivel 2 ( ver nivel2 --> aparecerPuerta() ) */
		game.say(self, "Felicitaciones!")
		game.schedule(2000, finNivel2.configurate())
	}
	
}












