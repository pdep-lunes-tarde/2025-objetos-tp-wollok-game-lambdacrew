import battlecity.*

class Bala {
    var posicion
    var fuerza = 1
    var rompeMurosReforzados = false

    const direccion

    method image(){
        return direccion.imagenBala()
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

    method moverBalasDe(unTanque){

        if (limitesMapa.teSalisteDeLosLimitesDelMapa(self)){
            unTanque.irBorrandoBalas()
            game.removeVisual(self)
        }

        const nuevaPosicion = direccion.siguientePosicion(posicion)
        posicion = nuevaPosicion
        
    }

    method tuBalaChocoConAlgo(elQueDisparo, unaBala) {
        game.onCollideDo(unaBala, {otro => otro.teImpactoLaBalaDe(elQueDisparo, unaBala)})
        
    }

    method teImpactoLaBalaDe(elQueDisparo, unaBala){
        elQueDisparo.irBorrandoBalas()
        game.removeVisual(unaBala)
        game.removeVisual(self)
        game.sound("balas_chocando.wav").play()
    }

    method dibujarBala(){
        direccion.imagenBala()
        game.addVisual(self)
    }

    method esAtravesable() = true
}

object limitesMapa {

    method teSalisteDeLosLimitesDelMapa (elemento) = 
        elemento.position().x() > juegoBattleCity.ancho() || elemento.position().x() < 0 ||
        elemento.position().y() > juegoBattleCity.alto() || elemento.position().y() < 0

}
