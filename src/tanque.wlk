import src.powerUps.*
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

    var controlesInvertidos = false
    
    const balas_activas_del_tanque = []
    var cargador = 1
    var velocidad_balas = 10


    method banderaQueLleva() = banderaQueLleva

    method controlesInvertidos(valor) {
        controlesInvertidos = valor
    }

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
        direccion = unaOrientacion

        if (controlesInvertidos) {
            direccion = unaOrientacion.controlInvertido()
            
        }

        if (permitir_movimiento.puedoMovermeEnEstaDireccion(self, direccion)){

            const nuevaPosicion = direccion.siguientePosicion(posicion)
            posicion = self.posicionCorregida(nuevaPosicion)   
        }
        
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
           //  bala.tuBalaChocoConAlgo(self, bala)

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


    method inmune() = inmune
    // ROBAR, RECUPERAR Y SOLTAR BANDERA (HALCON)

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
    method recibirImpactoDeBala(unaBala) {
        
        
        borrar_balas.bala_logro_su_objetivo(unaBala.lePerteneceA(), unaBala) 

        if (self != unaBala.lePerteneceA() && !inmune){
            

            if (respawn) {

                if (lleva_una_bandera){
                    self.soltar_bandera()

                }

                game.schedule(1500, {self.aRespawnear()})
                
                
            }

            
                        
            else {  
                if (verificar_finalizacion_partida.gano_alguien()){
                    verificar_finalizacion_partida.mensaje_victoria()
                }
                else{

                    unaBala.lePerteneceA().ganar_ronda()
                    self.opcion_respawn(true)
                    reiniciar_mapa.recargar_escena(nivel1)

                }       
            }

            self.explotar_tanque(self)
            self.normalizar()
        }
                 
    }

    // INTERACCIONES TANQUE CON OBJETOS DEL CAMPO

    method chocarConObjetos () {
        game.onCollideDo(self, {n => n.teChocoUnTanque(self)} )
    }

    method puedeSerDaniadoPorBala() = true

    // SER INMUNE 

    method cambiarEstadoInmunidad(estado){
        inmune = estado
    }
}
       
object jugador2_tanque inherits TanqueJugador (posicion = new Position (x = 6, y = 6)) {
        
    
    method actividad(){
            keyboard.p().onPressDo {
            self.disparar_de_tanques()
            }

            keyboard.right().onPressDo {
            self.nuevo_mover_tanque(derecha)
            self.mostrarSprite_jugador2(derecha)
            }

            keyboard.left().onPressDo {
            self.nuevo_mover_tanque(izquierda)
            self.mostrarSprite_jugador2(izquierda)
            }

            keyboard.down().onPressDo {
            self.nuevo_mover_tanque(abajo)
            self.mostrarSprite_jugador2(abajo)
            }

            keyboard.up().onPressDo {
            self.nuevo_mover_tanque(arriba)
            self.mostrarSprite_jugador2(arriba)
            }

            self.chocarConObjetos()

            self.mostrarSprite_jugador2(self.direccion())
    }

    method mostrarSprite_jugador2(direccionElegida){
        
        if (controlesInvertidos){
            self.image(direccionElegida.controlInvertido().imagenTanque2())
        }

        else {
            self.image(direccionElegida.imagenTanque2())
        }
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
            self.mostrarSprite_jugador1(derecha)
            }

            keyboard.a().onPressDo {
            self.nuevo_mover_tanque(izquierda)
            self.mostrarSprite_jugador1(izquierda)
            }

            keyboard.s().onPressDo {
            self.nuevo_mover_tanque(abajo)
            self.mostrarSprite_jugador1(abajo)
            }

            keyboard.w().onPressDo {
            self.nuevo_mover_tanque(arriba)
            self.mostrarSprite_jugador1(arriba)
            }

            self.chocarConObjetos()
    }

    method mostrarSprite_jugador1(direccionElegida){
        
        if (controlesInvertidos){
            self.image(direccionElegida.controlInvertido().imagenTanque1())
        }

        else {
            self.image(direccionElegida.imagenTanque1())
        }
    }
}



