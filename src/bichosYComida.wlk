import wollok.game.*
import gerardo.*
import elementos.*
import direcciones.*

class Comida inherits Elemento {			/** Clase padre (abstracta) */

	method image()

	override method esComida() = true

	override method interactuar() {
		game.say(gerardo, "Uf que hambre..")
	}

	method energiaPorUnidad()

	method saludPorUnidad()

	override method serAgarrado() {
		gerardo.sumarEnergia(self.energiaPorUnidad())
		gerardo.sumarSalud(self.saludPorUnidad())
		game.say(gerardo, "Que rico!")
		game.removeVisual(self)
	}

	method moverAleatorio() {
	}

}

/** **************************************************** **/
class Garbanzo inherits Comida {

	override method image() = "garbanzo.png"

	override method energiaPorUnidad() = 10

	override method saludPorUnidad() = 10

}

/** **************************************************** **/
class Empanada inherits Comida {

	override method image() = "empanada.png"

	override method energiaPorUnidad() = 15

	override method saludPorUnidad() = 0

}

/** **************************************************** **/
class Birra inherits Comida {

	override method image() = "birra.png"

	override method energiaPorUnidad() = 15

	override method saludPorUnidad() = 15

}

class Cocacola inherits Comida {

	override method image() = "cocacola.png"

	override method energiaPorUnidad() = 20

	override method saludPorUnidad() = 0

}

// Corazón
class Corazon inherits Comida {

	override method image() = "corazon.png"

	override method energiaPorUnidad() = 0

	override method saludPorUnidad() = 25

	override method serAgarrado() {
	}

	override method interactuar() {
		gerardo.sumarSalud(self.saludPorUnidad())
		game.say(gerardo, "Milagro!")
		game.removeVisual(self)
	}

}

/** *********************************************************************** **/
class Bicho inherits Elemento {			/** Clase padre (abstracta) */

	var estaEnElNivel = true

	method image()

	override method esBicho() = true

	method saludQueQuita()

	override method interactuar() {
		gerardo.restarSalud(self.saludQueQuita())
		game.say(gerardo, "Plagas de *** !")
		estaEnElNivel = false
		game.removeVisual(self)
	}

	method moverAleatorioCada(milisegundos) {
		if (estaEnElNivel) {
			game.onTick(milisegundos, "Movete bichito", { self.moverAleatorio()})
		}
	}

	method moverAleatorio() {
		const nro = new Range(start = 0, end = 3).anyOne()
		if (nro == 0) {
			if (self.hayCeldaLibreAl(up)) {
				self.moveUp()
			} else {
				self.moverAleatorio()
			}
		}
		if (nro == 1) {
			if (self.hayCeldaLibreAl(down)) {
				self.moveDown()
			} else {
				self.moverAleatorio()
			}
		}
		if (nro == 2) {
			if (self.hayCeldaLibreAl(right)) {
				self.moveRight()
			} else {
				self.moverAleatorio()
			}
		}
		if (nro == 3) {
			if (self.hayCeldaLibreAl(left)) {
				self.moveLeft()
			} else {
				self.moverAleatorio()
			}
		}
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
			position = new Position(x = self.position().x(), y = game.height() - 2)
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
			position = new Position(x = game.width() - 1, y = self.position().y())
		}
	}

	method hayCeldaLibreAl(dir) {
		var hayCeldaLibre = true
		if (dir.isUp()) {
			hayCeldaLibre = game.getObjectsIn(self.position().up(1)).all{ obj => obj.sePuedePisar() }
		} else if (dir.isDown()) {
			hayCeldaLibre = game.getObjectsIn(self.position().down(1)).all{ obj => obj.sePuedePisar() }
		} else if (dir.isRight()) {
			hayCeldaLibre = game.getObjectsIn(self.position().right(1)).all{ obj => obj.sePuedePisar() }
		} else {
			hayCeldaLibre = game.getObjectsIn(self.position().left(1)).all{ obj => obj.sePuedePisar() }
		}
		return hayCeldaLibre
	}

}

/** **************************************************** **/
class Garrapata inherits Bicho {

	override method image() = "garrapata.png"

	override method saludQueQuita() = 50

}

/** **************************************************** **/
class Pulga inherits Bicho {

	override method image() = "pulga.png"

	override method saludQueQuita() = 40

}

/** **************************************************** **/
class Cucaracha inherits Bicho {

	override method image() = "cucaracha.png"

	override method saludQueQuita() = 30

}

class Mosquito inherits Bicho {

	override method image() = "mosquito.png"

