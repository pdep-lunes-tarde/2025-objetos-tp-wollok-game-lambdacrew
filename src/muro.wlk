import src.tanque.*
import src.bala.*


class Muro {
    const position
    var durabilidad = 3

    method position() {
        return position
    }

    method restablecerDurabilidad(){
        durabilidad = 3
    }

    method esAtravesable(entidad) = durabilidad < 1

    method teImpactoLaBalaDe(elQueDisparo, unaBala) {
        if(durabilidad > 1) {
            durabilidad = durabilidad - unaBala.fuerza()
            borrar_balas.bala_logro_su_objetivo(elQueDisparo, unaBala)
            game.sound("balas_chocando.wav").play()
        }
        else {
            game.removeVisual(self)
            borrar_balas.bala_logro_su_objetivo(elQueDisparo, unaBala)
        }
    }

    

    method dibujarMuro(){
        game.addVisual(self)
    }

    method efecto(unTanque) {}
    method seguirA(unTanque) {}
    method fueUrtadoPor(unTanque) {}
    method recuperada(unTanque) {}
    method dejarBanderaEnBase(unTanque) {}



}

class Muro_Ladrillos inherits Muro{

    method image() {
        if (durabilidad == 3){
            return "muro_health_3.png"
        }
        else if (durabilidad == 2){
            return  "muro_health_2.png"
        }
        else if (durabilidad == 1) {
            return "muro_health_1.png"
        }
        else {
            return  "muro_tumbado.png"
        }
    }
}
class Muro_Reforzado inherits Muro{

    override method teImpactoLaBalaDe(elQueDisparo, unaBala){
        if (unaBala.rompeMurosReforzados()){
            super(elQueDisparo, unaBala)
        }
        elQueDisparo.irBorrandoBalas()
        game.removeVisual(unaBala)
    }

    method image() {
        if (durabilidad == 3){
            return "muro_reforzado.png"
        }
        else if (durabilidad == 2){
            return  "muro_health_2.png"
        }
        else if (durabilidad == 1) {
            return "muro_health_1.png"
        }
        else {
            return  "muro_tumbado.png"
        }
    }
}

class Parche_De_Agua inherits Muro {

    method image() {
        return "agua.png"
    }

    override method teImpactoLaBalaDe (elQueDisparo, unaBala) {}

    override method esAtravesable(entidad) = entidad.irPorAgua()

}

class Arbustos {
    const position

    method image() {
        return "arbustos.png"
    }

    method position() {
        return position
    }

    method dibujarMuro(){
        game.addVisual(self)
    }

    method noDejarloPasar(unTanque){}

    method esAtravesable(entidad) = true

    method efecto(unTanque) {}
    method seguirA(unTanque) {}
    method fueUrtadoPor(unTanque) {}
    method recuperada(unTanque) {}
    method dejarBanderaEnBase(unTanque) {}
}
