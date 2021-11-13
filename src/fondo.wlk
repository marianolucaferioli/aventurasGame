import wollok.game.*
import elementos.*

class FondoNivel inherits Elemento {
	
	/** 
		Creación de fondos para los niveles.
		
		Notar que como todo elemento, no se puede pisar, superponer, ni es ninguno de los tipos descriptos.

	*/
	
	var property image
	
	override method interactuar() {}
	
	override method puedeSuperponer() = true
}