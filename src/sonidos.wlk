import wollok.game.*

/** Configuración de la música del juego */

object musicaFondoNivel1{
	const musica = game.sound("8bit1.mp3")
	
	method sonar(){
		musica.shouldLoop(true)
		musica.volume(0.3)
		game.schedule(500, {musica.play()}) //planifica su inicio
	}
	
	method parar(){
		musica.stop()
	}
}

object musicaFondoNivel2{
	const musica = game.sound("8bit.mp3")
	
	method sonar(){
		musica.shouldLoop(true)
		musica.volume(0.3)
		musica.play()
	}
	
	method parar(){
		musica.stop()
	}
}