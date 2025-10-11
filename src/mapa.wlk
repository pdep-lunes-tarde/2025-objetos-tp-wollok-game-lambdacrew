import muro.*
object nivel1{
    const conjuntoMuros = [new Muro_Ladrillos(position = new Position(x = 3, y = 0))
        , new Muro_Ladrillos(position = new Position(x = 3, y = 1))
        , new Muro_Ladrillos(position = new Position(x = 4, y = 1))
        , new Muro_Ladrillos(position = new Position(x = 5, y = 0))
        , new Muro_Ladrillos(position = new Position(x = 5, y = 1))
        , new Muro_Reforzado(position = new Position(x = 4, y = 3))
        , new Parche_De_Agua(position = new Position(x = 7, y = 3))
        , new Parche_De_Agua(position = new Position(x = 8, y = 3))
        , new Arbustos(position = new Position(x = 3, y = 5))
        , new Arbustos(position = new Position(x = 3, y = 6))
        , new Arbustos(position = new Position(x = 4, y = 5))
        , new Arbustos(position = new Position(x = 4, y = 6))]

    method dibujarMapa() {
        conjuntoMuros.forEach({n => n.dibujarMuro()})
    }
}