class Aura_escudo {
    var tanque

    method position(){
        return tanque.position()
    }

    method image(){
        return "escudo.png"
    }

    method dibujarEscudo(){
        game.addVisual(self)
    }

    method puedeSerDaniadoPorBala() = false

    method esAtravesable(entidad) = true
} 