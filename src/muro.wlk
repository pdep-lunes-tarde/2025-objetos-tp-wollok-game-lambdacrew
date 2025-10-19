

class Muro {
    const position
    var durabilidad = 3

    method position() {
        return position
    }

    method noDejarloPasar(unTanque) {
        if(durabilidad > 0) {
            const antiguaPosicion = unTanque.posicionAnterior()
            unTanque.position(antiguaPosicion)
        }
    }

    method teImpactoLaBalaDe(elQueDisparo, unaBala) {
        if(durabilidad > 1) {
            durabilidad = durabilidad - unaBala.fuerza()
            game.removeVisual(unaBala)
            elQueDisparo.irBorrandoBalas()
        }
        else {
            game.removeVisual(self)
            game.removeVisual(unaBala)
            elQueDisparo.irBorrandoBalas()
        }
    }

    

    method dibujarMuro(){
        game.addVisual(self)
    }



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
        else{
            game.removeVisual(unaBala)
            elQueDisparo.irBorrandoBalas()
        }
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

class Parche_De_Agua {
    const position

    method image() {
        return "agua.png"
    }

    method position() {
        return position
    }

    method noDejarloPasar(unTanque) {
        const antiguaPosicion = unTanque.posicionAnterior()
        unTanque.position(antiguaPosicion)
    }

    method dibujarMuro(){
        game.addVisual(self)
    }

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
}
