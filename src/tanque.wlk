import wollok.game.*
import battlecity.*
import bala.*
import halcon.*
import mapa.*
import movimiento.*

class TanqueJugador {

    var direccion = sinDireccion
    var sprite = "tank_up.png"
    var rondas_ganadas = 0
    var respawn = true
    var inmune = false

    var acuatico = false

    var posicion

    const spawn = posicion

    var banderaQueLleva = null
    var lleva_una_bandera = false
    
    const balas_activas_del_tanque = []
    var cargador = 1
    var velocidad_balas = 10

    // SPRITE TANQUES 
    method image(){
        return sprite
    }

    method image(nuevoSprite){
        sprite = nuevoSprite
    }
    // ANDAR POR AGUA

    method irPorAgua() = acuatico

    method habilitarIrPorAgua(valor){
        acuatico = valor
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

    /* method puedoMovermeEnEstaDireccion (unaOrientacion) {
        return game.getObjectsIn(unaOrientacion.siguientePosicion(posicion)).all {unObj => unObj.esAtravesable(self)}
    } */

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
    method puedeDispararOtra() = balas_activas_del_tanque.size() < cargador

    method aumentarMunicionEn(valor){
        cargador = valor
    }

    method velocidad_balas() = velocidad_balas

    method aumentarVelocidadBala(nuevaVelocidad){
        velocidad_balas = nuevaVelocidad
    }

    method balas_que_disparo_el_tanque() {
        return balas_activas_del_tanque
    }

    method irBorrandoBalas(unaBala){
        balas_activas_del_tanque.remove(unaBala)
    } 

    method disparar_de_tanques(){
        if(self.puedeDispararOtra()) {
            const bala = new Bala(lePerteneceA = self, direccion = self.direccion(), posicion = self.position())  /* self.direccion().siguientePosicion(self.position() */

            balas_activas_del_tanque.add(bala)
            bala.dibujarBala()
            bala.tuBalaChocoConAlgo(self, bala)

            game.sound("tanque_disparando.wav").play()
        }
    }
    // RESPAWN 
    method aRespawnear(){
        game.addVisual(self)
        posicion = spawn
    }

    method opcion_respawn(valor){
        respawn = valor
    }

    method normalizar(){
        inmune = false
        acuatico = false
        cargador = 1
        velocidad_balas = 60
        posicion = spawn
    }
    // PORTAR ESCUDO

    method llevarEscudo(){
        game.whenCollideDo(self, {unEscudo => unEscudo.seguirA(self)})
    }

    method inmune() = inmune
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

    method esAtravesable(entidad) = false

    method explotar_tanque(unTanque){
        game.removeVisual(unTanque)
        game.sound("balas_chocando.wav").play()
    }

    // COLISION DE BALA CON UN TANQUE - SI DEBE RESPAWNEAR y SOLTAR BANDERA o DESTRUIRSE
    method teImpactoLaBalaDe(elQueDisparo, unaBala) {
        if (self != elQueDisparo && !inmune){
            if (respawn) {
                if (lleva_una_bandera){
                    self.soltar_bandera()
                    game.schedule(1500, {self.aRespawnear()})
                    borrar_balas.bala_logro_su_objetivo(elQueDisparo, unaBala)
                }

                self.explotar_tanque(self)
                game.schedule(1500, {self.aRespawnear()})
                self.normalizar()
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
        borrar_balas.bala_logro_su_objetivo(elQueDisparo, unaBala)          
    }

    // REGOCER ITEMS

    method agarrarItem(){
        game.onCollideDo(self, {n => n.efecto(self)})
    }

    // SER INMUNE 

    method cambiarEstadoInmunidad(estado){
        inmune = estado
    }
}
       
object jugador2_tanque inherits TanqueJugador (posicion = new Position (x = 6, y = 6)) {

    var controles = normal

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

    method cambiar (nuevoControles) {
        controles = nuevoControles
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
            self.agarrarItem()
            self.llevarEscudo()       
    }

    // NO SE PUDO IMPLEMENTAR
    method velocidadBalas() {
        game.onTick(self.velocidad_balas(), "DesplazarBalasTanque1", {
            self.balas_que_disparo_el_tanque().forEach({n => n.moverBalasDe(self)})
            })
    }

    // NO SE PUDO IMPLEMENTAR
    method detenerTick() {
        game.removeTickEvent("DesplazarBalasTanque1")
    }
}



object normal {
    method movimientos(){
            keyboard.p().onPressDo {
            jugador2_tanque.disparar_de_tanques()
            }

            keyboard.right().onPressDo {
            jugador2_tanque.nuevo_mover_tanque(derecha)
            jugador2_tanque.image("tankP2_right.png")
            }

            keyboard.left().onPressDo {
            jugador2_tanque.nuevo_mover_tanque(izquierda)
            jugador2_tanque.image("tankP2_left.png")
            }

            keyboard.down().onPressDo {
            jugador2_tanque.nuevo_mover_tanque(abajo)
            jugador2_tanque.image("tankP2_down.png")
            }

            keyboard.up().onPressDo {
            jugador2_tanque.nuevo_mover_tanque(arriba)
            jugador2_tanque.image("tankP2_up.png")
            }

            jugador2_tanque.urtarBandera()
            jugador2_tanque.recuperarBandera()
            jugador2_tanque.dejarBanderaEnBase()
    }
}

