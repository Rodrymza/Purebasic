Enumeration 
  #menu
  #titulo
  #cascadia
  #ventana_principal
  #fecha_actual
  #fecha_usuario
  #cambiar_fecha
  #monto
  #boton_anadir
  #descripcion_usuario
  #restablecer_fecha
  #combo_tipo
  #lista_movimientos
  #menu_ingreso
  #ventana_ingreso
  #codigo_text
  #menu_clientes
  #menu_proveedores
  #lista
  #nombre_text
  #domicilio_text
  #correo_text
  #boton_modificar
  #boton_siguiente
  #boton_grabar
  #boton_anterior
  #boton_guardar
  #text_egreso
  #text_ingreso
  #lista_clientes
  #boton_nuevo_cliente
  #titulo_combo
  #domicilio_indicador
  #correo_indicador
  #codigo_indicador
  #boton_buscar
  #ventana_clientes
  #listaClientes_ventana
  #titulo_lista
  #modificar
  #nuevo
  #texto_busqueda
  #busqueda
  #lista_busqueda
  #ventana_busqueda
EndEnumeration

LoadFont(#cascadia,"Cascadia Code SemiLight", 14, #PB_Font_Italic)

Structure datos
  nombre.s
  domicilio.s
  correo.s
EndStructure
Global contador
contador=0
Global provedores.s="Provedores", clientes.s="Clientes"

Structure lista
  descripcion.s
  monto.i
EndStructure


NewList lista_ventas.lista()

Global NewMap lista_clientes.datos() : Global NewMap  lista_provedores.datos()
AddMapElement(lista_clientes(),"1000001")
lista_clientes()\nombre="Consumidor Final"
lista_clientes()\domicilio="---"
lista_clientes()\correo="---"

Procedure actualizarVentanaIngreso(Map lista.datos())
  
    SetGadgetText(#codigo_text, MapKey(lista()))
    SetGadgetText(#nombre_text, lista()\nombre)
    SetGadgetText(#domicilio_text, lista()\domicilio)
    SetGadgetText(#correo_text, lista()\correo)
 
EndProcedure

Procedure ventanaListaClientes(Map lista.datos())
  OpenWindow(#ventana_clientes, 850, 200, 370, 400, "Lista de Clientes/Provedores", #PB_Window_SystemMenu)
  ListIconGadget(#listaClientes_ventana, 30, 50, 320, 330,"Descripcion", 210, #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#listaClientes_ventana,1,"DNI/CUIL",80)
  TextGadget(#titulo_lista, 30, 10, 320, 25, "Lista de Clientes/Provedores", #PB_Text_Center)
  valor=-1
  ForEach lista()
    AddGadgetItem(#listaClientes_ventana,-1,lista()\nombre + Chr(10) + MapKey(lista())
  Next
 
  Repeat
    event= WindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
               Case #listaClientes_ventana
        If EventType()=#PB_EventType_LeftDoubleClick :  If GetGadgetState(#listaClientes_ventana)>=0 : SelectElement(lista(),GetGadgetState(#listaClientes_ventana)) : actualizarVentanaIngreso(lista()) : EndIf  : EndIf 
        EndSelect
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_clientes)

        
    EndSelect
  Until event = #PB_Event_CloseWindow
  
EndProcedure

Procedure grabarDatos(Map lista.datos())
  AddElement(lista())
  ForEach lista()
    If GetGadgetText(#codigo_text)=lista()\id
      cont=cont+1 : posicion=ListIndex(lista())
    EndIf 
  Next
  If cont>0
    SelectElement(lista(),posicion)
    MessageRequester("Error","Ya existe un Cliente/Proveedor con el Cuil/DNI: (" + lista()\nombre + ")", #PB_MessageRequester_Error)
  Else
    lista()\id=GetGadgetText(#codigo_text)
    lista()\nombre=GetGadgetText(#nombre_text)
    lista()\domicilio=GetGadgetText(#domicilio_text)
    lista()\correo=GetGadgetText(#correo_text)
    MessageRequester("Guardado exitoso","Se ha guardado el Cliente/Provedor: " + lista()\nombre, #PB_MessageRequester_Ok)
  EndIf 
EndProcedure

Procedure ventanaingreso(Map lista.datos(),label$)
  OpenWindow(#ventana_ingreso, 0, 0, 530, 240, label$, #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  CreateMenu(#menu_ingreso, WindowID(#ventana_ingreso))
  MenuTitle("Menu")
  TextGadget(#titulo, 120, 10, 140, 25, label$)
  SetGadgetFont(#titulo, FontID(#cascadia))
  MenuItem(#nuevo,"Agregar " + label$)
  MenuItem(#lista,"Ver lista de " + GetGadgetText(#titulo))
  MenuItem(#modificar,"Recorrer y modificar")
  TextGadget(#PB_Any, 280, 20, 80, 20, "DNI/CUIL")
  StringGadget(#codigo_text, 370, 15, 140, 25, "")
  SetGadgetColor(#codigo_text,#PB_Gadget_BackColor,$FBC599)
  SetGadgetColor(#codigo_text,#PB_Gadget_FrontColor,$A91A05)
  TextGadget(#PB_Any, 20, 70, 120, 20, "Nombre:", #PB_Text_Right)
  StringGadget(#nombre_text, 150, 65, 280, 25, "")
  TextGadget(#PB_Any, 20, 100, 120, 20, "Domicilio:", #PB_Text_Right)
  StringGadget(#domicilio_text, 150, 95, 280, 25, "")
  TextGadget(#PB_Any, 20, 130, 120, 20, "Correo electronico: ", #PB_Text_Right)
  StringGadget(#correo_text, 150, 125, 280, 25, "")
  ButtonGadget(#boton_anterior, 40, 180, 100, 25, "< Anterior")
  DisableGadget(#boton_anterior,1)
  ButtonGadget(#boton_grabar, 150, 180, 100, 25, "Guardar")
  ButtonGadget(#boton_modificar, 270, 180, 100, 25, "Modificar")
  DisableGadget(#boton_modificar,1)
  ButtonGadget(#boton_siguiente, 390, 180, 100, 25, "Siguente >")
  DisableGadget(#boton_siguiente,1)
  
  Repeat
    event= WindowEvent()
    
    Select Event
      Case #PB_Event_Menu
        Select EventMenu()
          Case  #lista
              SelectElement(lista(),ventanaListaClientes(lista()))
              actualizarVentanaIngreso(lista())
          Case #modificar
            DisableGadget(#boton_grabar,1)
            DisableGadget(#boton_anterior,0)
            DisableGadget(#boton_siguiente,0)
            DisableGadget(#boton_modificar,0)
            SelectElement(lista_clientes(),0)
            DisableGadget(#nombre_text,0) : DisableGadget(#domicilio_text,0) : DisableGadget(#correo_text,0) : DisableGadget(#codigo_text,0)
            actualizarVentanaIngreso(lista_clientes())
          Case #nuevo
            DisableGadget(#boton_grabar,0)
            DisableGadget(#boton_anterior,1)
            DisableGadget(#boton_siguiente,1)
            DisableGadget(#boton_modificar,1)
            SetGadgetText(#codigo_text,"") : SetGadgetText(#nombre_text,"") : SetGadgetText(#correo_text,"") : SetGadgetText(#domicilio_text,"")
            DisableGadget(#nombre_text,0) : DisableGadget(#domicilio_text,0) : DisableGadget(#correo_text,0) : DisableGadget(#codigo_text,0)
        EndSelect
        
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_grabar
            grabarDatos(lista())
            
            DisableGadget(#nombre_text,1) : DisableGadget(#domicilio_text,1) : DisableGadget(#correo_text,1) :: DisableGadget(#codigo_text,1)
            ClearGadgetItems(#lista_clientes)
            If label$=clientes
              ForEach lista_clientes() : AddGadgetItem(#lista_clientes,-1,lista_clientes()\nombre) : Next 
            Else 
              ForEach lista_provedores() : AddGadgetItem(#lista_clientes,-1,lista_provedores()\nombre) : Next 
            EndIf
              
            Case #boton_siguiente
              NextElement(lista())
              actualizarVentanaIngreso(lista())
            Case #boton_anterior
              
            PreviousElement(lista())
            actualizarVentanaIngreso(lista())
        EndSelect
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_ingreso)
    EndSelect
  Until event = #PB_Event_CloseWindow
  
EndProcedure

Procedure ventanaBusqueda()
  OpenWindow(#ventana_busqueda, 0, 0, 480, 430, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  StringGadget(#texto_busqueda, 20, 40, 310, 25, "")
  ButtonGadget(#busqueda, 340, 40, 110, 25, "Buscar")
  ListIconGadget(#lista_busqueda, 20, 80, 440, 340, "ID", 110, #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#lista_busqueda, 1, "Nombre", 220)
  AddGadgetColumn(#lista_busqueda, 2, "Tipo", 100)
  TextGadget(#PB_Any, 20, 10, 390, 25, "Busqueda", #PB_Text_Center)
  
  ForEach lista_clientes()
    AddGadgetItem(#lista_busqueda,-1,lista_clientes()\id + Chr(10) + lista_clientes()\nombre + Chr(10) + clientes)
  Next
  ForEach lista_provedores()
    AddGadgetItem(#lista_busqueda,-1,lista_provedores()\id + Chr(10) + lista_provedores()\nombre + Chr(10) + provedores)
  Next
  Repeat  
    event=WindowEvent()
    Select event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #busqueda
            ClearGadgetItems(#lista_busqueda)
              ForEach lista_clientes()
                If LCase(GetGadgetText(#texto_busqueda))=LCase(lista_clientes()\nombre) Or GetGadgetText(#texto_busqueda)=lista_clientes()\id
                  AddGadgetItem(#lista_busqueda,-1,lista_clientes()\id + Chr(10) + lista_clientes()\nombre + Chr(10) + clientes)
                EndIf
              Next
              ForEach lista_provedores()
                If LCase(GetGadgetText(#texto_busqueda))=LCase(lista_provedores()\nombre) Or GetGadgetText(#texto_busqueda)=lista_provedores()\id
                  AddGadgetItem(#lista_busqueda,-1,lista_provedores()\id + Chr(10) + lista_provedores()\nombre + Chr(10) + provedores)
                EndIf
              Next
              
        EndSelect
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_busqueda)
        
    EndSelect
     
  Until event=#PB_Event_CloseWindow
EndProcedure


;Main

OpenWindow(#ventana_principal,0, 0, 490, 570, "Programa Principal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

CreateMenu(#menu, WindowID(#ventana_principal))
MenuTitle("Menu")
MenuItem(#menu_clientes,"Nuevo Cliente")
MenuItem(#menu_proveedores, "Nuevo Proveedor")
TextGadget(#fecha_actual, 330, 10, 100, 25, FormatDate("%dd/%mm/%yyyy",Date()))
TextGadget(#PB_Any, 40, 60, 130, 25, "Fecha del movimiento")
StringGadget(#fecha_usuario, 170, 55, 110, 25, GetGadgetText(#fecha_actual))
DisableGadget(#fecha_usuario, 1)
DateGadget(#cambiar_fecha, 300, 55, 100, 25, "")
TextGadget(#PB_Any, 40, 100, 130, 25, "Tipo de movimiento")
ComboBoxGadget(#combo_tipo, 180, 95, 130, 25)
AddGadgetItem(#combo_tipo, -1, "Ingreso")
AddGadgetItem(#combo_tipo, -1, "Egreso")
SetGadgetState(#combo_tipo,0)
TextGadget(#text_ingreso, 40, 150, 90, 25, "Ingreso $")
SetGadgetColor(#text_ingreso, #PB_Gadget_FrontColor,$BA5D28)

TextGadget(#text_egreso, 160, 150, 90, 25, "Egreso $")
SetGadgetColor(#text_egreso, #PB_Gadget_FrontColor,$2942F0)
StringGadget(#monto, 30, 175, 110, 25, "")
ButtonGadget(#boton_anadir, 310, 170, 100, 35, "Añadir")
SetGadgetColor(#monto,#PB_Gadget_BackColor,$EAC368)
SetGadgetColor(#monto,#PB_Gadget_FrontColor,$A91A05)
ListIconGadget(#lista_movimientos, 20, 350, 450, 180, "Fecha", 70)
AddGadgetColumn(#lista_movimientos, 1, "Descripcion", 230)
AddGadgetColumn(#lista_movimientos, 2, "Tipo", 60)
AddGadgetColumn(#lista_movimientos, 3, "Monto", 80)
TextGadget(#PB_Any, 20, 210, 80, 25, "Descripcion")
StringGadget(#descripcion_usuario, 110, 210, 350, 25, "")
ButtonGadget(#restablecer_fecha, 410, 55, 50, 25, "Hoy")
ButtonGadget(#boton_nuevo_cliente, 380, 245, 100, 25, "Nuevo Cliente")
TextGadget(#titulo_combo, 20, 250, 80, 25, "Cliente")
ComboBoxGadget(#lista_clientes, 110, 245, 170, 25)
TextGadget(#PB_Any, 50, 10, 130, 25, "Nueva Venta/Compra")
TextGadget(#PB_Any, 20, 290, 100, 25, "Domicilio:")
StringGadget(#domicilio_indicador, 130, 290, 150, 25, "") : DisableGadget(#domicilio_indicador,1)
TextGadget(#PB_Any, 20, 320, 100, 25, "Correo:")
StringGadget(#correo_indicador, 130, 320, 150, 25, "") : DisableGadget(#correo_indicador, 1)
TextGadget(#PB_Any, 320, 290, 150, 25, "DNI/CUIL", #PB_Text_Center)
StringGadget(#codigo_indicador, 320, 310, 150, 25, "") : DisableGadget(#codigo_indicador, 1)
ButtonGadget(#boton_buscar, 290, 245, 80, 25, "Buscar")

AddGadgetItem(#lista_movimientos,-1, GetGadgetText(#fecha_actual) + Chr(10) + "Fua amigo una banda vendiste" + Chr(10) + "Ingreso" + Chr(10) + "$45000")
SetGadgetItemColor(#lista_movimientos,0,#PB_Gadget_FrontColor,$BA5D28)

ForEach lista_clientes() : AddGadgetItem(#lista_clientes,-1,lista_clientes()\nombre) :Next

Repeat
  event= WindowEvent()
  Select Event
    Case #PB_Event_Menu
      Select EventMenu()
        Case #menu_clientes
          ventanaingreso(lista_clientes(),clientes)
        Case #menu_proveedores
          ventanaingreso(lista_provedores(),provedores)
      EndSelect
      
    Case #PB_Event_Gadget
      Select EventGadget()
          Case #cambiar_fecha
            SetGadgetText(#fecha_usuario,GetGadgetText(#cambiar_fecha))
            
            
          Case #restablecer_fecha
            SetGadgetText(#fecha_usuario,GetGadgetText(#fecha_actual))
          Case #combo_tipo
              SetGadgetText(#correo_indicador,"")
              SetGadgetText(#domicilio_indicador,"")
              SetGadgetText(#codigo_indicador,"")
            If GetGadgetState(#combo_tipo)=0
              ResizeGadget(#monto,30,#PB_Ignore,#PB_Ignore,#PB_Ignore)
              SetGadgetColor(#monto,#PB_Gadget_BackColor,$EAC368)
              SetGadgetColor(#monto,#PB_Gadget_FrontColor,$A91A05)
              SetGadgetText(#titulo_combo,"Cliente")
              SetGadgetText(#boton_nuevo_cliente,"Nuevo Cliente")
              ClearGadgetItems(#lista_clientes) : ForEach lista_clientes() : AddGadgetItem(#lista_clientes,-1,lista_clientes()\nombre) :Next
            Else
              ResizeGadget(#monto,160,#PB_Ignore,#PB_Ignore,#PB_Ignore)
              SetGadgetColor(#monto,#PB_Gadget_BackColor,$55BFFF)
              SetGadgetColor(#monto,#PB_Gadget_FrontColor,$0000CE)
              SetGadgetText(#titulo_combo,"Provedor")
              SetGadgetText(#boton_nuevo_cliente,"Nuevo Provedor")
              ClearGadgetItems(#lista_clientes) : ForEach lista_provedores() : AddGadgetItem(#lista_clientes,-1,lista_provedores()\nombre) :Next
                
            EndIf
            
          Case #boton_nuevo_cliente
            If GetGadgetState(#combo_tipo)=0
              ventanaingreso(lista_clientes(),clientes)
            Else
              ventanaingreso(lista_provedores(),provedores)
            EndIf
            
          Case #lista_clientes
            If GetGadgetState(#combo_tipo)=0
              SelectElement(lista_clientes(), GetGadgetState(#lista_clientes))
              SetGadgetText(#correo_indicador,lista_clientes()\correo)
              SetGadgetText(#domicilio_indicador,lista_clientes()\domicilio)
              SetGadgetText(#codigo_indicador,lista_clientes()\id)
            EndIf
            
          Case #boton_anadir
            If GetGadgetText(#descripcion_usuario)<>"" And GetGadgetText(#monto)<>""
              AddElement(lista_ventas())
              lista_ventas()\descripcion = FormatDate("%dd/%mm/%yyyy",Date()) + Chr(10) + GetGadgetText(#descripcion_usuario) + " (" + GetGadgetText(#lista_clientes) + ")" + Chr(10) + GetGadgetText(#combo_tipo)
              lista_ventas()\monto = Val(GetGadgetText(#monto))
              AddGadgetItem(#lista_movimientos,-1,lista_ventas()\descripcion + Chr(10) + "$" + Str(lista_ventas()\monto))
            Else
              MessageRequester("Error","Completa todos los campos",#PB_MessageRequester_Error)
            EndIf
            
          Case #boton_buscar
            ventanaBusqueda()
            
      EndSelect
      
  EndSelect
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 75
; FirstLine = 71
; Folding = 8
; EnableXP