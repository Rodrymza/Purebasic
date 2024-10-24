Enumeration
  #database 
EndEnumeration
UseMySQLDatabase()
Global dbname.s="host=localhost port=3306 dbname=ventas", user.s="root", pass.s=""

request.s = "Select apellido1, nombre, categoria, fecha, total" +
" FROM ventas.cliente" + 
" JOIN ventas.pedido on ventas.cliente.id = ventas.pedido.id_cliente order by cliente.apellido1 asc"
totalcolumnas = 5
OpenDatabase(#database, dbname, user, pass)
If DatabaseQuery(#database, request)
  While NextDatabaseRow(#database)
    texto.s = ""
    For i = 0 To totalcolumnas
      texto.s + GetDatabaseString(#database, i) + Chr(9)
    Next
    Debug texto 
  Wend  
  
EndIf 

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 6
; EnableXP