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

object aumentar_balas inherits PowerUps {

    method image() {
        return "1up.png"
    }

    override method efecto(tanqueQueAgarroElPower) {

        tanqueQueAgarroElPower.aumentarMunicionEn(2)
        self.powerUpTomado()

    }
}


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

    override method efecto(tanqueQueAgarroElPower) {
        tanqueQueAgarroElPower.habilitarIrPorAgua(true)
        self.powerUpTomado()
    }
}

object aumentar_velocidad_balas inherits PowerUps {

    method image() {
        return "pw_estrella.png"
    }

    override method efecto (tanqueQueAgarroElPower) {
        tanqueQueAgarroElPower.aumentarVelocidadBala(1.max(tanqueQueAgarroElPower.velocidad_balas() - 20))

        tanqueQueAgarroElPower.hacerNuevoTickDisparo()

        self.powerUpTomado()

    }
}

object romper_muros_irrompibles inherits PowerUps {

    method image() {
        return "pw_granada.png"
    }

    override method efecto (tanqueQueAgarroElPower) {

        tanqueQueAgarroElPower.romper_murosReforzados(true)

        self.powerUpTomado()
    }
}

object spawnearPowerUps{

    const powerUpsDisponibles = [romper_muros_irrompibles, aumentar_velocidad_balas, invertir_controles, pasarPorAgua, escudo, aumentar_balas]

    method elegirUnPowerAlAzar() {
        var aparecio = powerUpsDisponibles.anyOne()
        aparecio.aparecerPowerUp()

        game.schedule(3000, {game.removeVisual(aparecio)})
    }
}
