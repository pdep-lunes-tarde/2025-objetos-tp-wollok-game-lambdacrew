class Bala {
    var posicion
    var fuerza = 1
    var rompeMurosReforzados = false
    const direccion

    method image(){
        return "bala_tanque.png"
    }
    method position() {
        return posicion
    }

    method orientacion(){
        return direccion
    }

    method fuerza() {
        return fuerza
    }

    method rompeMurosReforzados(){
        return rompeMurosReforzados
    }

    method move(){
        const nuevaPosicion = direccion.siguientePosicion(posicion)
        posicion = nuevaPosicion

    }

    method detectarColision(){
        
        game.onCollideDo(self, {otro => otro.teImpactoUnaBala(self)})
    }

    method dibujarBala(){
        game.addVisual(self)
    }

    method borrarBala(){
        // g ame sound("grabCoin.wav").play()
        game.removeVisual(self)
    }
}