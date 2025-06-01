import profesionales.*
class Empresa{
    var property honorariosReferencia
    const property profesionales=#{}
    const clientes =#{}
    method cuantosEstudiaronEn(unaUniversidad){
        return profesionales.count({profesional => profesional.universidad() == unaUniversidad})
    }
    method esProfesionalCaro(profesional){
      return  profesional.honorariosPorHora() > self.honorariosReferencia()
    }
    method profesionalesCaros(){
       return profesionales.filter({p=> self.esProfesionalCaro(p)})
    }
    method universidadesFormadoras(){
        return profesionales.map({p=> p.universidad()}).asSet()
    }
    method profesionalMasBarato(){
        return profesionales.min({p => p.honorariosPorHora()})
    }
    method esDeGenteAcotada() =
		!profesionales.any({p=>p.provinciasDondePuedeTrabajar().size() > 3})

    method esDeGenteAcotadaAll(){
        return profesionales.all({p => p.provinciasDondePuedeTrabajar().size() <= 3})
    }
    method puedeSatisfacerA(unSolicitante){
        return profesionales.any({p => unSolicitante.puedeSerAtendidaPor(p)})
    }
    method darServicio(unSolicitante){
        if(!self.puedeSatisfacerA(unSolicitante)){
            self.error("No puede ser atendido ")
             }
            const profesionalQueAtiende= profesionales.filter({p=>
			unSolicitante.puedeSerAtendidoPor(p)})
			.anyOne()
            profesionalQueAtiende.cobrar(profesionalQueAtiende.honorariosPorHora())
            clientes.add(unSolicitante)
        
       
    }
    method cantidadDeClientes(){
        return clientes.size()
    }
    method tieneComoClienteA(unCliente){
        return clientes.contains(unCliente)
    }
    	
	method profesionalCobraMenosQue(unValor) = profesionales.any({p=>p.honorariosPorHora() < unValor})
    method esPocoAtractivo(unProfesional){
		return unProfesional.provinciasDondePuedeTrabajar().all({
			provincia => self.existeOtroProfesionalMasBaratoQueCubra(provincia, unProfesional)
		})
	}

	method existeOtroProfesionalMasBaratoQueCubra(provincia, unProfesional){
		return profesionales.any({ p => 
			p.provinciasDondePuedeTrabajar().contains(provincia) &&
			p.honorariosPorHora() < unProfesional.honorariosPorHora()
		})
	}
}