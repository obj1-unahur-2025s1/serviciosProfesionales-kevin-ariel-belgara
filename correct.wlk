import universidad.*

class ProfesionalVinculado {
	var universidad
	
	method universidad() { return universidad }
	method universidad(univ) { universidad = univ }

	method provinciasDondePuedeTrabajar() = #{universidad.provincia()}

	method honorariosPorHora() = universidad.honorariosRecomendados()

	method cobrar(unImporte) {
		universidad.recibirDonacion(unImporte/2)
	}
}

class ProfesionalAsociado {
	var universidad
	
	method universidad() { return universidad }
	method universidad(univ) { universidad = univ }
	
	method provinciasDondePuedeTrabajar() { return #{"Entre Ríos", "Corrientes", "Santa Fe"} }
	
	method honorariosPorHora() { return 3000 }
	
	method cobrar(unImporte) {
		asociacionProfesionalesDelLitoral.recibirDonacion(unImporte)
	}
}

class ProfesionalLibre {
	var property universidad
	const provincias = #{}
	var property honorariosPorHora
	var totalRecaudado = 0
	
	method agregarProvincia(unaProvincia) {provincias.add(unaProvincia)}
	method quitarleProvincia(unaProvincia) {provincias.remove(unaProvincia)}
	
	method provinciasDondePuedeTrabajar() = provincias
	
	method cobrar(unImporte) { totalRecaudado += unImporte }
	
	method pasarDinero(profesional,unImporte) {
		profesional.cobrar(unImporte.min(totalRecaudado))
		totalRecaudado -= unImporte.min(totalRecaudado)
		// totalRecaudado = totalRecaudado - unImporte.min(totalRecaudado)
	}
}
class Universidad {
	var property provincia
	var property honorariosRecomendados
	var donacionesTotales = 0
	
	method recibirDonacion(unValor) {donacionesTotales += unValor} 
	
}

object asociacionProfesionalesDelLitoral {
	var donacionesTotales = 0
	method recibirDonacion(unValor) {donacionesTotales += unValor} 
}
import profesionales.*

class Persona {
	var property provinciaDondeVive
	
	method puedeSerAtendidoPor(unProfesional) =
		unProfesional.provinciasDondePuedeTrabajar().contains(provinciaDondeVive)	
}

class Institucion {
	const universidadesQueReconoce = #{}
	
	method agregarUniversidad(unaUniversidad) {universidadesQueReconoce.add(unaUniversidad)}
	method quitarUniversidad(unaUniversidad) {universidadesQueReconoce.remove(unaUniversidad)}

	method puedeSerAtendidoPor(unProfesional) =
		universidadesQueReconoce.contains(unProfesional.universidad())

}

class Club {
	const provincias = #{}

	method agregarProvincia(unaProvincia) {provincias.add(unaProvincia)}

	method quitarProvincia(unaProvincia) {provincias.remove(unaProvincia)}	

	method puedeSerAtendidoPor(unProfesional) =
		!provincias.intersection(unProfesional.provinciasDondePuedeTrabajar()).isEmpty()
	// la interseccion de provincias en las que está el club y provincias donde
	// puede trabajar un profesional no está vacia (es decir que comparten al menos 1)
}
class Empresa {
	const profesionales = #{}
	var property honorariosDeReferencia
	const clientes = #{}
	
	method cuantosEstudiaronEn(unaUniversidad) = 
		profesionales.count({p=>p.universidad()==unaUniversidad})

	method profesionalesCaros() =
		profesionales.filter({p=>p.honorariosPorHora() > honorariosDeReferencia})

	method universidadesFormadoras() =
		profesionales.map({p=>p.universidad()}).asSet()
	
	method profesionalMasBarato() = 
		profesionales.min({p=>p.honorariosPorHora()})

	method esDeGenteAcotada() =
		!profesionales.any({p=>p.provinciasDondePuedeTrabajar().size() > 3})

	method esDeGenteAcotadaAll() =
		profesionales.all({p=>p.provinciasDondePuedeTrabajar().size() <= 3})
	
	method puedeSatisfacer(unSolicitante) =
		profesionales.any({p=>unSolicitante.puedeSerAtendidoPor(p)})

	method darServicio(unSolicitante) {
		if (! self.puedeSatisfacer(unSolicitante)) {
			self.error("No puede ser atendido ")
		}
		const profesionalQueAtiende = profesionales.filter({p=>
			unSolicitante.puedeSerAtendidoPor(p)})
			.anyOne()
		// console.println(profesionalQueAtiende) para ver en consola que profesional es
		profesionalQueAtiende.cobrar(profesionalQueAtiende.honorariosPorHora())
		clientes.add(unSolicitante)		
	}
	
	method cantidadDeClientes() = clientes.size()
	
	method tieneComoClienteA(unSolicitante) = clientes.contains(unSolicitante)
	
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