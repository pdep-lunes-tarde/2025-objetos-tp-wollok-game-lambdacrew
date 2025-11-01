import src.tanque_enemigo.*
import battlecity.*
import tanque.*
import movimiento.*
import aura_escudo.*

class PowerUps {
    var posicion = new Position()

    method position(){
        return posicion
    }

    method position(nuevaPosicion){
        posicion = nuevaPosicion
    }

    method aparecerPowerUp(){
        const posicionAlAzar = new Position(x = 0.randomUpTo(juegoBattleCity.ancho() - 1), y = (juegoBattleCity.alto() - juegoBattleCity.alto().div(2)).randomUpTo(juegoBattleCity.alto() - 1))
        self.position(posicionAlAzar)
        game.sound("power_up_aparece.wav").play()
        game.addVisual(self)
    }

    method esAtravesable(entidad) = true

    method powerUpTomado(){
        game.sound("grabPowerUp.wav").play()
        game.removeVisual(self)
    }

    method teChocoUnTanque (tanque) {
        self.efecto(tanque)
    }

    method efecto(tanque) {}

    method seguirA(unTanque) {}
    method fueUrtadoPor(unTanque) {}
    method recuperada(unTanque) {}
    method dejarBanderaEnBase(unTanque) {}

}

// NO SE PUDO IMPLEMENTAR - PREGUNTAR
object invertir_controles inherits PowerUps  {
    const player = [jugador1_tanque, jugador2_tanque]

    method image() {
        return "pw_pala.png"
    }

    override method efecto(tanqueQueAgarroElPower) {

        const jugadorAfectado = player.filter({jugador => jugador != tanqueQueAgarroElPower}).anyOne()

        jugadorAfectado.controlesInvertidos(true)

        self.powerUpTomado()

        game.schedule(5000, {jugadorAfectado.controlesInvertidos(false)})

    }
}

// SI
object aumentar_balas inherits PowerUps {

    method image() {
        return "1up.png"
    }

    override method efecto(tanqueQueAgarroElPower) {

        tanqueQueAgarroElPower.aumentarMunicionEn(2)
        self.powerUpTomado()

    }
}


// SI, SE PUEDE MEJORAR ?
object escudo inherits PowerUps {

    method image() {
        return "pw_escudo.png"
    }

    override method efecto(tanqueQueAgarroElPower) {

        const aura_del_tanque = new Aura_escudo (tanque = tanqueQueAgarroElPower)

        tanqueQueAgarroElPower.cambiarEstadoInmunidad(true)

        self.powerUpTomado()

        aura_del_tanque.dibujarEscudo()

        game.schedule(5000, {tanqueQueAgarroElPower.cambiarEstadoInmunidad(false) game.removeVisual(aura_del_tanque)})

    }
}

// SI 
object pasarPorAgua inherits PowerUps {

    method image() {
        return "pw_barco.png"
    }

    method efecto(tanqueQueAgarroElPower) {
        tanqueQueAgarroElPower.habilitarIrPorAgua(true)
        self.powerUpTomado()
    }
}

object spawnearPowerUps{

    const powerUpsDisponibles = [invertir_controles, pasarPorAgua, escudo, aumentar_balas]

    method elegirUnPowerAlAzar() {
        var aparecio = powerUpsDisponibles.anyOne()
        aparecio.aparecerPowerUp()

        game.schedule(3000, {game.removeVisual(aparecio)})
    }
}


// LIGADO AL POWER UP DE CONTROLES INVERTIDOS 
object controles_invertidos {

    method movimientos() {

        keyboard.up().onPressDo {
            jugador2_tanque.nuevo_mover_tanque(derecha)
            jugador2_tanque.image("tankP2_right.png")
        }

        keyboard.down().onPressDo {
            jugador2_tanque.nuevo_mover_tanque(izquierda)
            jugador2_tanque.image("tankP2_left.png")
        }

        keyboard.left().onPressDo {
            jugador2_tanque.nuevo_mover_tanque(abajo)
            jugador2_tanque.image("tankP2_down.png")
        }

        keyboard.right().onPressDo {
            jugador2_tanque.nuevo_mover_tanque(arriba)
            jugador2_tanque.image("tankP2_up.png")
        }
    }

    method controles_j1_nuevo() {

        keyboard.w().onPressDo {
            jugador1_tanque.nuevo_mover_tanque(derecha)
            jugador1_tanque.image("tankP2_right.png")
        }

        keyboard.s().onPressDo {
            jugador1_tanque.nuevo_mover_tanque(izquierda)
            jugador1_tanque.image("tankP2_left.png")
        }

        keyboard.a().onPressDo {
            jugador1_tanque.nuevo_mover_tanque(abajo)
            jugador1_tanque.image("tankP2_down.png")
        }

        keyboard.d().onPressDo {
            jugador1_tanque.nuevo_mover_tanque(arriba)
            jugador1_tanque.image("tankP2_up.png")
        }
    }
}