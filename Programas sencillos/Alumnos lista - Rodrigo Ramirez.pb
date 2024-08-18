;Lista simple de alumnos
;La lista se puede ordenar tanto alfabeticamente como por edad
;contiene filtro para colocar solo alumnos mayores y menores
;__________________________________________________________
;Rodry Ramirez (c) 2024
;rodrymza@gmail.com
;version 1.0
Enumeration
  #ventana_principal
  #nombre
  #edad
  #filtro
  #lista
  #boton_guardar
  #menupop
  #quitar
  #boton_ordenar
  #boton_ordenarEdad
  #intro
EndEnumeration

Structure datos
  nombre.s
  edad.l
EndStructure

Global NewList alumnos.datos()

Procedure actualizarlista(numero.i) ;proceso para actualizar la listIcon, el parametro numero se utiliza para el fintro de mayor de edad
 
  ClearGadgetItems(#lista)
  ForEach alumnos()
    Select numero
      Case 0
        AddGadgetItem(#lista,-1,alumnos()\nombre + Chr(10) + Str(alumnos()\edad))
      Case 1
       If alumnos()\edad>=18 : AddGadgetItem(#lista,-1,alumnos()\nombre + Chr(10) + Str(alumnos()\edad)) : EndIf  
     Case 2
       If alumnos()\edad<18 : AddGadgetItem(#lista,-1,alumnos()\nombre + Chr(10) + Str(alumnos()\edad)) : EndIf   
   EndSelect
  Next
EndProcedure

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

Procedure validarInt(entrada$) ; valida que el string ingresado sea solo de numeros
  Protected i
  r=#True
  For i=1 To Len(entrada$)
    If Mid(entrada$,i,1)<"0" Or Mid(entrada$,i,1)>"9"
      r=#False 
    EndIf
  Next
  ProcedureReturn r
EndProcedure

Procedure guardar() ;proceso para guardar el nuevo alumno, se utiliza tanto al presionar el boton guardar como cuando se presiona la tecla intro 
  If GetGadgetText(#nombre)<>"" And GetGadgetText(#edad)<>""    ;se verifica que los valores ingresados sean correctos a traves de las funciones creadas anteriormente
    If validarInt(GetGadgetText(#edad))
      AddElement(alumnos())
      alumnos()\nombre = title(GetGadgetText(#nombre))
      alumnos()\edad = Val(GetGadgetText(#edad))
      actualizarlista(0)
      SetGadgetText(#nombre,"") : SetGadgetText(#edad,"")
      SetActiveGadget(#nombre) ; setear la stringgadget nombre como activa
    Else
      MessageRequester("Error","Edad incorrecta",#PB_MessageRequester_Error)
    EndIf
  Else
    MessageRequester("Error","Falta completar campos",#PB_MessageRequester_Error)
  EndIf 
EndProcedure

OpenWindow(#ventana_principal,0,0,290,440,"Ficha de estudiantes",#PB_Window_SystemMenu | #PB_Window_ScreenCentered)

  TextGadget(#PB_Any, 10, 20, 120, 20, "Nombre y Apellido: ", #PB_Text_Right)
  TextGadget(#PB_Any, 30, 50, 100, 20, "Edad: ", #PB_Text_Right)
  StringGadget(#nombre, 130, 15, 100, 25, "")
  StringGadget(#edad, 130, 45, 100, 25, "")
  ButtonGadget(#boton_guardar, 130, 80, 100, 25, "Guardar")
  ComboBoxGadget(#filtro, 50, 110, 170, 25)
  ListIconGadget(#lista, 20, 140, 250, 250, "Apellido y Nombre", 170)
  AddGadgetColumn(#lista, 1, "Edad", 50)
  CreatePopupMenu(#menupop)
  MenuItem(#quitar,"Eliminar")
  ButtonGadget(#boton_ordenar, 10, 410, 130, 25, "Ordenar por nombre")
  ButtonGadget(#boton_ordenarEdad, 150, 410, 130, 25, "Ordenar por edad")
  AddGadgetItem(#filtro,-1,"Limpiar filtro")
  AddGadgetItem(#filtro,-1,"Solo alumnos mayores")
  AddGadgetItem(#filtro,-1,"Solo alumnos menores")
  SetGadgetState(#filtro,0)
  AddKeyboardShortcut(#ventana_principal,#PB_Shortcut_Return,#intro)
  
  Repeat
    event=WindowEvent()
    
    Select event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_guardar
          guardar()
          Case #filtro
            ClearGadgetItems(#lista)
            actualizarlista(GetGadgetState(#filtro))
          Case #lista
            If EventType()=#PB_EventType_RightClick And GetGadgetState(#filtro)=1
            EndIf
          Case #boton_ordenar
            SortStructuredList(alumnos(),#PB_Sort_Ascending,OffsetOf(datos\nombre.s),TypeOf(datos\nombre.s))
            actualizarlista(0)
            Case #boton_ordenarEdad
            SortStructuredList(alumnos(),#PB_Sort_Ascending,OffsetOf(datos\edad.l),TypeOf(datos\edad))
            actualizarlista(0)
        EndSelect
          Case #PB_Event_Menu
            Select EventMenu()
              Case #quitar
                SelectElement(alumnos(),GetGadgetState(#lista))
                MessageRequester("Borrado exitoso","Eliminaste el alumno " + alumnos()\nombre)
                DeleteElement(alumnos())
                ClearGadgetItems(#lista)
                actualizarlista(0)
              Case #intro 
                If GetActiveGadget()=#nombre Or GetActiveGadget()=#edad 
                  guardar()
                EndIf 
            EndSelect
        EndSelect
  Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 6
; Folding = 6
; EnableXP
; DPIAware