import muro.*
import tanque_enemigo.*
import tanque.*
import halcon.*

object nivel1{
    const conjuntoMuros = [new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 2, y = 0))
        , new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 2, y = 1))
        , new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 2, y = 2))
        , new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 0, y = 2))
        , new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 1, y = 2)),

          new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 7, y = 9))
        , new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 7, y = 8))
        , new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 7, y = 7))
        , new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 8, y = 7))
        , new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 9, y = 7)),
          new Muro_Ladrillos(durabilidad = 3, position = new Position(x = 2, y = 2)),
          
          new Parche_De_Agua(position = new Position(x = 7, y = 3))
        , new Parche_De_Agua(position = new Position(x = 8, y = 3))]

    const conjuntoDetalles = [ new Arbustos(position = new Position(x = 3, y = 5))
        , new Arbustos(position = new Position(x = 3, y = 6))
        , new Arbustos(position = new Position(x = 4, y = 5))
        , new Arbustos(position = new Position(x = 4, y = 6))]

    const enemigo = new Enemigo(salud = 2, posicion = new Position(x = 0,y = 9), direccion = abajo)

    const halcones = [new Halcon (lePerteneceA = jugador1_tanque, origen_bandera = new Position(x = 0, y = 0), posicion = new Position (x = 0, y = 0)),
    new Halcon (lePerteneceA = jugador2_tanque, posicion = new Position (x = 9, y = 9), origen_bandera = new Position(x = 9, y = 9))]

    const bases = [new Base(lePerteneceA = jugador1_tanque, ubicacion = new Position(x=0,y=1)),
        new Base(lePerteneceA = jugador2_tanque, ubicacion = new Position(x=9,y=8))]

    method dibujarMapa() {
        conjuntoMuros.forEach({n => n.dibujarMuro()})
    }

    method dibujarBases() {
        bases.forEach({n => n.dibujarBases()})
    }

    method dibujarDetalles(){
        conjuntoDetalles.forEach({n => n.dibujarMuro()})
    }

    method dibujarEnemigos(){
        enemigo.dibujarTanqueAmenaza()
        game.onTick(1000, "Enemigo disparo", {enemigo.dispararBala()}) 
    }

    method dibujarHalcones(){
        halcones.forEach({n => n.dibujarHalcon()})
    }

    method reHacerMuros() {
        conjuntoMuros.forEach({n => n.restablecerDurabilidad()})
    }

    method reubicarHalcon() {
        halcones.forEach({n => n.restablecerUbicacion() n.liberada()})
    }
}