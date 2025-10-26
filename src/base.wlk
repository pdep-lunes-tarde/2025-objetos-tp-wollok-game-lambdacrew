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

    method dejarBanderaEnBase(unTanque) {

        if (lePerteneceA == unTanque) {
        unTanque.banderaQueLleva().fueCapturada()
        unTanque.soltar_bandera()
        unTanque.banderaQueLleva().position(ubicacion)
        }
    }

    method esAtravesable(entidad) = true
}