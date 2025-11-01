class Base {
    var ubicacion
    const lePerteneceA

    method imagen(){}

    method position() = ubicacion

    method position(aguila) {
        ubicacion = aguila.origen_bandera()
    }

    method lePerteneceA() = lePerteneceA

    method dibujarBases() {
        game.addVisual(self)
    }

    method teChocoUnTanque (tanque) {

        if (lePerteneceA == tanque) {
            tanque.banderaQueLleva().fueCapturada()
            tanque.soltar_bandera()
            tanque.banderaQueLleva().position(ubicacion)
        }
    }

    method esAtravesable(entidad) = true
}