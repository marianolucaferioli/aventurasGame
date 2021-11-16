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
	
	method played(){
		return musica.played()
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
	
	method played(){
		return musica.played()
	}
}

object musicaFondoNivel11{
	//Es solo para cuando pierde en algún nivel que vuelva a sonar, es la misma del nivel 1
	const musica = game.sound("8bit1.0.mp3")
	
	method sonar(){
		musica.shouldLoop(true)
		musica.volume(0.3)
		musica.play()
	}
	
	method parar(){
		musica.stop()
	}
	
	method played(){
		return musica.played()
	}
}

object musicaFondoNivel22{
	//Es para cuando vuelve a empezar el nivel 2 luego de un reinicio suene.
	const musica = game.sound("8bit.0.mp3")
	
	method sonar(){
		musica.shouldLoop(true)
		musica.volume(0.3)
		musica.play()
	}
	
	method parar(){
		musica.stop()
	}
	
	method played(){
		return musica.played()
	}
}

object musicaFondoNivel3{
	const musica = game.sound("nivel3.mp3")
	
	method sonar(){
		musica.shouldLoop(true)
		musica.volume(0.3)
		musica.play()
	}
	
	method parar(){
		musica.stop()
	}
	
	method played(){
		return musica.played()
	}
}

object musicaFondoNivel33{
	//Es para cuando vuelve a empezar el nivel 3 luego de un reinicio suene.
	const musica = game.sound("nivel3.0.mp3")
	
	method sonar(){
		musica.shouldLoop(true)
		musica.volume(0.3)
		musica.play()
	}
	
	method parar(){
		musica.stop()
	}
	
	method played(){
		return musica.played()
	}
}

object musicaGanar{
	
	const musica = game.sound("ganar.mp3")
	
	method sonar(){
		musica.shouldLoop(true)
		musica.volume(0.3)
		musica.play()
	}
	
	method parar(){
		musica.stop()
	}
	
	method played(){
		return musica.played()
	}
}