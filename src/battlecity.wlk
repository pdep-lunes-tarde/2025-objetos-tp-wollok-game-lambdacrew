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
        
        game.addVisual(tanque)
        game.addVisual(indicadorDeVelocidad)

        game.onCollideDo(tanque, {otro => otro.efecto(tanque)})
        game.onCollideDo(tanque, { otro =>
            otro.noDejarloPasar(tanque)
        })

        keyboard.space().onPressDo {
            tanque.dispararBala()
        }

        

        keyboard.right().onPressDo {
            tanque.direccion(derecha)
            tanque.image("tank_right.png")
            tanque.move()
        }
        keyboard.d().onPressDo {
            tanque.direccion(derecha)
            tanque.image("tank_right.png")
            tanque.move()
        }
        keyboard.left().onPressDo {
            tanque.direccion(izquierda)
            tanque.image("tank_left.png")
            tanque.move()
        }
        keyboard.a().onPressDo {
            tanque.direccion(izquierda)
            tanque.image("tank_left.png")
            tanque.move()
        }
        keyboard.up().onPressDo {
            tanque.direccion(arriba)
            tanque.image("tank_up.png")
            tanque.move()
        }
        keyboard.w().onPressDo {
            tanque.direccion(arriba)
            tanque.image("tank_up.png")
            tanque.move()
        }
        keyboard.down().onPressDo {
            tanque.direccion(abajo)
            tanque.image("tank_down.png")
            tanque.move()
        }
        keyboard.s().onPressDo {
            tanque.direccion(abajo)
            tanque.image("tank_down.png")
            tanque.move()
        }
    }

    method restart() {
        intervaloDeTiempo = intervaloDeTiempoInicial
        game.clear()
        self.configurar()
    }

    method jugar() {
        self.configurar()

        game.start()
    }
}