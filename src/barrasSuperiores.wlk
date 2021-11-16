import wollok.game.*
import gerardo.*
import bichosYComida.geroParca

class ElementoDeBarra {		/** Clase padre (abstracta) */
	
	/** 
		Notar que ElementoDeBarra no hereda de Elemento (ver elementos.wlk), 
		pues no lo necesita.
		No es posible que elementos del juego pisen elementos de la barra.
	 */
	
	method position()
	
	method image()
	
	method sePuedePisar() = false
	
	method puedeSuperponer() = false
}

object barraDeSalud inherits ElementoDeBarra {		/** Muestra una barra de salud de 5 bloques --> ver image() */
	
	override method position() = game.at(0, game.height()-1)
	
	override method image() {
		var imagen
		
		if ((gerardo.salud()).between(81,100)){
			imagen = "barraSalud5.png"
		} else if ((gerardo.salud()).between(61,80)) {
			imagen = "barraSalud4.png"
		} else if ((gerardo.salud()).between(41,60)) {
			imagen = "barraSalud3.png"
		} else if ((gerardo.salud()).between(21,40)) {
			imagen = "barraSalud2.png"
		} else if ((gerardo.salud()).between(1,20)){
			imagen = "barraSalud1.png"
		} else {
			imagen = "barraSalud0.png"
		}
		return imagen
	}
}

object rayito inherits ElementoDeBarra {
	
	override method position() = game.at(12,14)
	override method image() = "rayito.png"
}

object contadorEnergia1 inherits ElementoDeBarra {
	
	override method position() = game.at(13,14)
	
	override method image() {
		var imagen = "5.png"
		const energia = gerardo.energia()
		
		if (energia.between(40,49)) {
			imagen = "4.png"
		} else if (energia.between(30,39)) {
			imagen = "3.png"
		} else if (energia.between(20,29)) {
			imagen = "2.png"
		} else if (energia.between(10,19)) {
			imagen = "1.png"
		} else if (energia.between(0,9)) {
			imagen = "0.png"
		}
		return imagen
	}	
}

object contadorEnergia2 inherits ElementoDeBarra {

	override method position() = game.at(14,14)
	
	override method image() {
		var imagen
		const energia = gerardo.energia()
		var digito = 0 
		
		if (energia.between(40,49)) {			// Define el dígito
			digito = energia - 40
		} else if (energia.between(30,39)) {
			digito = energia - 30
		} else if (energia.between(20,29)) {
			digito = energia-20
		} else if (energia.between(10,19)) {
			digito = energia-10
		} else if (energia.between(0,9)) {
			digito = energia
		}
		
		if (digito == 9) {						// Imagen según dígito
			imagen = "9.png"
		} else if (digito == 8) {
			imagen = "8.png"
		} else if (digito == 7) {
			imagen = "7.png"
		} else if (digito == 6) {
			imagen = "6.png"
		} else if (digito == 5) {
			imagen = "5.png"
		} else if (digito == 4) {
			imagen = "4.png"
		} else if (digito == 3) {
			imagen = "3.png"
		} else if (digito == 2) {
			imagen = "2.png"
		} else if (digito == 1) {
			imagen = "1.png"
		} else if (digito == 0) {
			imagen = "0.png"
		}
		return imagen
	} 
}

/** Llaves (nvl 1) */
object cont_llave1 inherits ElementoDeBarra {				
	
	override method position() = game.at(5,14)
	
	override method image() = "contadorLlavecita.png"
}

object cont_llave2 inherits ElementoDeBarra {
	
	override method position() = game.at(6,14)
	
	override method image() = "contadorLlavecita.png"
}


object cont_llave3 inherits ElementoDeBarra {
	
	override method position() = game.at(7,14)
	
	override method image() = "contadorLlavecita.png"
}

/** Cajas (nvl 1) */
object cont_caja1 inherits ElementoDeBarra {				
	
	override method position() = game.at(8,14)
	
	override method image() = "contadorCaja.png"
}

object cont_caja2 inherits ElementoDeBarra {
	
	override method position() = game.at(9,14)
	
	override method image() = "contadorCaja.png"
}

object cont_caja3 inherits ElementoDeBarra {
	
	override method position() = game.at(10,14)
	
	override method image() = "contadorCaja.png"
}

/** Monedas (nvl 2) */
object cont_moneda1 inherits ElementoDeBarra {				
	
	override method position() = game.at(6,14)
	
	override method image() = "contadorMonedita.png"
}

object cont_moneda2 inherits ElementoDeBarra {
	
	override method position() = game.at(7,14)
	
	override method image() = "contadorMonedita.png"
}

object cont_moneda3 inherits ElementoDeBarra {
	
	override method position() = game.at(8,14)
	
	override method image() = "contadorMonedita.png"
}

object cont_moneda4 inherits ElementoDeBarra {
	
	override method position() = game.at(9,14)
	
	override method image() = "contadorMonedita.png"
}

/** Granada y salud Gero (nvl 3) */

object cont_granada inherits ElementoDeBarra {
	
	override method position() = game.at(7,14)
	
	override method image() = "cont_granada.png"
}

object barraSaludGero inherits ElementoDeBarra {
 	
 	override method position() = game.at(11,14)
 	
 	override method image() {
 		const salud = geroParca.salud()
 		var imagen
 		
 		if (salud == 3) {
 			imagen = "saludGero3.png"
 		} else if (salud == 2) {
 			imagen = "saludGero2.png"
 		} else if (salud == 1) {
 			imagen = "saludGero1.png"
 		} else {
 			imagen = "saludGero0.png"
 		}
 		return imagen
 	}
}