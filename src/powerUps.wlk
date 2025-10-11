import battlecity.*
object vida_extra  {
    var posicion = new Position()
    const id_powerUp = 1

    method image() {
        return "1up.png"
    }

    method position(nuevaPosicion){
        posicion = nuevaPosicion
    }
    method position() {
        return posicion
    }
    method efecto(unTanque) {
        unTanque.sumarVidaExtra()
        game.sound("vida_extra_ganada.wav").play()
        game.removeVisual(self)
    }

    method aparecerPowerUp(){
        const posicionAlAzar = new Position(x = 0.randomUpTo(juegoBattleCity.ancho()), y = (juegoBattleCity.alto() - juegoBattleCity.alto().div(2)).randomUpTo(juegoBattleCity.alto()))
        self.position(posicionAlAzar)
        game.sound("power_up_aparece.wav").play()
        game.addVisual(self)
    }
}