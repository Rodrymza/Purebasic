Enumeration
  #db_id
EndEnumeration
 
UseMySQLDatabase()

db_name.s = "rodry_datos"
db_usuario.s = "rodrymza"
db_contrasenia.s = "jcmc1719"
db_url.s = "localhost"
db_puerto.s = "3306"

;establecer conexion con una base de datos ya creada
;el primer parametro es el id de la base de datos; despues el host, el port y el nombre de la base de datos; seguido con el usuario y contraseña como dos parametros aparte
If OpenDatabase(#db_id, "host=" + db_url + " port=" + db_puerto + " dbname=" + db_name, db_usuario, db_contrasenia)
  MessageRequester("Exito","Conectado a la base de datos de forma correcta")
  
Else
  MessageRequester("Error","No se pudo establecer conexion con la base de datos")
EndIf

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 14
; EnableXP