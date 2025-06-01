class Persona{
    var property provinciaDondeVive
    method puedeSerAtendidoPor(profesional){
        return profesional.provinciasDondePuedeTrabajar().contains(provinciaDondeVive)
    }
}
class Institucion{
    const universidadesQueReconoce = #{}
    method agregarUniversidad(unaUniversidad) {universidadesQueReconoce.add(unaUniversidad)}
	method quitarUniversidad(unaUniversidad) {universidadesQueReconoce.remove(unaUniversidad)}
    method puedeSerAtendidoPor(profesional){
        return universidadesQueReconoce.contains(profesional.universidad())
    }
}
class Club{
    const provincias  = #{}
    method agregarProvincia(unaProvincia) {provincias.add(unaProvincia)}

	method quitarProvincia(unaProvincia) {provincias.remove(unaProvincia)}	

    method puedeSerAtendidoPor(unProfesional) =
		!provincias.intersection(unProfesional.provinciasDondePuedeTrabajar()).isEmpty()
	// la interseccion de provincias en las que está el club y provincias donde
	// puede trabajar un profesional no está vacia (es decir que comparten al menos 1)
}