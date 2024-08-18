Structure campos      ;definicion de estructura
  nombre.s
  apellido.s
  dni.s
EndStructure

NewMap Personas.campos()    ;definicion de mapa y relacion con estructura de datos

personas("36499229")\nombre = "Rodrigo"       ;asignacion de valores
personas("36499229")\apellido = "Ramirez"
personas("36499229")\dni = "36499229"

personas("3873146")\nombre = "Rocio"
personas("3873146")\apellido = "Arancibia"
personas("3873146")\dni = "38473146"

ForEach personas()
  
  Debug personas()\apellido
  Debug personas()\nombre
  Debug personas()\dni
  
Next

AddMapElement(Personas(),"55924237")
personas("55924237")\nombre = "Juan Cruz"
personas("55924237")\apellido = "Ramirez"
personas("55924237")\dni = "55924237"
Debug "se agrego un elemento"
ForEach personas()
  
  Debug personas()\apellido
  Debug personas()\nombre
  Debug personas()\dni
  
Next
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 8
; EnableXP