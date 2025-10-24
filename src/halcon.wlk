import src.tanque.*
import src.battlecity.*
import mapa.*
class Halcon {
    const lePerteneceA 
    const posicion = new Position(x = 4,y = 0 )

    method image() {
        return "halcon_bandera.png"
    }

    method position() = posicion

    method lePerteneceA() = lePerteneceA

    method teImpactoLaBalaDe(elQueDisparo, unaBala) {

        game.removeVisual(self)
        game.removeVisual(unaBala)
        elQueDisparo.irBorrandoBalas()
        self.destruyeron_el_aguila_de(self, elQueDisparo)

    }

    method destruyeron_el_aguila_de(aguila, elQueDisparo){

        if (verificar_finalizacion_partida.gano_alguien()) {
            verificar_finalizacion_partida.mensaje_victoria()
        }
        else {
            if (aguila.lePerteneceA() == elQueDisparo) {
                aguila.lePerteneceA().ganar_ronda()
                gameOver.mensaje_de_ronda_terminada(elQueDisparo)
                gameOver.partidaFinalizada()
                reiniciar_mapa.recargar_escena(nivel1)  
            }
            else {
                elQueDisparo.ganar_ronda()
                gameOver.mensaje_de_ronda_terminada(aguila.lePerteneceA())
                gameOver.partidaFinalizada()

                reiniciar_mapa.recargar_escena(nivel1)
            }
        }
    }

    method dibujarHalcon() {
        game.addVisual(self)
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

    method text(){
        return mensajeDeDerrota
    }

    method position(){
        return posicion
    }
}

object  reiniciar_mapa {
    
    method recargar_escena(nivel) {

        game.schedule(5000, {game.clear() juegoBattleCity.configurar()})

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