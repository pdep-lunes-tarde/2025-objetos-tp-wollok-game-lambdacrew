object izquierda {
    method siguientePosicion(posicion) {
        return posicion.left(1)
    }

    method imagenBala() = "bala_tanque_left.png"
}
object abajo {
    method siguientePosicion(posicion) {
        return posicion.down(1)
    }

    method imagenBala() = "bala_tanque_down.png"
}
object arriba {
    method siguientePosicion(posicion) {
        return posicion.up(1)
    }

    method imagenBala() = "bala_tanque_up.png"
}
object derecha {
    method siguientePosicion(posicion) {
        return posicion.right(1)
    }

    method imagenBala() = "bala_tanque.png"
}

object sinDireccion {
    method siguientePosicion(posicion) {
        return posicion
    }
}

object wraparound {
    method aplicarA(numero, topeInferior, topeSuperior) {
        if(numero < topeInferior) {
            return topeSuperior
        } else if(numero > topeSuperior) {
            return topeInferior
        } else {
            return numero
        }
    }
}



object permitir_movimiento{

    method puedoMovermeEnEstaDireccion (entidad, unaOrientacion) {
        return game.getObjectsIn(unaOrientacion.siguientePosicion(entidad.position())).all {unObj => unObj.esAtravesable(entidad)}
    }
}