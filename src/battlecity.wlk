import tanque.*
import wollok.game.*
import muro.*
import powerUps.*
import tanque_enemigo.*
import mapa.*
import halcon.*

object juegoBattleCity {
    
    method ancho() {
        return 11
    }
    method alto() {
        return 10
    }
    method dibujarTablero(){
        game.width(self.ancho())
        game.height(self.alto())
        game.cellSize(50)
    }

    method configurar() {
        
        jugador2_tanque.actividad()
        jugador1_tanque.actividad()

        game.onTick(jugador1_tanque.velocidad_balas(), "DesplazarBalasTanque1", {
            jugador1_tanque.balas_que_disparo_el_tanque().forEach({n => n.moverBalasDe(jugador1_tanque) })
            })
        
        game.onTick(jugador2_tanque.velocidad_balas(), "DesplazarBalasTanque2", {
            jugador2_tanque.balas_que_disparo_el_tanque().forEach({n => n.moverBalasDe(jugador2_tanque) })
            })
        
                          /*  cargar_nivel.iniciar() */

        game.onTick(5000, "APARECE POWER UPS", {spawnearPowerUps.elegirUnPowerAlAzar()})

    }

    method jugar() {
        self.dibujarTablero()

        detalles_menu.cargar(menu_jugabilidad, [modo_versus])

        game.start()
    }

    method iniciarJuego() {

        self.dibujarTablero()

        detalles_menu.cargar(menu_jugabilidad, [modo_versus])
        detalles_menu.listar_opciones([modo_versus])
    }

    method reset() {
        game.clear()
        restaurar_mapa.regenerar()
        jugador1_tanque.normalizar()
        jugador2_tanque.normalizar()
        cargar_nivel.iniciar(flecha.opcionSelecionada())
        self.configurar()
    }

}

object detalles_menu {

    method cargar(menu_a_cargar, opciones) {

        game.addVisual(menu_a_cargar)
        self.listar_opciones(opciones)
        game.addVisual(flecha)

        flecha.desplazarFlecha()

        flecha.detectarQueOpcionElijo()

    }

    method listar_opciones (opciones) {

        opciones.forEach({unaOpcion => game.addVisual(unaOpcion)})
    }

    
}

object restaurar_mapa {

    method regenerar()
    {
        flecha.opcionSelecionada().reHacerMuros()
        flecha.opcionSelecionada().reubicarHalcon()
    }

}

object cargar_nivel {

    method iniciar(queNivelCargo)
    {
        queNivelCargo.dibujarMapa()

        game.addVisual(jugador2_tanque)
        game.addVisual(jugador1_tanque)

        queNivelCargo.dibujarDetalles()

    }
}

object menu_jugabilidad {

    const position = new Position()

    method image() {
        return "menu_inicial.png"
    }

    method position() {
        return position
    }
}

object menu_seleccion_nivel {
    
    const position = new Position()

    method image() {
        return "menu_inicial.png"
    }

    method position() {
        return position
    }
}

object visualizacion_mapa {

    const position = new Position(x = 1, y = 4)

    method image() {
        return flecha.opcionSelecionada().visualizacion_previa()
    }

    method position() {
        return position
    }
}



object flecha {

    var position = new Position(x = 5, y = 7)

    var opcionSelecionada = nada

    method image() {
        return "flecha_juego.png"
    }

    method position() {
        return position
    }

    method opcionSelecionada() = opcionSelecionada

    method position(nuevaPosicion) {
        position = nuevaPosicion
    }

    method desplazarFlecha() {
        keyboard.up().onPressDo {
            const nuevaPosicion = position.up(2)

            self.position(nuevaPosicion)
        }

        keyboard.down().onPressDo {
            const nuevaPosicion = position.down(2)

            self.position(nuevaPosicion)
        }

        keyboard.enter().onPressDo {
            opcionSelecionada.ejecutar()
            self.position(new Position (x = 5, y = 7))
        }
    }

    method detectarQueOpcionElijo() {

        game.onCollideDo(self, {opcion => opcionSelecionada = opcion})

    }



}

object modo_versus {

    const posicion = new Position (x = 5, y = 7 )

    method position() {
        return posicion
    }

    method image() {
        return "el_modo_versus.png"
    }

    method ejecutar() {
        
        const niveles = [nivel1, nivel2]

        game.clear()

        detalles_menu.cargar(menu_seleccion_nivel, niveles)
        game.addVisual(visualizacion_mapa)

    }

    
}

object nada {

    method visionPrevia() {
        return "flecha_juego.png"
    }
}






