import src.tanque.*
import battlecity.*
import movimiento.*

class Bala {
    var posicion
    var fuerza = 1
    var rompeMurosReforzados = false
    var lePerteneceA
    const acuatico = true

    const direccion

    method image(){
        return direccion.imagenBala()
    }

    method irPorAgua() = acuatico

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
            borrar_balas.bala_logro_su_objetivo(unTanque, self)
        }

        if(!permitir_movimiento.puedoMovermeEnEstaDireccion(self, self.orientacion())){
            self.tuBalaChocoConAlgo(lePerteneceA, self)
        }

        const nuevaPosicion = direccion.siguientePosicion(posicion)
        posicion = nuevaPosicion
        
    }

    method tuBalaChocoConAlgo(elQueDisparo, unaBala) {
        game.onCollideDo(unaBala, {otro => otro.teImpactoLaBalaDe(elQueDisparo, unaBala)})
        
    }

    method teImpactoLaBalaDe(elQueDisparo, unaBala){
        borrar_balas.bala_logro_su_objetivo(elQueDisparo, unaBala)
        game.removeVisual(self)
        game.sound("balas_chocando.wav").play()
    } 

    method dibujarBala(){
        direccion.imagenBala()
        game.addVisual(self)
    }

    method esAtravesable(entidad) = true

    method efecto(unTanque) {}
    method seguirA(unTanque) {}
    method fueUrtadoPor(unTanque) {}
    method recuperada(unTanque) {}
    method dejarBanderaEnBase(unTanque) {}
}

object limitesMapa {

    method teSalisteDeLosLimitesDelMapa (elemento) = 
        elemento.position().x() > juegoBattleCity.ancho() || elemento.position().x() < 0 ||
        elemento.position().y() > juegoBattleCity.alto() || elemento.position().y() < 0
}

object borrar_balas {

    method bala_logro_su_objetivo(elQueDisparo, unaBala){
        elQueDisparo.irBorrandoBalas(unaBala)
        game.removeVisual(unaBala)
    }
}
