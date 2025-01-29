;Programa que gestiona y guarda las ventas diarias de un comercio
;Datos guardados en txt
;Rodry Ramirez (c) 2024

Enumeration
  #ventana_principal : #lista_ventas : #boton_nuevaVenta
  #boton_borrar : #boton_modificar : #container_total
  #container_filtrado : #Font_Window_2_0 : #ventana_nuevaventa
  #vendedor : #monto : #boton_aceptar
  #titulo01 : #Font_Window_3_0 : #combo_mediosPago
  #combo_medios_de_pago : #menu_principal : #mod_vendedores
  #combo_vendedor : #listicon_modificar : #nuevo_lista
  #modificar_lista : #borrar_lista : #ventana_modificacion
  #mod_mediosdepago : #pago_predeterminado : #lista_medio_predeterminado
  #boton_ok_medioPago : #ventana_pagoPredeterminado : #archivo_vendedores
  #archivo_mediosDePago : #archivo_ventas
EndEnumeration

LoadFont(#Font_Window_2_0,"Trebuchet MS", 12)
LoadFont(#Font_Window_3_0,"Times New Roman", 12)

Global pago_predeterminado=0
Define.s vendedores_string = "Vendedores", mediosPago_string = "Medios de Pago", modificar="modificar", nueva="nueva"
Global ventas$="Ventas.txt"

NewList medios_de_pago.s()

NewList vendedores.s()

Structure detalles
  hora.s
  vendedor.s
  pago.s
  monto.s
EndStructure

NewList lista_ventas.detalles()

Procedure actualizar_gadget(List lista.s(),gadget) ;actualizar listIcon en ventana de modificacion
  ClearGadgetItems(gadget)
  ForEach lista() : AddGadgetItem(gadget,-1,lista()) : Next
EndProcedure

Procedure nueva_venta(List listapagos.s(),List listavendedores.s(),List listaventas.detalles(), state,pago,label.s)
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
  If label="modificar" : SelectElement(listaventas(),GetGadgetState(#lista_ventas)) : SetGadgetText(#monto,listaventas()\monto) 
    SetGadgetText(#titulo01,"Modificar Venta") : SetGadgetText(#combo_medios_de_pago,listaventas()\pago) : SetGadgetText(#vendedor,listaventas()\vendedor) : EndIf   
  Repeat
    event = WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_nuevaventa)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_aceptar
            If label="nueva" : AddElement(listaventas()) : listaventas()\hora=FormatDate("%hh:%mm:%ss",Date()) : EndIf 
            listaventas()\vendedor=GetGadgetText(#vendedor)
            listaventas()\pago=GetGadgetText(#combo_medios_de_pago)
            listaventas()\monto=GetGadgetText(#monto)
            ClearGadgetItems(#lista_ventas)
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
            If GetGadgetText(#listicon_modificar)=""
              MessageRequester("Error","No seleccionaste medio a modificar",#PB_MessageRequester_Error)
            Else
            SelectElement(lista_parametro(),GetGadgetState(#listicon_modificar))
              nombre.s=InputRequester("Modificar","Ingrese nuevo nombre","")
              If nombre.s<>""
                actualizar_gadget(lista_parametro(),#listicon_modificar)
                actualizar_gadget(lista_parametro(),gadget_principal) : SetGadgetState(gadget_principal,state)
              Else
                MessageRequester("Error","No ingresaste un nombre",#PB_MessageRequester_Error)
              EndIf 
          EndIf 
          Case #listicon_modificar
            If EventType() = #PB_EventType_LeftDoubleClick And GetGadgetText(#listicon_modificar)<>""
              SelectElement(lista_parametro(),GetGadgetState(#listicon_modificar))
              nombre.s=InputRequester("Modificar","Ingrese nuevo nombre","")
              If nombre.s<>""
                actualizar_gadget(lista_parametro(),#listicon_modificar)
                actualizar_gadget(lista_parametro(),gadget_principal) : SetGadgetState(gadget_principal,state)
              Else
                MessageRequester("Error","No ingresaste un nombre",#PB_MessageRequester_Error)
              EndIf 
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

Procedure leer_archivo(string.s,List lista_parametro.s(),archivo)
  string=string + ".txt"
  If ReadFile(archivo,string)
    While Eof(archivo)=0
      AddElement(lista_parametro()) : lista_parametro()=ReadString(archivo)
    Wend
  EndIf 
EndProcedure

Procedure leer_archivo_ventas(List ventas.detalles())
  If ReadFile(#archivo_ventas,ventas$)
    While Eof(#archivo_ventas)=0
      string.s=ReadString(#archivo_ventas)
      AddElement(ventas())
      ventas()\hora=StringField(string,1,",")
      ventas()\vendedor=StringField(string,2,",")
      ventas()\pago=StringField(string,3,",")
      ventas()\monto=StringField(string,4,",")
    Wend
  EndIf
EndProcedure

Procedure guardar_archivo_ventas(List ventas.detalles())
  CreateFile(#archivo_ventas,ventas$)
  ForEach ventas()
    WriteStringN(#archivo_ventas,ventas()\hora + "," + ventas()\vendedor + "," + ventas()\pago + "," + ventas()\monto)
  Next
  CloseFile(#archivo_ventas)
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
AddGadgetColumn(#lista_ventas, 1, "Descripcion", 200)
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

leer_archivo(vendedores_string,vendedores(),#archivo_vendedores)
leer_archivo(mediosPago_string,medios_de_pago(),#archivo_mediosDePago)
leer_archivo_ventas(lista_ventas())
ForEach medios_de_pago() : AddGadgetItem(#combo_mediosPago,-1,medios_de_pago()) : Next : SetGadgetState(#combo_mediosPago,pago_predeterminado)
ForEach vendedores() : AddGadgetItem(#combo_vendedor,-1,vendedores()) : Next : SetGadgetState(#combo_vendedor,0)
ForEach lista_ventas() : AddGadgetItem(#lista_ventas,-1,lista_ventas()\hora + Chr(10) + lista_ventas()\vendedor + Chr(10) + lista_ventas()\pago + Chr(10) +lista_ventas()\monto + Chr(10)) : Next

Repeat
  event = WindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_nuevaVenta
          nueva_venta(medios_de_pago(),vendedores(),lista_ventas(),GetGadgetState(#combo_vendedor),pago_predeterminado,nueva)
          guardar_archivo_ventas(lista_ventas())
        Case #boton_modificar
          nueva_venta(medios_de_pago(),vendedores(),lista_ventas(),GetGadgetState(#combo_vendedor),pago_predeterminado,modificar)
          guardar_archivo_ventas(lista_ventas())
        Case #boton_borrar
          result=MessageRequester("Atencion","Borrar la venta seleccionada?",#PB_MessageRequester_YesNo)
          If result=#PB_MessageRequester_Yes
            SelectElement(lista_ventas(),GetGadgetState(#lista_ventas))
            DeleteElement(lista_ventas())
            ClearGadgetItems(#lista_ventas)
            ForEach lista_ventas() : AddGadgetItem(#lista_ventas,-1,lista_ventas()\hora + Chr(10) + lista_ventas()\vendedor + Chr(10) + lista_ventas()\pago + Chr(10) +lista_ventas()\monto + Chr(10)) : Next
            guardar_archivo_ventas(lista_ventas())
          EndIf 
          
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

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 121
; FirstLine = 48
; Folding = E9
; EnableXP