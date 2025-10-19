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

    method tuBalaChocoConAlgo(elQueDisparo, unaBala) {

        game.onCollideDo(unaBala, {otro => otro.teImpactoLaBalaDe(elQueDisparo, unaBala)})
    }

    method dibujarBala(){
        game.addVisual(self)
    }
}