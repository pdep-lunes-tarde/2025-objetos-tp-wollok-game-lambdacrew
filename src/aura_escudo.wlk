class Aura_escudo {
    var posicion = new Position()

    method position(){
        return posicion
    }

    method position(nuevaPosition){
        posicion = nuevaPosition
    }

    method seguirA(unTanque){
        game.schedule(0, {self.position(unTanque.position())})
    }

    method image(){
        return "escudo.png"
    }

    method dibujarEscudo(){
        game.addVisual(self)
    }

    method esAtravesable(entidad) = true
} 