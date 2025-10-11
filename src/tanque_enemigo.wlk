import powerUps.*
import tanque.*
class TanqueEnemigo_Basico{
    var aguanta = 1
    var position = new Position(x = 4, y = 3)
    var posicionAnterior = new Position()

    method position(){
        return position
    }

    method posicionAnterior(nuevaPosicion){
        posicionAnterior = nuevaPosicion
    }

    method image(){
        return "tanque_basico.png"
    }

    method teImpactoUnaBala(unaBala){
        game.removeVisual(self)
        vida_extra.aparecerPowerUp()
    }

    method paraDondeIr(){
        const orden = 1.randomUpTo(4)

        if( orden == 1 ){
            return arriba
        }
        else if(orden == 2){
            return derecha
        }
        else if (orden == 3){
            return abajo
        }
        else {
            return izquierda
        }
    }

    method move(){
        const antiguaPosicion = self.position()
        const nuevaDireccion = self.paraDondeIr()
        const nuevaPosicion = nuevaDireccion.siguientePosicion(position)

        self.posicionAnterior(antiguaPosicion)
        position = nuevaPosicion
    }

}