Enumeration
  #database 
  #lista_datos
EndEnumeration
UseMySQLDatabase()
Global dbname.s="host=localhost port=3306 dbname=ventas", user.s="root", pass.s=""

;traer pedidos de cada cliente en una tabla
sql$ = "Select cliente.apellido1, cliente.nombre, categoria, fecha, total, comercial.apellido1 As Comercial " +
       "FROM ventas.cliente " +
       "JOIN ventas.pedido on ventas.cliente.id = ventas.pedido.id_cliente " +
       "join ventas.comercial on ventas.comercial.id = ventas.pedido.id_comercial " +
       "order by comercial.apellido1 asc " 

;taer tambien el nombre del comercial a cargo de la venta asociada
sql1$ = "Select apellido1, nombre, categoria, fecha, total" +
        " FROM ventas.cliente" + 
        " JOIN ventas.pedido on ventas.cliente.id = ventas.pedido.id_cliente order by cliente.apellido1 asc"


;Devuelve un listado que muestre todos los clientes, con todos los pedidos que han realizado y con los datos de los comerciales asociados a cada pedido
;utilizacion de alias en tablas
sql2$ = "select c.apellido1, c.nombre, p.fecha, p.total, cm.apellido1, cm.nombre, cm.comision, round(cm.comision*p.total,2) " + ;en esta linea agregamos el total de la comision a cobrar y redondeamos a dos cifras
        "from cliente c join pedido p on c.id = p.id_cliente " + 
        "join comercial cm on cm.id = p.id_comercial" + 
        " where cm.comision > 0.12 " +    ;condicion agregada solo entran comisiones mayores a 0.12
        " order by c.apellido1 asc"

NewList lista_valores.s()
request.s = sql2$
totalcolumnas = 8
OpenDatabase(#database, dbname, user, pass)
If DatabaseQuery(#database, request)
  While NextDatabaseRow(#database)
    texto.s = ""
    For i = 0 To totalcolumnas
      texto.s + GetDatabaseString(#database, i) + Chr(9)
    Next
    AddElement(lista_valores()) : lista_valores() = texto
    ;Debug texto 
  Wend  
EndIf


  OpenWindow(#PB_Any, 0, 0, 580, 380, "Datos MySQL", #PB_Window_SystemMenu)
  EditorGadget(#lista_datos, 30, 40, 520, 310)
  
  ForEach lista_valores()
    AddGadgetItem(#lista_datos,-1,lista_valores())
  Next
  
  Repeat
    event = WindowEvent()
    
  Until event = #PB_Event_CloseWindow
  
  

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 37
; FirstLine = 11
; EnableXP