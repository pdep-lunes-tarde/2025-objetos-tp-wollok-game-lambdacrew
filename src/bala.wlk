import src.tanque.*
import battlecity.*
import movimiento.*
import mapa.*

class Bala {

    var posicion
    var direccion
    var lePerteneceA

    var fuerza = 1
    var rompeMurosReforzados = false

    method position() {
        return posicion
    }

    method image(){
        return direccion.imagenBala()
    }

    method orientacion_bala(){
        return direccion
    }

    method habilitarRomperMurosReforzados(valor){
        rompeMurosReforzados = valor
    }

    method dibujarBala(){
        game.addVisual(self)
    }

    method lePerteneceA() = lePerteneceA

    method irPorAgua() = true

    method esAtravesable(entidad) = true

    method fuerza() = fuerza

    method rompeMurosReforzados() = rompeMurosReforzados

    
    method moverBalasDe(unTanque){

        if (limitesMapa.teSalisteDeLosLimitesDelMapa(self)){
            borrar_balas.bala_logro_su_objetivo(unTanque, self)
        }

        if(!permitir_movimiento.puedoMovermeEnEstaDireccion(self, self.orientacion_bala())){
            permitir_movimiento.noPuedoAvanzarPorQueHayUnMuro(self, self.orientacion_bala())
        }

        const nuevaPosicion = direccion.siguientePosicion(posicion)
        posicion = nuevaPosicion
        
    }

    method teChocoUnTanque (tanque) {}

}

object borrar_balas {

    method bala_logro_su_objetivo(elQueDisparo, unaBala){
        elQueDisparo.irBorrandoBalas(unaBala)
        game.removeVisual(unaBala)
    }
}
