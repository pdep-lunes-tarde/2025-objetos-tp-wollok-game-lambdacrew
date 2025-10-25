import wollok.game.*
import battlecity.*
import bala.*
import halcon.*
import mapa.*

class TanqueJugador {

    var direccion = sinDireccion
    var sprite = "tank_up.png"
    var rondas_ganadas = 0
    var respawn = true

    var posicion

    const spawn = posicion

    var banderaQueLleva = null
    var lleva_una_bandera = false
    
    const balas_activas_del_tanque = []

    // SPRITE TANQUES 
    method image(){
        return sprite
    }

    method image(nuevoSprite){
        sprite = nuevoSprite
    }
    // POSICIONAMIENTO Y MOVIMIENTO EN EL TABLERO
    method position(){
        return posicion
    }

    method position(nuevaPosicion){
        posicion = nuevaPosicion
    }

    method direccion(nuevaDireccion) {
        direccion = nuevaDireccion
    }

    method direccion(){
        return direccion
    }

    method puedoMovermeEnEstaDireccion (unaOrientacion) {
        return game.getObjectsIn(unaOrientacion.siguientePosicion(posicion)).all {unObj => unObj.esAtravesable()}
    }

    method posicionCorregida(posicionACorregir){
        const nuevaY = wraparound.aplicarA(posicionACorregir.y(), 0, juegoBattleCity.alto())
        const nuevaX = wraparound.aplicarA(posicionACorregir.x(), 0, juegoBattleCity.ancho())

        return new Position(x = nuevaX, y = nuevaY)
    }

    method nuevo_mover_tanque(unaOrientacion){
        if (permitir_movimiento.puedoMovermeEnEstaDireccion(self, unaOrientacion)){
            const nuevaPosicion = unaOrientacion.siguientePosicion(posicion)
            posicion = self.posicionCorregida(nuevaPosicion)
            direccion = unaOrientacion
        }
        direccion = unaOrientacion
    }
    // ATAQUE DISPARAR TANQUES
    method puedeDispararOtra() = balas_activas_del_tanque.size() < 1

    method balas_que_disparo_el_tanque() {
        return balas_activas_del_tanque
    }

    method irBorrandoBalas(){
        const bala_que_encabeza_la_lista = balas_activas_del_tanque.head()
        balas_activas_del_tanque.remove(bala_que_encabeza_la_lista)
    } 

    method disparar_de_tanques(){
        if(self.puedeDispararOtra()) {
            const bala = new Bala(direccion = self.direccion(), posicion = self.position())  /* self.direccion().siguientePosicion(self.position() */

            balas_activas_del_tanque.add(bala)
            bala.dibujarBala()
            bala.tuBalaChocoConAlgo(self, bala)

            game.sound("tanque_disparando.wav").play()
        }
    }
    // RESPAWN 
    method aRespawnear(){
        posicion = spawn
        game.sound("balas_chocando.wav").play()
    }

    method opcion_respawn(valor){
        respawn = valor
    }
    // ROBAR, RECUPERAR Y SOLTAR BANDERA (HALCON)

    method banderaQueLleva() = banderaQueLleva

    method urtarBandera() {
        game.onCollideDo(self, {halcon => halcon.fueUrtadoPor(self)})
    }

    method recuperarBandera(){
        game.onCollideDo(self, {halcon => halcon.recuperada(self)})
    }

    method dejarBanderaEnBase(){
        game.onCollideDo(self, {base => base.dejarBanderaEnBase(self)})
    }

    method llevaLaBanderaDeAlguien(){
        lleva_una_bandera = true
    }

    method noLlevarUnaBandera(){
        banderaQueLleva = null
        lleva_una_bandera = false
    }

    method agarrarBandera(unaBandera){
        // if(!unaBandera.aSidoCapturada())
        banderaQueLleva = unaBandera
        self.llevaLaBanderaDeAlguien()
    }

    method soltar_bandera() {
        banderaQueLleva.bandera_cae_al_suelo_desde_la_ubicacion_de(self)
        self.noLlevarUnaBandera()
    }

    // GANAR RONDA Y SI ES TANGIBLE EL TANQUE

    method rondas_ganadas() = rondas_ganadas

    method ganar_ronda() {
        rondas_ganadas = rondas_ganadas + 1
    }

    method esAtravesable() = false

    method explotar_tanque(unTanque){
        game.removeVisual(unTanque)
        game.sound("balas_chocando.wav").play()
    }

    // COLISION DE BALA CON UN TANQUE - SI DEBE RESPAWNEAR y SOLTAR BANDERA o DESTRUIRSE
    method teImpactoLaBalaDe(elQueDisparo, unaBala) {

        if (self != elQueDisparo){
            if (respawn) {
                if (lleva_una_bandera){
                    self.soltar_bandera()
                    self.aRespawnear()
                    borrar_balas.bala_logro_su_objetivo(elQueDisparo, unaBala)
                }

                self.aRespawnear()
                borrar_balas.bala_logro_su_objetivo(elQueDisparo, unaBala)
            }            
            else {  
                if (verificar_finalizacion_partida.gano_alguien()){
                    verificar_finalizacion_partida.mensaje_victoria()
                    self.explotar_tanque(self)
                }
                else{
                    elQueDisparo.ganar_ronda()
                    self.opcion_respawn(true)
                    self.explotar_tanque(self)
                    borrar_balas.bala_logro_su_objetivo(elQueDisparo, unaBala)
                    reiniciar_mapa.recargar_escena(nivel1)
                }       
            }
        }          
    }
}
       
object jugador2_tanque inherits TanqueJugador (posicion = new Position (x = 6, y = 6)) {

    method actividad(){
            keyboard.p().onPressDo {
            self.disparar_de_tanques()
            }

            keyboard.right().onPressDo {
            self.nuevo_mover_tanque(derecha)
            self.image("tankP2_right.png")
            }

            keyboard.left().onPressDo {
            self.nuevo_mover_tanque(izquierda)
            self.image("tankP2_left.png")
            }

            keyboard.down().onPressDo {
            self.nuevo_mover_tanque(abajo)
            self.image("tankP2_down.png")
            }

            keyboard.up().onPressDo {
            self.nuevo_mover_tanque(arriba)
            self.image("tankP2_up.png")
            }

            self.urtarBandera()
            self.recuperarBandera()
            self.dejarBanderaEnBase()
    }
}

object jugador1_tanque inherits TanqueJugador (posicion = new Position (x = 3, y = 3)) {

    method actividad(){
            keyboard.f().onPressDo {
            self.disparar_de_tanques()
            game.say(self, "Al ataque")
            }

            keyboard.d().onPressDo {
            self.nuevo_mover_tanque(derecha)
            self.image("tank_right.png")
            }

            keyboard.a().onPressDo {
            self.nuevo_mover_tanque(izquierda)
            self.image("tank_left.png")
            }

            keyboard.s().onPressDo {
            self.nuevo_mover_tanque(abajo)
            self.image("tank_down.png")
            }

            keyboard.w().onPressDo {
            self.nuevo_mover_tanque(arriba)
            self.image("tank_up.png")
            }

            self.urtarBandera()
            self.recuperarBandera()
            self.dejarBanderaEnBase()
    }
}

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

    method esAtravesable() = true
}

object permitir_movimiento{

    method puedoMovermeEnEstaDireccion (entidad, unaOrientacion) {
        return game.getObjectsIn(unaOrientacion.siguientePosicion(entidad.position())).all {unObj => unObj.esAtravesable()}
    }
}