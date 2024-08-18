Enumeration
  #WindowMain
  #texto_busqueda
  #boton_busqueda
  #boton_quitar
  #boton_cambiar
  #boton_cambiarcantidad
  #boton_precio
  #texto_articulo
  #Total_texto
  #boton_nuevaVenta
  #subtotal_container
  #total_container
  #lista_compra
  #container
  #lista_busqueda
  #texto_buscar_ventana
  #boton_buscar_ventana
  #ventana_busqueda
  #menu_articulos
  #ventana_agregar
  #boton_agregar
  #precio_articuloAgregado
  #descripcion_articuloAgregado
  #pop_busqueda
  #menu_busqueda_quitar
  #archivo_venta
  #statusbar
  #reloj
EndEnumeration

;Variables
Structure descripcion
  nombre.s
  precio.l
  cantidad.l
EndStructure

Global NewList articulos.descripcion()
AddElement(articulos()) : articulos()\nombre = "Coca cola 2.5 Lts" : articulos()\precio = 2800
AddElement(articulos()) : articulos()\nombre = "Coca cola Light 2.5 Lts" : articulos()\precio = 2800
AddElement(articulos()) : articulos()\nombre = "Coca cola 1.5 Lts" : articulos()\precio = 2000
AddElement(articulos()) : articulos()\nombre = "Sprite 2.5 Lts" : articulos()\precio = 2700
AddElement(articulos()) : articulos()\nombre = "Cunnington Cola 2.5 Lts" : articulos()\precio = 1100

Global NewList venta.descripcion()
Global total


