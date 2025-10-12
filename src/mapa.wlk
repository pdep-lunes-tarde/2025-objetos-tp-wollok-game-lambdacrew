import muro.*
import tanque_enemigo.*
import tanque.*

object nivel1{
    const conjuntoMuros = [new Muro_Ladrillos(position = new Position(x = 3, y = 0))
        , new Muro_Ladrillos(position = new Position(x = 3, y = 1))
        , new Muro_Ladrillos(position = new Position(x = 4, y = 1))
        , new Muro_Ladrillos(position = new Position(x = 5, y = 0))
        , new Muro_Ladrillos(position = new Position(x = 5, y = 1))
        , new Muro_Reforzado(position = new Position(x = 4, y = 3))]

    const conjuntoDetalles = [new Parche_De_Agua(position = new Position(x = 7, y = 3))
        , new Parche_De_Agua(position = new Position(x = 8, y = 3))
        , new Arbustos(position = new Position(x = 3, y = 5))
        , new Arbustos(position = new Position(x = 3, y = 6))
        , new Arbustos(position = new Position(x = 4, y = 5))
        , new Arbustos(position = new Position(x = 4, y = 6))]

    const enemigo = new Enemigo(salud = 2, posicion = new Position(x = 0,y = 9), direccion = abajo)

    method dibujarMapa() {
        conjuntoMuros.forEach({n => n.dibujarMuro()})
    }

    method dibujarDetalles(){
        conjuntoDetalles.forEach({n => n.dibujarMuro()})
    }

    method dibujarEnemigos(){
        enemigo.dibujarTanqueAmenaza()
        game.onTick(1000, "Enemigo disparo", {enemigo.dispararBala()}) 
    }
}