Enumeration
  
  #VentanaPrincipal
  #lista
  #apellido
  #nombre
  #dni
  #botonguardar
  #buscardni
  #botonbusqueda
  
EndEnumeration

;Fuentes
Enumeration FormFont
  #Calibri16
  #Calibri18
EndEnumeration

;Carga de fuentes necesarias
LoadFont(#Calibri16,"Calibri Light", 16)
LoadFont(#Calibri18,"Calibri Light", 18)

;Variables
Global Dim nombre$(50), Dim apellido$(50), Dim dni$(50)
Global posicion.l=0

;Funciones
Procedure$ title(palabra$)  ;Formatea el texto a primera letra mayuscula
  
  i.l=2
  r$=UCase(Mid(palabra$,1,1))
  While i<= Len(palabra$)
    If Mid(palabra$,i,1)=" "
      r$=r$+ UCase(Mid(palabra$,i,2))
      i=i+2
    Else
      r$=r$+LCase(Mid(palabra$,i,1))
      i=i+1
    EndIf
  Wend
  ProcedureReturn r$
EndProcedure

Procedure agregarpersonas()
  For i=0 To 15
    apellido$(i) = "Apellido " + Str(i)
    nombre$(i) = "Nombre " + Str(i)
    dni$(i) = Str(1024*i)
    AddGadgetItem(#lista,i, apellido$(i) + Chr(10) + nombre$(i) + Chr(10) + dni$(i))
  Next
  EndProcedure
  
  ;Flags ventana
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget


OpenWindow(#VentanaPrincipal, 0, 0, 600, 430, "Nombre de ventana",#FLAGS)

;Elementos de ventana (Gadgets y menus)
  ListIconGadget(#lista, 70, 90, 420, 220, "Apellido", 150)
  AddGadgetColumn(#lista,1,"Nombre", 150)
  AddGadgetColumn(#lista,2,"DNI", 80)
  ButtonGadget(#botonguardar, 200, 330, 180, 25, "Guardar")
  StringGadget(#apellido, 40, 50, 150, 25, "")
  StringGadget(#nombre, 210, 50, 150, 25, "")
  StringGadget(#dni, 380, 50, 150, 25, "")
  TextGadget(#PB_Any, 40, 20, 150, 25, "Apellido", #PB_Text_Center)
  TextGadget(#PB_Any, 210, 20, 150, 25, "Nombre", #PB_Text_Center)
  TextGadget(#PB_Any, 380, 20, 150, 25, "DNI", #PB_Text_Center)
  ButtonGadget(#botonbusqueda, 80, 380, 160, 30, "Buscar por DNI", #PB_Text_Center)
  StringGadget(#buscardni, 240, 380, 190, 30, "")
  
  ;agregarpersonas()
  Debug "i queda en esa posicion "

Repeat 
  Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
  Select Event
      
    Case #PB_Event_Menu
      Select EventMenu()
          
          
      EndSelect
    Case  #PB_Event_Gadget
      Select EventGadget()
        Case #botonguardar
          nombre$(posicion)=title(GetGadgetText(#nombre))
          apellido$(posicion)=title(GetGadgetText(#apellido))
          dni$(posicion)=GetGadgetText(#dni)
          AddGadgetItem(#lista,posicion, apellido$(posicion) + Chr(10) + nombre$(posicion) + Chr(10) + dni$(posicion))
          Debug "posicion de guardado" + posicion
          SetGadgetItemData(#lista,i,Val(GetGadgetText(#dni)))
          SetGadgetText(#nombre,"")
          SetGadgetText(#apellido,"")
          SetGadgetText(#dni,"")
          posicion=posicion+1
          For i=0 To ArraySize(apellido$())
            Debug ArraySize(apellido$())
            Debug apellido$(i) + nombre$(i) + dni$(i)
          Next
          
        Case #botonbusqueda
          ClearGadgetItems(#lista)
          busqueda$=title(GetGadgetText(#buscardni))
          Debug "valor a buscar " + busqueda$
          For a=0 To ArraySize(nombre$())
            Debug apellido$(a)
            If busqueda$=apellido$(a)
              AddGadgetItem(#lista,-1, apellido$(a) + Chr(10) + nombre$(a) + Chr(10) + dni$(a))

            EndIf 
          Next
           
          
      EndSelect
  EndSelect
Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 118
; FirstLine = 85
; Folding = -
; EnableXP