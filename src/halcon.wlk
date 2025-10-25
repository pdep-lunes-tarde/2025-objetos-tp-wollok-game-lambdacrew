import src.bala.*
import src.tanque.*
import src.battlecity.*
import mapa.*
class Halcon {
    const lePerteneceA 
    var posicion = new Position(x = 4,y = 0 )
    const origen_bandera
    var capturada = false

    method image() {
        return "halcon_bandera.png"
    }

    method origen_bandera() = origen_bandera

    method restablecerUbicacion() {
        posicion = origen_bandera
    }
    method position() = posicion

    method position(nuevaPosicion) {
        posicion = nuevaPosicion
    }

    method liberada() {
        capturada = false
    }

    method fueCapturada() {
        capturada = true
        lePerteneceA.opcion_respawn(false)
    }

    method aSidoCapturada() = capturada

    method lePerteneceA() = lePerteneceA

    method teImpactoLaBalaDe(elQueDisparo, unaBala) {

        game.removeVisual(self)
        borrar_balas.bala_logro_su_objetivo(elQueDisparo, unaBala)
        // self.destruyeron_el_aguila_de(self, elQueDisparo)

    }

   /* method destruyeron_el_aguila_de(aguila, elQueDisparo){ // ANTIGUA FORMA DE JUGAR - DESTRUIR EL AGUILA ENTRE LOS JUGADORES

        if (verificar_finalizacion_partida.gano_alguien()) {
            verificar_finalizacion_partida.mensaje_victoria()
        }
        else {
            if (aguila.lePerteneceA() != elQueDisparo) {
                elQueDisparo.ganar_ronda()
                gameOver.mensaje_de_ronda_terminada(aguila.lePerteneceA())
                game.say(elQueDisparo, elQueDisparo.rondas_ganadas())
                gameOver.partidaFinalizada()
                reiniciar_mapa.recargar_escena(nivel1)  
            }
            else {
                gameOver.destruiste_tu_propia_aguila()
                gameOver.partidaFinalizada()

                reiniciar_mapa.recargar_escena(nivel1)
            }
        }
    } */

    method dibujarHalcon(){
        game.addVisual(self)
    }

    method esAtravesable() = true

    method fueUrtadoPor(unTanque) {
        if (self.lePerteneceA() != unTanque && !capturada) {
            unTanque.agarrarBandera(self)
            game.removeVisual(self)
        }
    }

    method recuperada(unTanque) {
        if (self.lePerteneceA() == unTanque) {
            self.position(origen_bandera)
            self.liberada()
            unTanque.opcion_respawn(true)
        }
    }

    method bandera_capturada() {
        capturada = true
    }

    method banderaCapturadaPor(unTanque) {
        if (self.lePerteneceA() == unTanque) {
            unTanque.banderaQueLleva().position()
            unTanque.noLlevarBandera()
        }
    }

    method bandera_cae_al_suelo_desde_la_ubicacion_de(unTanque){
        self.position(unTanque.position())
        self.dibujarHalcon()
    }
}

object gameOver {
    var mensajeDeDerrota = "TEXTO"
    const posicion = new Position (x = 5, y = 4)

    method partidaFinalizada() {
        game.addVisual(self)
    }

    method mensaje_de_ronda_terminada(unTanque){
        const mensaje = "HAN DESTRUIDO LA BASE DE " + unTanque
        
        mensajeDeDerrota = mensaje
    }

    method destruiste_tu_propia_aguila() {
        const mensaje = "HAS DESTRUIDO TU PROPIA AGUILA - NO HAY GANADORES"

        mensajeDeDerrota = mensaje
    }

    method text(){
        return mensajeDeDerrota
    }

    method position(){
        return posicion
    }
}

object  reiniciar_mapa {
    
    method recargar_escena(nivel) {

        game.schedule(5000, {juegoBattleCity.reset()})

    } 
}

object verificar_finalizacion_partida{

    method mensaje_victoria() {
        if (jugador1_tanque.rondas_ganadas() == 3) {
            game.say(jugador1_tanque, "GANEEEEE")
        }
        if (jugador2_tanque.rondas_ganadas() == 3) {
            game.say(jugador2_tanque, "YO GANEEEE")
        }
    }

    method gano_alguien() = jugador1_tanque.rondas_ganadas() > 2 || jugador2_tanque.rondas_ganadas() > 2
}