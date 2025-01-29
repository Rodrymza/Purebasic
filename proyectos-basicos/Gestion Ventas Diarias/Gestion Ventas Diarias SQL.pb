
Enumeration
  #ventana_principal : #lista_ventas : #boton_nuevaVenta
  #boton_borrar : #boton_modificar :  #container_total
  #container_filtrado :  #Font_Window_2_0
  #ventana_nuevaventa :  #vendedor
  #monto :  #boton_aceptar
  #titulo01 :  #Font_Window_3_0
  #combo_mediosPago :  #combo_medios_de_pago
  #menu_principal : #mod_vendedores
  #combo_vendedor : #listicon_modificar
  #nuevo_lista : #modificar_lista
  #borrar_lista : #ventana_modificacion
  #mod_mediosdepago : #pago_predeterminado
  #lista_medio_predeterminado : #boton_ok_medioPago
  #ventana_pagoPredeterminado : #archivo_vendedores
  #archivo_mediosDePago : #archivo_ventas : #basedatos
EndEnumeration

UseMySQLDatabase()
Global dbname.s="host=localhost port=3306 dbname=ventas_diarias", user.s="rodry", pass.s="rodry1234"

LoadFont(#Font_Window_2_0,"Trebuchet MS", 12)
LoadFont(#Font_Window_3_0,"Times New Roman", 12)

Global pago_predeterminado=0
Define.s vendedores_string = "Vendedores", mediosPago_string = "Medios de Pago"
Global ventas$="Ventas.txt"

NewList medios_de_pago.s()
;AddElement(medios_de_pago()) : medios_de_pago()="Efectivo" : AddElement(medios_de_pago()) : medios_de_pago()="Debito"
;AddElement(medios_de_pago()) : medios_de_pago()="Credito" : AddElement(medios_de_pago()) : medios_de_pago()="Transferencia"
;AddElement(medios_de_pago()) : medios_de_pago()="MercadoPago"

NewList vendedores.s()
;AddElement(vendedores()) : vendedores()="Vendedor 1" : AddElement(vendedores()) : vendedores()="Vendedor 2"

Structure detalles
  hora.s
  vendedor.s
  pago.s
  monto.s
EndStructure

NewList lista_ventas.detalles()


Procedure asignar_db_gadget(gadget, tabla.s,campo.s = "*")
  request.s = "SELECT " + campo + " FROM " + tabla
  OpenDatabase(#basedatos, dbname, user, pass)
  DatabaseQuery(#basedatos,request)
  While NextDatabaseRow(#basedatos)
    AddGadgetItem(gadget, -1, GetDatabaseString(#basedatos,0))
  Wend  
  
EndProcedure

Procedure asignar_combo_lista(combobox, List lista.s())
  
  For i=0 To CountGadgetItems(combobox) - 1
    AddElement(lista())
    lista() = GetGadgetItemText(combobox, i)
  Next
  
EndProcedure

Procedure conectarbdd(comandosql.s)
  OpenDatabase(#basedatos,dbname, user, pass)
  If DatabaseUpdate(#basedatos,comandosql)
    ProcedureReturn #True
  Else
    ProcedureReturn #False
  EndIf   
EndProcedure

Procedure calcular_total_vendido()
  If OpenDatabase(basedatos, dbname, user, pass)
    If DatabaseQuery(basedatos, "SELECT sum(monto) FROM ventas")
      While NextDatabaseRow(basedatos)
        SetGadgetText(#container_total, "Total vendido $" + GetDatabaseString(basedatos, 0))
      Wend  
    EndIf 
  EndIf 
    
EndProcedure


Procedure crear_tablas()
  retorno=1
  If Not conectarbdd("CREATE TABLE vendedores (id INT AUTO_INCREMENT NOT NULL, nombre varchar(45) NOT NULL, PRIMARY KEY (id))")
    retorno=0
    MessageRequester("Error","Error al creat tabla de vendedores" + DatabaseError())
  EndIf
  If Not conectarbdd("CREATE TABLE medios_pago (nombres VARCHAR(45), PRIMARY KEY(nombres))")
    MessageRequester("Error","No se creo la tabla de medios de pago, error: " + DatabaseError())
    retorno=0
  EndIf 
  If Not conectarbdd("CREATE TABLE ventas (id INT AUTO_INCREMENT NOT NULL, fecha DATETIME, vendedor VARCHAR(20), pago VARCHAR(20), monto INT, PRIMARY KEY(id))")
    MessageRequester("Error", "Error al crear tabla de ventas: " + DatabaseError())
    retorno=0  
  EndIf 
ProcedureReturn retorno
EndProcedure

Procedure actualizar_gadget(List lista.s(),gadget) ;actualizar listIcon en ventana de modificacion
  ClearGadgetItems(gadget)
  ForEach lista() : AddGadgetItem(gadget,-1,lista()) : Next
EndProcedure

Procedure nueva_venta(List listapagos.s(),List listavendedores.s(),List listaventas.detalles(), state,pago)
  OpenWindow(#ventana_nuevaventa, 0, 0, 400, 240, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(#PB_Any, 40, 110, 100, 25, "Vendedor")
  ComboBoxGadget(#vendedor, 150, 105, 220, 25)
  TextGadget(#PB_Any, 40, 150, 90, 25, "Monto     $")
  StringGadget(#monto, 150, 145, 220, 25, "")
  TextGadget(#titulo01, 120, 20, 170, 30, "Nueva Venta", #PB_Text_Center)
  ButtonGadget(#boton_aceptar, 220, 190, 130, 25, "Aceptar")
  TextGadget(#PB_Any, 40, 70, 100, 25, "Medio de pago")
  SetGadgetFont(#titulo01, FontID(#Font_Window_3_0))
  ComboBoxGadget(#combo_medios_de_pago, 150, 65, 180, 25)
  actualizar_gadget(listapagos(),#combo_medios_de_pago)
  actualizar_gadget(listavendedores(),#vendedor)
  SetGadgetState(#vendedor,state)
  SetGadgetState(#combo_medios_de_pago,pago)
  SetActiveGadget(#monto)
  Repeat
    event = WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_nuevaventa)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_aceptar
            AddElement(listaventas())
            listaventas()\hora=FormatDate("%hh:%mm:%ss",Date())
            listaventas()\vendedor=GetGadgetText(#vendedor)
            listaventas()\pago=GetGadgetText(#combo_medios_de_pago)
            listaventas()\monto=GetGadgetText(#monto)
            ClearGadgetItems(#lista_ventas)
            request.s = "INSERT INTO ventas (fecha, vendedor, pago, monto) VALUES " + 
                        "('" + FormatDate("%yyyy-%mm-%dd %hh:%ii:%ss", Date()) + "', '" +
                        listaventas()\vendedor + "', '" + 
                        listaventas()\pago + "', " + 
                        listaventas()\monto + ")"
            Debug request
                        
            If OpenDatabase(basedatos, dbname, user, pass)
              If DatabaseUpdate(basedatos, request)
                CloseDatabase(#PB_All)
              Else 
                MessageRequester("Error", DatabaseError())
              EndIf
              CloseDatabase(#PB_All)
            Else
              MessageRequester("Error", DatabaseError())
            EndIf    
             
            ForEach listaventas() : AddGadgetItem(#lista_ventas,-1,listaventas()\hora + Chr(10) + listaventas()\vendedor + Chr(10) + listaventas()\pago + Chr(10) +listaventas()\monto + Chr(10)) : Next
           
            
            quit=1
            CloseWindow(#ventana_nuevaventa)
        EndSelect
    EndSelect
  Until event = #PB_Event_CloseWindow Or quit=1
EndProcedure

Procedure modificar_lista(List lista_parametro.s(), string.s,gadget_principal)
  
  OpenWindow(#ventana_modificacion, 0, 0, 280, 350,  "Modificar " + string, #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListIconGadget(#listicon_modificar, 10, 40, 260, 260, "Lista" , 250, #PB_ListIcon_GridLines)
  TextGadget(#PB_Any, 10, 10, 270, 25, "Lista de " + string, #PB_Text_Center)
  ButtonGadget(#nuevo_lista, 10, 310, 80, 25, "Nuevo")
  ButtonGadget(#modificar_lista, 100, 310, 80, 25, "Modificar")
  ButtonGadget(#borrar_lista, 190, 310, 80, 25, "Borrar")
  actualizar_gadget(lista_parametro(),#listicon_modificar)
  Repeat
    event = WindowEvent()
    Select event 
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_modificacion)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #nuevo_lista
            state=GetGadgetState(gadget_principal)
            nuevo.s=InputRequester(string,"Agregar nuevo " + string,"")
            AddElement(lista_parametro()) : lista_parametro()=nuevo.s
            actualizar_gadget(lista_parametro(),#listicon_modificar)
            actualizar_gadget(lista_parametro(),gadget_principal) : SetGadgetState(gadget_principal,state)
          Case #borrar_lista
            SelectElement(lista_parametro(),GetGadgetState(#listicon_modificar))
            DeleteElement(lista_parametro())
            actualizar_gadget(lista_parametro(),#listicon_modificar)
            actualizar_gadget(lista_parametro(),gadget_principal) : SetGadgetState(gadget_principal,state)
          Case #modificar_lista
            SelectElement(lista_parametro(),GetGadgetState(#listicon_modificar))
            lista_parametro()=InputRequester("Modificar","Ingrese nuevo nombre","")
            actualizar_gadget(lista_parametro(),#listicon_modificar)
            actualizar_gadget(lista_parametro(),gadget_principal) : SetGadgetState(gadget_principal,state)
          Case #listicon_modificar
            If EventType() = #PB_EventType_LeftDoubleClick
              SelectElement(lista_parametro(),GetGadgetState(#listicon_modificar))
              lista_parametro()=InputRequester("Modificar","Ingrese nuevo nombre","")
              actualizar_gadget(lista_parametro(),#listicon_modificar)
              actualizar_gadget(lista_parametro(),gadget_principal) : SetGadgetState(gadget_principal,state)
            EndIf 
        EndSelect
    EndSelect
    
  Until event = #PB_Event_CloseWindow
 HideWindow(#ventana_principal,0)
EndProcedure

Procedure medio_predeterminado(List lista_parametro.s())
  OpenWindow(#ventana_pagoPredeterminado, 0, 0, 200, 300, "Medios de Pago", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  ListViewGadget(#lista_medio_predeterminado, 10, 40, 180, 210)
  TextGadget(#PB_Any, 10, 10, 190, 25, "Seleccione Medio de Pago", #PB_Text_Center)
  ButtonGadget(#boton_ok_medioPago, 30, 260, 140, 25, "Seleccionar")
  actualizar_gadget(lista_parametro(),#lista_medio_predeterminado)
  Repeat
    event = WindowEvent()
    Select event 
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_pagoPredeterminado)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_ok_medioPago
            pago_predeterminado=GetGadgetState(#lista_medio_predeterminado)
            MessageRequester("Exito","El nuevo medio de pago predeterminado es " + GetGadgetText(#lista_medio_predeterminado))
            quit=1
            CloseWindow(#ventana_pagoPredeterminado)
          Case #lista_medio_predeterminado
            If EventType()=#PB_EventType_LeftDoubleClick
              pago_predeterminado=GetGadgetState(#lista_medio_predeterminado)
              MessageRequester("Exito","El nuevo medio de pago predeterminado es " + GetGadgetText(#lista_medio_predeterminado))
              quit=1
              CloseWindow(#ventana_pagoPredeterminado)
            EndIf 
            
        EndSelect
    EndSelect
    
  Until event = #PB_Event_CloseWindow Or quit=1
EndProcedure

Procedure guardar_archivo(nombre.s,List lista_parametro.s(),archivo)
  nombre=nombre+".txt"
  CreateFile(archivo,nombre)
  ForEach lista_parametro() : WriteStringN(archivo,lista_parametro()) : Next
  CloseFile(archivo)
EndProcedure

Procedure actualizar_lista_ventas(request.s = "SELECT fecha, vendedor, pago, monto FROM ventas order by fecha desc" )
  ClearGadgetItems(#lista_ventas)
  If OpenDatabase(basedatos, dbname, user, pass)
    If DatabaseQuery(basedatos, request)
      While NextDatabaseRow(basedatos)
        fecha.s = GetDatabaseString(basedatos, 0)
        vendedor.s = GetDatabaseString(basedatos, 1)
        pago.s = GetDatabaseString(basedatos, 2)
        monto.s = GetDatabaseString(basedatos, 3)
        AddGadgetItem(#lista_ventas, -1, fecha + Chr(10) + vendedor + Chr(10) + pago + Chr(10) + monto)
      Wend  
      FinishDatabaseQuery(basedatos)
    Else
      MessageRequester("Error", DatabaseError())
    EndIf 
    CloseDatabase(#PB_All)
  Else
    MessageRequester("Error", DatabaseError())
  EndIf 
  
  EndProcedure
  
Procedure guardar_archivo_ventas(List ventas.detalles())
  CreateFile(#archivo_ventas,ventas$)
  ForEach ventas()
    WriteStringN(#archivo_ventas,ventas()\hora + "," + ventas()\vendedor + "," + ventas()\pago + "," + ventas()\monto)
  Next
  CloseFile(#archivo_ventas)
EndProcedure

Procedure calcular_total_filtrado()
  total = 0
  For i = 0 To CountGadgetItems(#lista_ventas) - 1
    total + Val(GetGadgetItemText(#lista_ventas, i, 3))
  Next
  SetGadgetText(#container_filtrado, "Total filtrado $"  + Str(total))
EndProcedure


OpenWindow(#ventana_principal, 0, 0, 600, 690, "Gestion Ventas ", #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget)
TextGadget(#PB_Any, 20, 10, 560, 25, "Gestion Diaria de  Ventas", #PB_Text_Center)
CreateMenu(#PB_Any,WindowID(#ventana_principal))
MenuTitle("Configuracion")
MenuItem(#mod_vendedores,"Modificar vendedores")
MenuItem(#mod_mediosdepago,"Modificar Medios de Pago")
MenuItem(#pago_predeterminado,"Medio de Pago Predeterminado")
MenuTitle("Acerca de")
TextGadget(#PB_Any, 20, 10, 560, 25, "Gestion Diaria de  Ventas", #PB_Text_Center)
ListIconGadget(#lista_ventas, 20, 80, 560, 470, "Fecha/Hora", 150,#PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
AddGadgetColumn(#lista_ventas, 1, "Vendedor", 200)
AddGadgetColumn(#lista_ventas, 2, "Pago", 100)
AddGadgetColumn(#lista_ventas, 3, "Monto", 100)
ButtonGadget(#boton_nuevaVenta, 60, 560, 150, 25, "Nueva Venta")
ButtonGadget(#boton_borrar, 400, 560, 150, 25, "Borrar seleccion")
ButtonGadget(#boton_modificar, 230, 560, 150, 25, "Modificar seleccion")
ContainerGadget(#PB_Any, 280, 600, 300, 70)
TextGadget(#container_total, 100, 40, 180, 25, "Total vendido $           ", #PB_Text_Right)
SetGadgetFont(#container_total, FontID(#Font_Window_2_0))
TextGadget(#container_filtrado, 100, 10, 150, 25, "Total por filtro $           ", #PB_Text_Right)
CloseGadgetList()
ComboBoxGadget(#combo_mediosPago, 400, 35, 140, 25)
TextGadget(#PB_Any, 250, 40, 140, 25, "Filtrar por medio de pago")
TextGadget(#PB_Any, 20, 40, 70, 20, "Vendedor")
ComboBoxGadget(#combo_vendedor, 100, 35, 130, 25)


asignar_db_gadget(#combo_mediosPago, "medios_pago")
asignar_combo_lista(#combo_mediosPago, medios_de_pago())
asignar_db_gadget(#combo_vendedor, "vendedores", "nombre")
asignar_combo_lista(#combo_vendedor, vendedores())
ForEach medios_de_pago() : AddGadgetItem(#combo_mediosPago,-1,medios_de_pago()) : Next : SetGadgetState(#combo_mediosPago,pago_predeterminado)
ForEach vendedores() : AddGadgetItem(#combo_vendedor,-1,vendedores()) : Next : SetGadgetState(#combo_vendedor,0)
ForEach lista_ventas() : AddGadgetItem(#lista_ventas,-1,lista_ventas()\hora + Chr(10) + lista_ventas()\vendedor + Chr(10) + lista_ventas()\pago + Chr(10) +lista_ventas()\monto + Chr(10)) : Next
actualizar_lista_ventas()
calcular_total_filtrado()
calcular_total_vendido()

;If crear_tablas()
 ; MessageRequester("Atencion","Se crearon las tablas necesarias para el sistema", #PB_MessageRequester_Info)
;EndIf   

Repeat
  event = WindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_nuevaVenta
          nueva_venta(medios_de_pago(),vendedores(),lista_ventas(),GetGadgetState(#combo_vendedor),pago_predeterminado)
          guardar_archivo_ventas(lista_ventas())
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #mod_vendedores
          HideWindow(#ventana_principal,1)
          modificar_lista(vendedores(),vendedores_string,#combo_vendedor)
          guardar_archivo(vendedores_string,vendedores(),#archivo_vendedores)
        Case #mod_mediosdepago
          HideWindow(#ventana_principal,1)
          modificar_lista(medios_de_pago(),mediosPago_string,#combo_mediosPago)
          guardar_archivo(mediosPago_string,medios_de_pago(),#archivo_mediosDePago)
        Case #pago_predeterminado
          medio_predeterminado(medios_de_pago())
          
      EndSelect
  EndSelect
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 79
; FirstLine = 58
; Folding = MA-
; EnableXP