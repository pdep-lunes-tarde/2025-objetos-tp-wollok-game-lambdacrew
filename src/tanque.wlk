import wollok.game.*
import battlecity.*
import bala.*

object indicadorDeVelocidad {
    method position() {
        return game.at(game.width() - 5, game.height() - 1)
    }

    method text() {
        return "Intervalo de tiempo: " + juegoBattleCity.intervaloDeTiempo() + " ms"
    }
}

object tanque {
    var direccion = sinDireccion
    var posicion = new Position(x=4, y=1)
    var posicionAnterior = new Position()
    var sprite = "tank_up.png"

    var vidas_extras = 3

    method image(){
        return sprite
    }

    method puedeDisparar() = true

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

    method move(){
        const antiguaPosicion = self.position()
        const nuevaPosicion = direccion.siguientePosicion(posicion)

        self.posicionAnterior(antiguaPosicion)
        posicion = self.posicionCorregida(nuevaPosicion)
    }

    method posicionCorregida(posicionACorregir){
        const nuevaY = wraparound.aplicarA(posicionACorregir.y(), 0, juegoBattleCity.alto())
        const nuevaX = wraparound.aplicarA(posicionACorregir.x(), 0, juegoBattleCity.ancho())

        return new Position(x = nuevaX, y = nuevaY)
    }

    method dispararBala(){
        const bala = new Bala(direccion = self.direccion(), posicion=new Position(x=self.position().x() , y=self.position().y()))
        bala.dibujarBala()
        bala.detectarColision()
        game.onTick(100, "desplazarBala", {bala.move()})
        game.onTick(1000, "borrar bala", {bala.borrarBala()})
    }

    method teImpactoUnaBala(unaBala){
        return true
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
}
object abajo {
    method siguientePosicion(posicion) {
        return posicion.down(1)
    }
}
object arriba {
    method siguientePosicion(posicion) {
        return posicion.up(1)
    }
}
object derecha {
    method siguientePosicion(posicion) {
        return posicion.right(1)
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


