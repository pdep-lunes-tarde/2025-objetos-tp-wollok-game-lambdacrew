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
        return 10
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
        
        nivel1.dibujarMapa()

        game.addVisual(jugador2_tanque)
        game.addVisual(jugador1_tanque)

        jugador2_tanque.actividad()
        jugador1_tanque.actividad()
        
        game.showAttributes(jugador1_tanque)


        nivel1.dibujarDetalles()

        nivel1.dibujarHalcones()

        game.onTick(60, "DesplazarBalasTanque", {
            jugador1_tanque.balas_que_disparo_el_tanque().forEach({n => n.moverBalasDe(jugador1_tanque)})
            })
        
        game.onTick(60, "DesplazarBalasTanque", {
            jugador2_tanque.balas_que_disparo_el_tanque().forEach({n => n.moverBalasDe(jugador2_tanque)})
            })

         game.onCollideDo(jugador2_tanque, { otro =>
            otro.noDejarloPasar(jugador2_tanque)
         })

        game.onCollideDo(jugador1_tanque, { otro =>
            otro.noDejarloPasar(jugador1_tanque)
        })

    }

    method jugar() {
        self.dibujarTablero()
        self.configurar()

        game.start()
    }


}

object cargar_mapa {

    method carga()
    {
        nivel1.dibujarMapa()

        game.addVisual(jugador2_tanque)
        game.addVisual(jugador1_tanque)

        jugador2_tanque.actividad()
        jugador1_tanque.actividad()


        nivel1.dibujarDetalles()

        nivel1.dibujarHalcones()

        jugador2_tanque.actividad()
        jugador1_tanque.actividad()
    }
}