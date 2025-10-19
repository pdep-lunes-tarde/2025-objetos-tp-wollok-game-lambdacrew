import wollok.game.*
import battlecity.*
import bala.*

object tanque {
    var direccion = sinDireccion

    var posicion = new Position(x=4, y=1)
    var posicionAnterior = new Position()

    var sprite = "tank_up.png"
    var vidas_extras = 3

    const balas_activas_del_tanque = []
    
    method image(){
        return sprite
    }

    method puedeDispararOtra() = balas_activas_del_tanque.size() < 2

    method balas_que_disparo_el_tanque() {
        return balas_activas_del_tanque
    }

    method posicionAnterior(antiguaPosicion) {
        posicionAnterior = antiguaPosicion
    }

    method posicionAnterior() {
        return posicionAnterior
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

    method desplazarse(nuevaDireccion) {

        const antiguaPosicion = self.position()
        const nuevaPosicion = nuevaDireccion.siguientePosicion(posicion)

        direccion = nuevaDireccion
        posicion = self.posicionCorregida(nuevaPosicion)
        nuevaDireccion.cambiarSprite(self)

        self.posicionAnterior(antiguaPosicion)
    }

    method posicionCorregida(posicionACorregir){
        const nuevaY = wraparound.aplicarA(posicionACorregir.y(), 0, juegoBattleCity.alto())
        const nuevaX = wraparound.aplicarA(posicionACorregir.x(), 0, juegoBattleCity.ancho())

        return new Position(x = nuevaX, y = nuevaY)
    }

    method nuevoDispararBala(){
        if(self.puedeDispararOtra()) {
            const bala = new Bala(direccion = self.direccion(), posicion = self.direccion().siguientePosicion(self.position()))

            balas_activas_del_tanque.add(bala)
            bala.dibujarBala()

            bala.tuBalaChocoConAlgo(self, bala)

            game.sound("tanque_disparando.wav").play()
        }
    }

    method irBorrandoBalas(){
        const bala_que_encabeza_la_lista = balas_activas_del_tanque.head()
        balas_activas_del_tanque.remove(bala_que_encabeza_la_lista)
    }

    method agarrarPowerUp(poder){
        poder.aplicarEfectos()
    }

    method sumarVidaExtra(){
        vidas_extras = vidas_extras + 1
    }
}

object izquierda {
    method siguientePosicion(posicion) {
        return posicion.left(1)
    }
    method cambiarSprite(entidad) {
        entidad.image("tank_left.png")
    }
}
object abajo {
    method siguientePosicion(posicion) {
        return posicion.down(1)
    }
    method cambiarSprite(entidad) {
        entidad.image("tank_down.png")
    }
}
object arriba {
    method siguientePosicion(posicion) {
        return posicion.up(1)
    }
    method cambiarSprite(entidad) {
        entidad.image("tank_up.png")
    }
}
object derecha {
    method siguientePosicion(posicion) {
        return posicion.right(1)
    }
    method cambiarSprite(entidad) {
        entidad.image("tank_right.png")
    }
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