Procedure actualizarlista()
  total=0
  ClearGadgetItems(#lista_compra)
  ForEach articulos()
    If articulos()\cantidad>0
      AddGadgetItem(#lista_compra,-1,articulos()\nombre + Chr(10) + Str(articulos()\cantidad) + Chr(10) + Str(articulos()\precio) + Chr(10) + Str(articulos()\precio*articulos()\cantidad))
      total = total + articulos()\precio * articulos()\cantidad
    EndIf 
  Next
  SetGadgetText(#total_container,Str(total))
EndProcedure

Procedure validarInt(entrada$)
  Protected i
  r=#True
  For i=1 To Len(entrada$)
    If Mid(entrada$,i,1)<"0" Or Mid(entrada$,i,1)>"9"
      r=#False 
    EndIf
  Next
  ProcedureReturn r
EndProcedure

Procedure buscarlista(busqueda$)
  If busqueda$=""
    ForEach articulos()
      AddGadgetItem(#lista_busqueda,-1,articulos()\nombre + Chr(10) + articulos()\precio)
    Next
  Else
    ForEach articulos()
      For i=1 To Len(articulos()\nombre)-(Len(busqueda$)-1)
        If UCase(Mid(articulos()\nombre,i,Len(busqueda$)))=UCase(busqueda$)
          Debug "encontrado " + ListIndex(articulos()) 
          AddGadgetItem(#lista_busqueda,-1,articulos()\nombre + Chr(10) + articulos()\precio)
        EndIf 
      Next
    Next
  EndIf
EndProcedure

Procedure anadirarticulos(cant)
  ForEach articulos()
    If articulos()\nombre = GetGadgetText(#lista_busqueda)
      articulos()\cantidad = articulos()\cantidad + cant
    EndIf
    If articulos()\cantidad<0 : articulos()\cantidad = 0: EndIf ;restringe que la cantidad del articulo no sea negativa
  Next
    actualizarlista()
EndProcedure


Procedure ventanaBusqueda(texto$)
  OpenWindow(#ventana_busqueda, 0, 0, 350, 370, "Busqueda", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
  ListIconGadget(#lista_busqueda, 10, 50, 330, 310, "Articulo", 260)
  AddGadgetColumn(#lista_busqueda, 1, "Precio", 60)
  StringGadget(#texto_buscar_ventana, 10, 20, 220, 25, "")
  ButtonGadget(#boton_buscar_ventana, 240, 20, 100, 25, "Buscar")
  CreatePopupImageMenu(#pop_busqueda)
  MenuItem(#menu_busqueda_quitar,"Quitar")
  
  buscarlista(texto$)
  Repeat  
    event=WindowEvent()
    If event = #PB_Event_CloseWindow
      CloseWindow(#ventana_busqueda)
    EndIf 
    
    If event = #PB_Event_Gadget And EventGadget() = #boton_buscar_ventana
      ClearGadgetItems(#lista_busqueda)
      buscarlista(GetGadgetText(#texto_buscar_ventana))
    EndIf 
    
    If event = #PB_Event_Gadget And EventGadget() = #lista_busqueda And EventType() = #PB_EventType_LeftDoubleClick
      anadirarticulos(1)
    EndIf 
    If event = #PB_Event_Gadget And EventGadget() = #lista_busqueda And EventType() = #PB_EventType_RightClick
      DisplayPopupMenu(#pop_busqueda,WindowID(#ventana_busqueda))
      anadirarticulos(-1)
    EndIf
    
  Until event = #PB_Event_CloseWindow
  

  
EndProcedure

Procedure ventanaAgregar()
  
  OpenWindow(#ventana_agregar, 0, 0, 330, 200, "Agregar Articulo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  StringGadget(#descripcion_articuloAgregado, 110, 65, 180, 25, "")
  StringGadget(#precio_articuloAgregado, 110, 95, 180, 25, "")
  TextGadget(#PB_Any, 110, 20, 100, 25, "Agregar Articulo")
  ButtonGadget(#boton_agregar, 110, 160, 100, 25, "Agregar")
  TextGadget(#PB_Any, 20, 70, 100, 25, "Descripcion")
  TextGadget(#PB_Any, 20, 100, 100, 25, "Precio")
 
  
  Repeat  
    event=WindowEvent()
    If event = #PB_Event_CloseWindow
      CloseWindow(#ventana_agregar)
    EndIf 
    
    If event = #PB_Event_Gadget And EventGadget() = #boton_agregar
      AddElement(articulos()) : articulos()\nombre = GetGadgetText(#descripcion_articuloAgregado) : articulos()\precio = Val(GetGadgetText(#precio_articuloAgregado))
      If GetGadgetText(#descripcion_articuloAgregado)="" Or GetGadgetText(#precio_articuloAgregado)="" Or validarInt(GetGadgetText(#precio_articuloAgregado))=#False
        MessageRequester("Error","Ingrese una descripcion y un precio")
      Else
        MessageRequester("Realizado","Articulo agregado",#PB_MessageRequester_Ok)
        SetGadgetText(#precio_articuloAgregado,"")
        SetGadgetText(#descripcion_articuloAgregado,"")        
      EndIf
      
    EndIf 
    
  Until event = #PB_Event_CloseWindow
EndProcedure




;Flags ventana
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered 


OpenWindow(#WindowMain, 0, 0, 470, 520, "Nombre de ventana",#FLAGS)
CreateMenu(#PB_Any,WindowID(#WindowMain))
AddWindowTimer(#WindowMain,#reloj,1000)
MenuTitle("Archivo")
MenuTitle("Articulos")
MenuItem(#menu_articulos,"Agregar articulo")
MenuTitle("Acerca de")
CreateStatusBar(#statusbar, WindowID(#WindowMain))
AddStatusBarField(400)
StatusBarText(#statusbar, 0, "    Fecha: " + FormatDate("%dd/%mm/%yyyy",Date()))
AddStatusBarField(100)
StatusBarText(#statusbar, 1, FormatDate("%hh:%ii:%ss", Date()))
StringGadget(#texto_busqueda, 20, 20, 190, 25, "")
ButtonGadget(#boton_busqueda, 220, 20, 100, 25, "Buscar articulo")
ListIconGadget(#lista_compra, 20, 60, 430, 240, "Articulo", 215)
AddGadgetColumn(#lista_compra, 1, "Cantidad", 70)
AddGadgetColumn(#lista_compra, 2, "Unitario", 70)
AddGadgetColumn(#lista_compra, 3, "Total", 70)
ButtonGadget(#boton_quitar, 20, 310, 100, 25, "Quitar")
ButtonGadget(#boton_cambiar, 130, 310, 100, 25, "Cambiar")
ButtonGadget(#boton_cambiarcantidad, 240, 310, 100, 25, "Cambiar cantidad")
ButtonGadget(#boton_precio, 350, 310, 100, 25, "Cambiar precio")
ContainerGadget(#container, 220, 370, 230, 100)
SetGadgetColor(#container, #PB_Gadget_FrontColor,RGB(255,255,255))
SetGadgetColor(#container, #PB_Gadget_BackColor,RGB(192,192,192))
subtotal_texto = TextGadget(#PB_Any, 10, 40, 100, 25, "Subtotal $")
SetGadgetColor(subtotal_texto, #PB_Gadget_BackColor,RGB(192,192,192))
TextGadget(#texto_articulo, 10, 10, 160, 20, "Articulo", #PB_Text_Center)
SetGadgetColor(#texto_articulo, #PB_Gadget_BackColor,RGB(192,192,192))
TextGadget(#Total_texto, 10, 70, 100, 25, "Total         $")
SetGadgetColor(#Total_texto, #PB_Gadget_FrontColor,RGB(0,0,0))
SetGadgetColor(#Total_texto, #PB_Gadget_BackColor,RGB(192,192,192))
TextGadget(#subtotal_container, 120, 40, 100, 25, "")
SetGadgetColor(#subtotal_container, #PB_Gadget_BackColor,RGB(192,192,192))
TextGadget(#total_container, 110, 70, 100, 25, Str(total))
SetGadgetColor(#total_container, #PB_Gadget_FrontColor,RGB(0,0,0))
SetGadgetColor(#total_container, #PB_Gadget_BackColor,RGB(192,192,192))
CloseGadgetList()
ButtonGadget(#boton_nuevaVenta, 90, 440, 100, 25, "Nueva Venta")

Repeat
    
    event.l= WindowEvent()

    Select Event
      Case #PB_Event_Menu
        Select EventMenu()
          Case #menu_articulos
            ventanaAgregar()
        EndSelect
      Case #PB_Event_Timer 
        If EventTimer() = #reloj
        hora$=FormatDate("%hh:%ii:%ss",Date())
        StatusBarText(#statusbar,1,hora$)
        EndIf
      Case  #PB_Event_Gadget
        Select EventGadget()
          Case #boton_busqueda
            ventanaBusqueda(GetGadgetText(#texto_busqueda))
          Case #boton_nuevaVenta
            CreateFile(#archivo_venta,"Venta.txt")
            WriteStringN(#archivo_venta,"Venta efectuada")
            WriteStringN(#archivo_venta,"_________________")
            ForEach articulos()
              If articulos()\cantidad>0
                WriteStringN(#archivo_venta, articulos()\nombre + ": " + Str(articulos()\cantidad) + "x $" + Str(articulos()\precio) + "   Total: $" + Str(articulos()\precio*articulos()\cantidad))
              EndIf
            Next
            WriteStringN(#archivo_venta,"Valor total: $" + Str(total))
            CloseFile(#archivo_venta)
            ForEach articulos()
              articulos()\cantidad = 0
            Next
            total=0
            actualizarlista()
            MessageRequester("Venta gestionada","Venta realizada exitosamente",#PB_MessageRequester_Ok)
            
          Case #boton_cambiar
            Debug hora$
        EndSelect
    EndSelect
    
  Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 252
; FirstLine = 120
; Folding = B-
; EnableXP