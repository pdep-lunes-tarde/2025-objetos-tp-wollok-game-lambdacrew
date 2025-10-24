import wollok.game.*
import battlecity.*
import bala.*

class TanqueJugador {

    var direccion = sinDireccion

    var posicion
    var sprite = "tank_up.png"

    var rondas_ganadas = 0

    var posicionAnterior = new Position()

    const balas_activas_del_tanque = []

    method image(){
        return sprite
    }

    method rondas_ganadas() = rondas_ganadas

    method ganar_ronda() {
        rondas_ganadas = rondas_ganadas + 1
    }

    method respawn(){
        posicion = new Position(x = 8, y = 0)
    }

    method image(nuevoSprite){
        sprite = nuevoSprite
    }

    method position(){
        return posicion
    }

    method position(nuevaPosicion){
        posicion = nuevaPosicion
    }

    method direccion(nuevaDireccion) {
        direccion = nuevaDireccion
    }

    method direccion(){
        return direccion
    }

    method posicionAnterior(antiguaPosicion) {
        posicionAnterior = antiguaPosicion
    }

    method posicionAnterior() {
        return posicionAnterior
    }

    method balas_que_disparo_el_tanque() {
        return balas_activas_del_tanque
    }

    method irBorrandoBalas(){
        const bala_que_encabeza_la_lista = balas_activas_del_tanque.head()
        balas_activas_del_tanque.remove(bala_que_encabeza_la_lista)
    } 

    method puedeDispararOtra() = balas_activas_del_tanque.size() < 1

    method disparar_de_tanques(){
        if(self.puedeDispararOtra()) {
            const bala = new Bala(direccion = self.direccion(), posicion = self.position())  /* self.direccion().siguientePosicion(self.position() */

            balas_activas_del_tanque.add(bala)
            bala.dibujarBala()

            bala.tuBalaChocoConAlgo(self, bala)

            game.sound("tanque_disparando.wav").play()
        }
    }

    method puedoMovermeEnEstaDireccion (unaOrientacion) {
        return game.getObjectsIn(unaOrientacion.siguientePosicion(posicion)).all {unObj => unObj.esAtravesable()}
    }

    method nuevo_mover_tanque(unaOrientacion) {
        if (self.puedoMovermeEnEstaDireccion(unaOrientacion)){
            const nuevaPosicion = unaOrientacion.siguientePosicion(posicion)
            posicion = self.posicionCorregida(nuevaPosicion)
            direccion = unaOrientacion
        }
        direccion = unaOrientacion
    }

    method posicionCorregida(posicionACorregir){
        const nuevaY = wraparound.aplicarA(posicionACorregir.y(), 0, juegoBattleCity.alto())
        const nuevaX = wraparound.aplicarA(posicionACorregir.x(), 0, juegoBattleCity.ancho())

        return new Position(x = nuevaX, y = nuevaY)
    }

    method teImpactoLaBalaDe(elQueDisparo, unaBala) {

            if (self != elQueDisparo){
                self.respawn()
                elQueDisparo.irBorrandoBalas()
                game.removeVisual(unaBala)
            }
            
        }
    
    method esAtravesable() = false

     
}
       
object jugador2_tanque inherits TanqueJugador (posicion = new Position (x = 7, y = 7)) {

    method actividad(){
            keyboard.p().onPressDo {
            self.disparar_de_tanques()
            }

            keyboard.right().onPressDo {
            self.nuevo_mover_tanque(derecha)
            self.image("tankP2_right.png")
            }

            keyboard.left().onPressDo {
            self.nuevo_mover_tanque(izquierda)
            self.image("tankP2_left.png")
            }

            keyboard.down().onPressDo {
            self.nuevo_mover_tanque(abajo)
            self.image("tankP2_down.png")
            }

            keyboard.up().onPressDo {
            self.nuevo_mover_tanque(arriba)
            self.image("tankP2_up.png")
            }
    }
}

object jugador1_tanque inherits TanqueJugador (posicion = new Position (x = 2, y = 2)) {

    method actividad(){
            keyboard.f().onPressDo {
            self.disparar_de_tanques()
            game.say(self, "Al ataque")
            }

            keyboard.d().onPressDo {
            self.nuevo_mover_tanque(derecha)
            self.image("tank_right.png")
            }

            keyboard.a().onPressDo {
            self.nuevo_mover_tanque(izquierda)
            self.image("tank_left.png")
            }

            keyboard.s().onPressDo {
            self.nuevo_mover_tanque(abajo)
            self.image("tank_down.png")
            }

            keyboard.w().onPressDo {
            self.nuevo_mover_tanque(arriba)
            self.image("tank_up.png")
            }
    }
}

object izquierda {
    method siguientePosicion(posicion) {
        return posicion.left(1)
    }

    method imagenBala() = "bala_tanque_left.png"
}
object abajo {
    method siguientePosicion(posicion) {
        return posicion.down(1)
    }

    method imagenBala() = "bala_tanque_down.png"
}
object arriba {
    method siguientePosicion(posicion) {
        return posicion.up(1)
    }

    method imagenBala() = "bala_tanque_up.png"
}
object derecha {
    method siguientePosicion(posicion) {
        return posicion.right(1)
    }

    method imagenBala() = "bala_tanque.png"
}

object sinDireccion {
    method siguientePosicion(posicion) {
        return posicion
    }
}

object wraparound {
    method aplicarA(numero, topeInferior, topeSuperior) {
        if(numero < topeInferior) {
            return topeSuperior
        } else if(numero > topeSuperior) {
            return topeInferior
        } else {
            return numero
        }
    }
}

