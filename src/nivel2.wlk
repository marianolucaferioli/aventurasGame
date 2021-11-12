import wollok.game.*
import gerardo.*
import celdasEspeciales.*
import utilidades.*
import barrasSuperiores.*
import elementos.*
import direcciones.*
import fondo.*

object inicioNivel2 {
	method configurate() {
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "comienzo_nivel2.png"))
		
		keyboard.enter().onPressDo({
			game.clear()
			nivel2.configurate()
		})
	}
}

/** *********************************************************************** **/

object nivel2 {
	method configurate() {
		
		game.addVisual(new FondoNivel(position = game.at(0,0), image = "ladrillo.png"))
		
		// Gerardo
		gerardo.energia(30)
		gerardo.salud(100)
		gerardo.dinero(0)
		
		// esto si se quiere setear
		gerardo.position(game.center())
		gerardo.direccion(right)
		
		keyboard.up().onPressDo({ gerardo.move(up)})
		keyboard.down().onPressDo({gerardo.move(down)})
		keyboard.right().onPressDo({ gerardo.move(right)})
		keyboard.left().onPressDo({ gerardo.move(left)})
		
		keyboard.e().onPressDo({gerardo.agarrar()})
		
		// Salud y energí
		game.addVisual(barraDeSalud)
		game.addVisual(rayito)
		game.addVisual(contadorEnergia1)
		game.addVisual(contadorEnergia2)
		game.addVisual(monedita)
		game.addVisual(contadorDinero1)
		game.addVisual(contadorDinero2)

		// Gerardo
		game.addVisual(gerardo)
		gerardo.salud(100)
		gerardo.energia(50)
		gerardo.monedas(0)
		
		// Reinicio nivel
		keyboard.r().onPressDo({	
			game.clear()
			self.configurate()
		})
	}
}







/**


implementar alumnos
--> alumnos.interactuar --> resta salud Y da moneda

--> mostrar monedas

--> tras obtencion 4 monedas aparece puerta --> ganar nivel

--> agregar corazones
 */
