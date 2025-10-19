import tanque.*
import wollok.game.*
import muro.*
import powerUps.*
import tanque_enemigo.*
import mapa.*

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
    method configurar() {
        game.width(self.ancho())
        game.height(self.alto())
        game.cellSize(50)

        nivel1.dibujarMapa()
        
        // nivel1.dibujarEnemigos()
        game.addVisual(tanque)

        nivel1.dibujarDetalles()

        game.onCollideDo(tanque, {otro => otro.efecto(tanque)})

        game.onTick(100, "DesplazarBalasTanque", {tanque.balas_que_disparo_el_tanque().forEach({n => n.move()})})
        
        game.onCollideDo(tanque, { otro =>
            otro.noDejarloPasar(tanque)
        })

// DISPARO
        keyboard.f().onPressDo {
            tanque.nuevoDispararBala()
        }
// FLECHAS 
        keyboard.right().onPressDo {
            tanque.desplazarse(derecha)
        }

        keyboard.left().onPressDo {
            tanque.desplazarse(izquierda)
        }

        keyboard.down().onPressDo {
            tanque.desplazarse(abajo)
        }

        keyboard.up().onPressDo {
            tanque.desplazarse(arriba)
        }

// WASD
        keyboard.d().onPressDo {
            tanque.desplazarse(derecha)
        }
        
        keyboard.a().onPressDo {
            tanque.desplazarse(izquierda)
        }
        
        keyboard.w().onPressDo {
            tanque.desplazarse(arriba)
        }
        
        keyboard.s().onPressDo {
            tanque.desplazarse(abajo)
        }
    }

    method jugar() {
        self.configurar()

        game.start()
    }
}