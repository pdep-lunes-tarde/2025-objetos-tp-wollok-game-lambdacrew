import battlecity.*
import tanque.*
import mapa.*

const musica_victoria = game.sound("finalizacion_partida.mp3")

class Mensajes {

    var mensajeADar
    const position

    method position() {
        return position
    }

    method text() {
        return mensajeADar
    }

    method textColor() = "FF8E00"

}
object gameOver {

    const imagenPantalla = "victoria.png"
    const posicion = new Position()
    

    const positionGanador = new Position( x = 5 ,y = 4)
    const positionPerdedor = new Position()

    method image() {
        return imagenPantalla
    }

    method position() {
        return posicion
    }

    method darle_su_nueva_posicion_tanques (tanqueGanador) {

        tanqueGanador.position(positionGanador)

        game.addVisual(tanqueGanador)
    }

    method mostrar_mensaje(unTexto) {

        const mensajeFinalizarPartida = new Mensajes (position = new Position (x = 5, y = 5), mensajeADar = unTexto)

        game.addVisual(mensajeFinalizarPartida)
    }

    method volverAlMenu() {

        keyboard.backspace().onPressDo({

            

            game.clear()

            restaurar_mapa.regenerar()

            jugadores.forEach ({unTanque => unTanque.normalizar() unTanque.resetearRondasGanadas()})

            musica_victoria.stop()
            
            detalles_menu.cargar(menu_seleccion_nivel, [nivel1,nivel2])

            game.addVisual(visualizacion_mapa)

            menu_seleccion_nivel.retroceder()

            

            

            

        })
    }
}

object  reiniciar_mapa {
    
    method recargar_escena(nivel) {

        game.schedule(5000, {juegoBattleCity.reset()})

    } 
}

object verificar_finalizacion_partida{

    method mensaje_victoria() {
        if (jugador1_tanque.rondas_ganadas() > 2) {
            game.say(jugador1_tanque, "GANEEEEE")
        }
        if (jugador2_tanque.rondas_ganadas() > 2) {
            game.say(jugador2_tanque, "YO GANEEEE")
        }
    }

    method gano_alguien() = jugador1_tanque.rondas_ganadas() > 2 || jugador2_tanque.rondas_ganadas() > 2
}