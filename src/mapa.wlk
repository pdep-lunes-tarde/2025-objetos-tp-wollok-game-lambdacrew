import src.battlecity.*
import muro.*
import tanque_enemigo.*
import tanque.*
import halcon.*
import base.*

object nivel1{
    const conjuntoMuros = [
          new Muro_Ladrillos(position = new Position(x = 0, y = 2))
        , new Muro_Ladrillos(position = new Position(x = 1, y = 2))
        , new Muro_Ladrillos(position = new Position(x = 2, y = 2))
        , new Muro_Ladrillos(position = new Position(x = 2, y = 0))
        , new Muro_Ladrillos(position = new Position(x = 2, y = 1))

        , new Muro_Ladrillos(position = new Position(x = 8, y = 9))
        , new Muro_Ladrillos(position = new Position(x = 8, y = 8))
        , new Muro_Ladrillos(position = new Position(x = 8, y = 7))
        , new Muro_Ladrillos(position = new Position(x = 9, y = 7))
        , new Muro_Ladrillos(position = new Position(x = 10, y = 7))

        , new Muro_Ladrillos(position = new Position(x = 0, y = 5))
        , new Muro_Ladrillos(position = new Position(x = 1, y = 5))
        , new Muro_Ladrillos(position = new Position(x = 0, y = 4))
        , new Muro_Ladrillos(position = new Position(x = 1, y = 4))
        , new Muro_Ladrillos(position = new Position(x = 9, y = 5))
        , new Muro_Ladrillos(position = new Position(x = 10, y = 5))
        , new Muro_Ladrillos(position = new Position(x = 9, y = 4))
        , new Muro_Ladrillos(position = new Position(x = 10, y = 4))

        , new Muro_Ladrillos(position = new Position(x = 5, y = 9))
        , new Muro_Ladrillos(position = new Position(x = 5, y = 8))
        , new Muro_Ladrillos(position = new Position(x = 5, y = 6))
        , new Muro_Ladrillos(position = new Position(x = 5, y = 3))
        , new Muro_Ladrillos(position = new Position(x = 5, y = 1))
        , new Muro_Ladrillos(position = new Position(x = 5, y = 0))]


    
    const conjuntoDetalles = [ 
          new Arbustos(position = new Position(x = 2, y = 5))
        , new Arbustos(position = new Position(x = 3, y = 5))
        , new Arbustos(position = new Position(x = 2, y = 4))
        , new Arbustos(position = new Position(x = 3, y = 4))
        , new Arbustos(position = new Position(x = 7, y = 5))
        , new Arbustos(position = new Position(x = 8, y = 5))
        , new Arbustos(position = new Position(x = 7, y = 4))
        , new Arbustos(position = new Position(x = 8, y = 4))]

    const parches_de_agua = [
          new Parche_De_Agua (position = new Position (x = 4 ,y = 5 ))
        , new Parche_De_Agua (position = new Position (x = 5 ,y = 5 ))
        , new Parche_De_Agua (position = new Position (x = 6 ,y = 5 ))
        , new Parche_De_Agua (position = new Position (x = 4 ,y = 4 ))
        , new Parche_De_Agua (position = new Position (x = 5 ,y = 4 ))
        , new Parche_De_Agua (position = new Position (x = 6 ,y = 4 ))
        , new Parche_De_Agua (position = new Position (x = 5 ,y = 7 ))
        , new Parche_De_Agua (position = new Position (x = 5 ,y = 2 ))
        ]
    //
    //const enemigo = new Enemigo(salud = 2, posicion = new Position(x = 0,y = 9), direccion = abajo)
    //

    const halcones = [
          new Halcon (lePerteneceA = jugador1_tanque, origen_bandera = new Position(x = 0, y = 0), posicion = new Position (x = 0, y = 0))
        , new Halcon (lePerteneceA = jugador2_tanque, posicion = new Position(x = 10, y = 9) , origen_bandera = new Position(x = 10, y = 9))]

    const bases = [
          new Base(lePerteneceA = jugador1_tanque, ubicacion = new Position(x=0,y=1))
        , new Base(lePerteneceA = jugador2_tanque, ubicacion = new Position(x=10,y=8))]

    method dibujarMapa() {
        conjuntoMuros.forEach({n => game.addVisual(n)})
        parches_de_agua.forEach({n => game.addVisual(n)})
        halcones.forEach({n => game.addVisual(n)})
        bases.forEach({n => game.addVisual(n)})
    }

    method dibujarDetalles(){
        conjuntoDetalles.forEach({n => n.dibujarMuro()})

    }

 /*   method dibujarEnemigos(){
        enemigo.dibujarTanqueAmenaza()
        game.onTick(1000, "Enemigo disparo", {enemigo.dispararBala()}) 
    } */

    method reHacerMuros() {
        conjuntoMuros.forEach({n => n.restablecerDurabilidad()})
    }

    method reubicarHalcon() {
        halcones.forEach({n => n.restablecerUbicacion() n.liberada()})
    }
}
