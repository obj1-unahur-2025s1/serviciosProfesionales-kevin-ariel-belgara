class Universidad {
  var totalDonaciones = 0  
  var property provincia
  var property honorariosRecomendados
    method recibirDonacion(unImporte) {
        totalDonaciones = totalDonaciones + unImporte
    }
}

class ProfesionalVinculado{
    var property universidad
    method provinciasDondePuedeTrabajar()= #{universidad.provincia()}
    method honorariosPorHora()= universidad.honorariosRecomendados()
    method cobrar(unImporte){
        universidad.recibirDonacion(unImporte/2)
    }

}
class ProfesionalLitoral{
    var property universidad
    method provinciasDondePuedeTrabajar()=#{"Entre Rios", "Santa Fe", "Corrientes"}
    method honorariosPorHora()= 3000
   method cobrar(unImporte){
        asociacionProfesionalesLitoral.recibirDonacion(unImporte)
    }

}
class ProfesionalLibre{
    var property universidad
    var property honorariosPorHora
    const provincias = #{}
    var totalRecaudado = 0
    method agregarProvincia(unaProvincia){
        provincias.add(unaProvincia)
    }
    method provinciasDondePuedeTrabajar()= provincias
    method cobrar(unImporte){
        totalRecaudado = totalRecaudado + unImporte
    }
    method pasarDineroA(unProfesional,unImporte){
        unProfesional.cobrar(unImporte)
        totalRecaudado = totalRecaudado - unImporte.min(totalRecaudado)
    }
   
}
object asociacionProfesionalesLitoral{
   var totalDonaciones = 0
   method recibirDonacion(unImporte) {
       totalDonaciones = totalDonaciones + unImporte
   }
   
}
