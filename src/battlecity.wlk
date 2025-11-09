import tanque.*
import wollok.game.*
import muro.*
import powerUps.*
import tanque_enemigo.*
import mapa.*
import halcon.*

const jugadores = [jugador1_tanque, jugador2_tanque]
const niveles = [nivel1, nivel2, nivel3]
const jugabilidades = [modo_versus, como_se_juega]

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

        game.onTick(5000, "APARECE POWER UPS", {spawnearPowerUps.elegirUnPowerAlAzar()})


        keyboard.backspace().onPressDo({

            game.clear()

            inicio_batalla.stop()

            restaurar_mapa.regenerar()
            jugadores.forEach({unTanque => unTanque.resetearRondasGanadas() unTanque.normalizar()})

            detalles_menu.cargar(menu_seleccion_nivel, niveles)
            game.addVisual(visualizacion_mapa)

            menu_seleccion_nivel.retroceder()
            
            })

    }

    method jugar() {

        self.dibujarTablero()

        detalles_menu.cargar(imagen_menu_del_juego, jugabilidades)

        game.start()
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

        flecha.desplazarFlechaPorLasOpciones(opciones)

        flecha.detectarQueOpcionElijo()

    }

    method cargar_menu_estatico(menu_a_cargar) {

        game.addVisual(menu_a_cargar)
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

object imagen_menu_del_juego {

    const position = new Position()

    method image() {
        return "menu_inicial.png"
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

    method position(nuevaPosicion) {
        position = nuevaPosicion
    }

    method opcionSelecionada() = opcionSelecionada

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

    method desplazarFlechaPorLasOpciones(opciones) {
        keyboard.up().onPressDo {
            const nuevaPosicion = position.up(2)

            if (nuevaPosicion.y() <= opciones.head().position().y() ) self.position(nuevaPosicion)
        }

        keyboard.down().onPressDo {
            const nuevaPosicion = position.down(2)

            if (nuevaPosicion.y() >= opciones.last().position().y() ) self.position(nuevaPosicion)
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

class Opciones_De_Menu {

    const posicion
    const texto_nombre_de_opcion

    method position() {
        return posicion
    }

    method image() {
        return texto_nombre_de_opcion
    }

    method retrocederAEsteMenuDinamico(menu, opciones) {

        keyboard.backspace().onPressDo({
            
            game.clear()

            detalles_menu.cargar(menu, opciones)

        })
        

    }

    method retrocederAEsteMenuEstatico(menu) {
        keyboard.backspace().onPressDo({
            
            game.clear()

            detalles_menu.cargar_menu_estatico(menu)

        })
    }
}

object modo_versus inherits Opciones_De_Menu (posicion = new Position (x = 5, y = 7 ), texto_nombre_de_opcion = "logo_de_modo_versus.png" ) {

    method ejecutar() {

        game.clear()

        detalles_menu.cargar(menu_seleccion_nivel, niveles)
        game.addVisual(visualizacion_mapa)

        self.retrocederAEsteMenuDinamico(imagen_menu_del_juego, jugabilidades)

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
    
    method retroceder() {

        keyboard.backspace().onPressDo({
            
            game.clear()
            detalles_menu.cargar(imagen_menu_del_juego, jugabilidades)

        })
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

object como_se_juega inherits Opciones_De_Menu (posicion = new Position (x = 5, y = 5), texto_nombre_de_opcion = "logo_como_jugar.png") {

    method ejecutar() {

        game.clear()

        detalles_menu.cargar_menu_estatico(pantalla_instrucciones)

        pantalla_instrucciones.retroceder()

    }
}

object pantalla_instrucciones {
    
    const position = new Position()

    method image() {
        return "menu_como_jugar.png" 
    }

    method position() {
        return position
    }

    method retroceder() {

        keyboard.backspace().onPressDo({
            
            detalles_menu.cargar(imagen_menu_del_juego, jugabilidades)

        })
    }
}

object nada {

    method visionPrevia() {
        return "flecha_juego.png"
    }

}






