import tanque.*
import wollok.game.*
import muro.*
import powerUps.*
import tanque_enemigo.*
import mapa.*
import halcon.*

object juegoBattleCity {
    const intervaloDeTiempoInicial = 100
    var intervaloDeTiempo = intervaloDeTiempoInicial

    method intervaloDeTiempo() {
        return intervaloDeTiempo
    }
    method ancho() {
        return 11
    }
    method alto() {
        return 10
    }
    method dibujarTablero(){
        game.width(self.ancho())
        game.height(self.alto())
        game.cellSize(50)
    }

    method configurar() {
        
        jugador2_tanque.actividad()
        jugador1_tanque.actividad()

        game.onTick(jugador1_tanque.velocidad_balas(), "DesplazarBalasTanque1", {
            jugador1_tanque.balas_que_disparo_el_tanque().forEach({n => n.moverBalasDe(jugador1_tanque)})
            })
        
        game.onTick(jugador2_tanque.velocidad_balas(), "DesplazarBalasTanque2", {
            jugador2_tanque.balas_que_disparo_el_tanque().forEach({n => n.moverBalasDe(jugador2_tanque)})
            })
        
        cargar_nivel.iniciar()

        game.onTick(5000, "APARECE POWER UPS", {spawnearPowerUps.elegirUnPowerAlAzar()})

    }

    method jugar() {
        self.dibujarTablero()
        self.configurar()
        game.start()
    }

    method reset() {
        game.clear()
        restaurar_mapa.regenerar()
        jugador1_tanque.normalizar()
        jugador2_tanque.normalizar()
        self.configurar()
    }

}

object restaurar_mapa {

    method regenerar()
    {
        nivel1.reHacerMuros()
        nivel1.reubicarHalcon()
    }

}

object cargar_nivel {

    method iniciar()
    {
        nivel1.dibujarMapa()

        game.addVisual(jugador2_tanque)
        game.addVisual(jugador1_tanque)

        nivel1.dibujarDetalles()

    }
}


// NO SE LLEGO A IMPLEMENTAR 
object actualizar_velocidadDisparo {

    method actualizar_j1() {
        const nuevoValor = jugador1_tanque.velocidad_balas()
        jugador1_tanque.detenerTick()
        game.onTick(nuevoValor, "DesplazarBalasTanque1", {
            jugador1_tanque.balas_que_disparo_el_tanque().forEach({n => n.moverBalasDe(jugador1_tanque)})
            })
    }
}