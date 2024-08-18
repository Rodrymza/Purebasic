Enumeration 
  #menu
  #titulo
  #cascadia
  #ventana_principal
  #fecha_actual
  #fecha_usuario
  #cambiar_fecha
  #monto
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
EndEnumeration

LoadFont(#cascadia,"Cascadia Code SemiLight", 14, #PB_Font_Italic)

Structure datos
  codigo.s
  nombre.s
  domicilio.s
  correo.s
EndStructure

Global provedores.s="Provedores", clientes.s="Clientes"
Global NewList lista_clientes.s() : Global NewList lista_provedores.s()

Procedure ventanaingreso(label$)
  OpenWindow(#ventana_ingreso, 0, 0, 530, 240, "Proveedores", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  
  CreateMenu(#menu_ingreso, WindowID(#ventana_ingreso))
  MenuTitle("Menu")
  TextGadget(#titulo, 120, 10, 140, 25, label$)
  SetGadgetFont(#titulo, FontID(#cascadia))
  
  MenuItem(#lista,"Ver lista de " + GetGadgetText(#titulo))
  TextGadget(#PB_Any, 280, 20, 80, 20, "Codigo unico")
  StringGadget(#codigo_text, 370, 15, 140, 25, "")
  DisableGadget(#codigo_text, 1)
  TextGadget(#PB_Any, 20, 70, 120, 20, "Nombre:", #PB_Text_Right)
  StringGadget(#nombre_text, 150, 65, 280, 25, "")
  TextGadget(#PB_Any, 20, 100, 120, 20, "Domicilio:", #PB_Text_Right)
  StringGadget(#domicilio_text, 150, 95, 280, 25, "")
  TextGadget(#PB_Any, 20, 130, 120, 20, "Correo electronico: ", #PB_Text_Right)
  StringGadget(#correo_text, 150, 125, 280, 25, "")
  ButtonGadget(#boton_anterior, 40, 180, 100, 25, "< Anterior")
  ButtonGadget(#boton_grabar, 150, 180, 100, 25, "Grabar")
  ButtonGadget(#boton_modificar, 270, 180, 100, 25, "Modificar")
  ButtonGadget(#boton_siguiente, 390, 180, 100, 25, "Siguente >")
  
  Repeat
    event= WindowEvent()
    
    Select Event
      Case #PB_Event_Menu
        Select EventMenu()

        EndSelect
        
      Case #PB_Event_Gadget
        Select EventGadget()
            
        EndSelect
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_ingreso)
    EndSelect
  Until event = #PB_Event_CloseWindow
  
EndProcedure

;Main

OpenWindow(#ventana_principal,0, 0, 490, 570, "Programa Principal", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

CreateMenu(#menu, WindowID(#ventana_principal))
MenuTitle("Menu")
MenuItem(#menu_clientes,"Acceso Clientes")
MenuItem(#menu_proveedores, "Acceso Proveedores")
TextGadget(#fecha_actual, 330, 10, 100, 25, FormatDate("%dd-%mm-%yyyy",Date()))
TextGadget(#PB_Any, 40, 60, 130, 25, "Fecha del movimiento")
StringGadget(#fecha_usuario, 170, 55, 110, 25, "")
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
SetGadgetColor(#monto,#PB_Gadget_BackColor,$EAC368)
ListIconGadget(#lista_movimientos, 20, 350, 450, 180, "Fecha", 70)
AddGadgetColumn(#lista_movimientos, 1, "Descripcion", 230)
AddGadgetColumn(#lista_movimientos, 2, "Tipo", 60)
AddGadgetColumn(#lista_movimientos, 3, "Monto", 80)
TextGadget(#PB_Any, 20, 210, 80, 25, "Descripcion")
StringGadget(#descripcion_usuario, 110, 210, 350, 25, "")
ButtonGadget(#restablecer_fecha, 410, 55, 50, 25, "Hoy")
ButtonGadget(#boton_nuevo_cliente, 360, 245, 100, 25, "Nuevo Cliente")
TextGadget(#titulo_combo, 20, 250, 80, 25, "Cliente")
ComboBoxGadget(#lista_clientes, 110, 245, 240, 25)
TextGadget(#PB_Any, 50, 10, 130, 25, "Nueva Venta/Compra")

AddGadgetItem(#lista_movimientos,-1, GetGadgetText(#fecha_actual) + Chr(10) + "Fua amigo una banda vendiste" + Chr(10) + "Ingreso" + Chr(10) + "$45000")
SetGadgetItemColor(#lista_movimientos,0,#PB_Gadget_FrontColor,$BA5D28)

Repeat
  event= WindowEvent()
  Select Event
    Case #PB_Event_Menu
      Select EventMenu()
        Case #menu_clientes
          ventanaingreso(clientes)
        Case #menu_proveedores
          ventanaingreso(provedores)
      EndSelect
      
    Case #PB_Event_Gadget
      Select EventGadget()
          Case #cambiar_fecha
            SetGadgetText(#fecha_usuario,GetGadgetText(#cambiar_fecha))
            
            
          Case #restablecer_fecha
            SetGadgetText(#fecha_usuario,GetGadgetText(#fecha_actual))
          Case #combo_tipo
            If GetGadgetState(#combo_tipo)=0
              ResizeGadget(#monto,30,#PB_Ignore,#PB_Ignore,#PB_Ignore)
              SetGadgetColor(#monto,#PB_Gadget_BackColor,$EAC368)
              SetGadgetText(#titulo_combo,"Cliente")
              SetGadgetText(#boton_nuevo_cliente,"Nuevo Cliente")
            Else
              ResizeGadget(#monto,160,#PB_Ignore,#PB_Ignore,#PB_Ignore)
              SetGadgetColor(#monto,#PB_Gadget_BackColor,$55BFFF)
              SetGadgetText(#titulo_combo,"Provedor")
              SetGadgetText(#boton_nuevo_cliente,"Nuevo Provedor")
            EndIf
            
          Case #boton_nuevo_cliente
            If GetGadgetState(#combo_tipo)=0
              ventanaingreso(clientes)
            Else
              ventanaingreso(provedores)
            EndIf
            
            
      EndSelect
      
  EndSelect
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 51
; FirstLine = 38
; Folding = -
; EnableXP