	override method saludQueQuita() = 20

}

/** *********************************************************************** **/
object pepucha inherits Bicho {

	var energiaParaDar = 50
	var saludParaDar = 100

	method setPepucha() {
		energiaParaDar = 50
		saludParaDar = 100
	}

	override method saludQueQuita() = 0

	override method image() = "pepucha.png"

	method tieneEnergia() = energiaParaDar > 0

	method tieneSalud() = saludParaDar > 0

	/**
	 * 	
	 * Pepucha es un bicho especial ¡Un bicho bueno!. Si Gerardo se para 
	 * sobre Pepucha suma 10 de energia pero le saca esos 10 a ella, teniendo un límite de 50 puntos de energía y 
	 * 100 puntos de salud para dar, con lo cual cuando se le termine la energia, Gerardo no le puede pedir más.
	 * 
	 * En cambio, si Gerardo agarra a pepucha obtiene toda la salud que puede darle, pero hay dos casos a contemplar:
	 * 
	 * Si la agarra y nunca se paró sobre ella, Pepucha le da a Gerardo toda la salud que tiene en stock, eso si, 
	 * despues agua y ajo (o agua y garbanzo... ¿?) pues pepucha se queda sin energía y salud para dar!.
	 * 
	 * Si ya se paró sobre ella en algún momento, Gerardo puede obtener de Pepucha un 20% menos de salud por cada 
	 * vez que se haya parado sobre ella.
	 * 
	 * Es decir, si Gerardo se para una vez sobre ella, recupera 10 puntos de energia y si después la agarra, en vez 
	 * de recuperar 100 puntos de salud, recupera 80.
	 * 
	 * En ambos casos, si Gerardo la agarra, se queda sin energia o sin salud para dar ¡Se manda a volar! Pero tranqui 
	 * que se queda revoloteando por ahí, cersiorándose de que Gerardo no pierda el juego!
	 * 	
	 */
	override method esComida() = true // Gerardo puede agarrarla

	override method esBicho() = true //	Gerardo puede chocar con ella

	override method interactuar() {
		if (self.tieneEnergia() and self.tieneSalud()) {
			gerardo.sumarEnergia(10)
			energiaParaDar -= 10
			saludParaDar -= 20
			game.say(self, "Urrruuuu!")
			game.say(gerardo, "Gracias Pepucha!")
		} else {
			game.say(self, "urru...")
			game.say(gerardo, "Perdón pepucha querida...")
		}
		if (saludParaDar == 0) {
			game.say(gerardo, "Te dejo volar tranquila pepucha!")
			game.say(self, "Urru Urru!")
		}
	}

	override method serAgarrado() {
		gerardo.sumarSalud(saludParaDar)
		energiaParaDar = 0
		saludParaDar = 0
		game.say(gerardo, "Te dejo volar tranquila pepucha!")
		game.say(self, "Urru Urru!")
	}

}

/** Alumnos */
class Alumno inherits Bicho {		/** Clase padre (abstracta) */
	var monedaParaDar = 1

	/** 
		Notar que se agrega el "monedaParaDar = 0" en caso de que la ejecución tarde y 
		Gerardo se pare mas de una vez sobre algune alumne dandole este mas de una moneda.
 	*/
	override method interactuar() {
		estaEnElNivel = false
		gerardo.restarSalud(self.saludQueQuita())
		gerardo.sumarMoneda(monedaParaDar)
		monedaParaDar = 0
		game.say(gerardo, self.mensajeGerardo())
		game.removeVisual(self)
	}

	method atrapameSiPodes() {
		if (estaEnElNivel) {
			game.say(self, "Atrápeme si puede!")
		}
	}

	method mensajeGerardo()		// Ver cada alumno en particular

}

/** Bichos nivel 2 - alumnos del grupo "Eterno resplandor de una Pepucha sin recuerdos" */
object gero inherits Alumno {

	override method image() = "gero.png"

	override method saludQueQuita() = 50

	override method mensajeGerardo() = "Me llevo esto Gero!"

}

object marian inherits Alumno {

	override method image() = "marian.png"

	override method saludQueQuita() = 40

	override method mensajeGerardo() = "Esto es mio Marian!"

}

object enzo inherits Alumno {

	override method image() = "enzo.png"

	override method saludQueQuita() = 30

	override method mensajeGerardo() = "Te cabió Enzo!"

}

object cande inherits Alumno {

	override method image() = "cande.png"

	override method saludQueQuita() = 25

	override method mensajeGerardo() = "Que amable Cande..."

}