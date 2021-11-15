import wollok.game.*
import celdasEspeciales.*
import direcciones.*
import nivelPerder.*
import bichosYComida.geroParca

object gerardo {
	// Energía y salud seteada en cada nivel
	var property energia = 0
	var property salud = 0
	
	// Posicion inicial en todos los niveles
	var property position = game.center()	
	var property direccion = right
	// Nivel 1
	var property llavesEncontradas = 0
	var property llavesEntregadas = 0
	var property cajasEncontradas = 0
	
	// Nivel2
	var property monedas = 0
	
	// Nivel 3
	var property granadaEnBolsillo = null
	var property tieneGranada = granadaEnBolsillo != null
	
	/////////////////////////////////////////////////////////////////////
	
	method image() {	
		// Basada en la dirección en la que mira Gerardo	
		var imagen			
		
		if (direccion.isUp()) {
			imagen = "gerardoarriba.png"
		} else if (direccion.isDown()) {
			imagen = "gerardoabajo.png"
		} else if (direccion.isRight()) {
			imagen = "gerardoderecha.png"
		} else if (direccion.isLeft()) {
			imagen = "gerardoizquierda.png"
		}
		return imagen
	}
	
	method seSuperpone() = false 		// evita problemas con la creacion de elementos y posiciones aleatorias
	
	method sePuedePisar() = true		// Los elementos que se mueven pueden llegar a Gerardo
	
	method tieneEnergia() = energia > 0
	
	/** ************************************ **/
	
	// Suma y resta de energía (máximo 50) y salud (máximo 100)
	method sumarSalud(cantidad) { salud = (salud + cantidad).min(100) }
	
	method restarSalud(cantidad) { salud = (salud - cantidad).max(0) }
	
	method sumarEnergia(cantidad) { energia = (energia + cantidad).min(50) }
	
	method restarEnergia(cantidad) { energia = (energia - cantidad).max(0) }
	
	/** ************************************ **/
	
	// Interaccion con objetos
	method interactuar(elemento) { elemento.interactuar()}
	
	// Llaves 
	method sumarLlaves(cant) { llavesEncontradas += cant }
	
	// Cajas
	method sumarCajas(cant) { 
		cajasEncontradas += cant
	}
	
	// Monedas
	method sumarMoneda(cant) {
		monedas += cant
	}
	
	// Interacción con depósitos ( ver elementos.wlk --> Depósito.interactuar() )
	method entregarLlaves() {
		llavesEncontradas -= 1
		llavesEntregadas += 1
		if (self.puedeGanarNivel1()) {
			game.say(self, "Listo el pollo!")
		} else {
			game.say(self, "Te dejo las llaves!")
		}
	}
	
	/** ************************************ **/
	
	/** Movimiendo de Gerardo */
	method move(dir) {				
		
		if (self.tieneEnergia()) {
			if (dir.isUp()) {
				self.moveUp()
			} else if (dir.isDown()) {
				self.moveDown()
			} else if (dir.isRight()) {
				self.moveRight()
			} else {
				self.moveLeft()
			}
		} else {
			game.say(self, "Mejor reinicio mis pasos...")
		}
	}

	method moveUp() {

		if (not (self.position().y() == game.height() - 2)) {
			self.position(self.position().up(1))
		} else {
			self.position(new Position(x = self.position().x(), y = 0))
		}
		self.restarEnergia(1)
		direccion = up
	}
	
	method moveDown() {
		if (not (self.position().y() == 0)) {
			self.position(self.position().down(1))
		} else {
			self.position(new Position(x = self.position().x(), y = game.height()-2))
		}
		self.restarEnergia(1)
		direccion = down
	}
	
	method moveRight() {
		if (not (self.position().x() == game.width() - 1)) {
			self.position(self.position().right(1))
		} else {
			self.position(new Position(x = 0, y = self.position().y()))
		}
		self.restarEnergia(1)
	
		direccion = right
	}
	
	method moveLeft() {
		if (not (self.position().x() == 0)) {
			self.position(self.position().left(1))
		} else {
			self.position(new Position(x = game.width()-1 , y = self.position().y()))
		}
		self.restarEnergia(1)
		
		direccion = left
	}
	
	
	method agarrar() {
		
		/** Agarra lo que este en direccion vecina en la dirección en la que mira */
		
		const objetosEnCeldaLindante = game.getObjectsIn(self.posicionVecinaA(self.direccion()))
		
		objetosEnCeldaLindante.forEach({
			objeto => objeto.serAgarrado()
		})
	}
	
	method posicionVecinaA(dir) {
		var posicion 
		
		if (dir.isUp()) {
			posicion = self.position().up(1)
		} else if (dir.isDown()) {
			posicion = self.position().down(1)
		} else if (dir.isRight()) {
			posicion = self.position().right(1)
		} else if (dir.isLeft()) {
			posicion = self.position().left(1)
		}
		return posicion
	}

	/** ************************************ **/
	
	method puedeGanarNivel1() {
		return self.llavesEntregadas() == 3 and self.cajasEncontradas() == 3
	}
	
	method puedeGanarNivel2() {
		return self.monedas() == 4
	}

	method puedeGanarNivel3() = not game.hasVisual(geroParca)
	
	/** ************************************ **/
	
	method tirarGranada() {
		granadaEnBolsillo.serArrojadaEnDireccion(self.direccion())
		granadaEnBolsillo = null
	}
}





















