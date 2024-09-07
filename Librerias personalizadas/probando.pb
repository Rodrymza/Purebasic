IncludeFile "list_library.pb"


NewList nombres.s()

appendString(nombres(), "Rodrigo")
appendString(nombres(), "Rocio")
appendString(nombres(), "Clara")
appendString(nombres(), "Juan")
appendString(nombres(), "Hernan")

NewList apellidos.s()

appendString(apellidos(), "Ramirez")
appendString(apellidos(), "Arancibia")
appendString(apellidos(), "Morales")

extendStringList(apellidos(),nombres())

ForEach nombres() : Debug nombres() : Next 
Debug "lista invertida"
invertStringList(nombres())


ForEach nombres() : Debug nombres() : Next 

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 25
; EnableXP
; HideErrorLog