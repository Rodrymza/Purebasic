Enumeration
  #ventana_principal
  #combo_numeros
  #numero_personalizado
  #lista_multiplicar
  #boton_borrar
  #Obtener 
EndEnumeration

Procedure llenarlista(numero.s)
  ClearGadgetItems(#lista_multiplicar)
  For i=1 To 10
    AddGadgetItem(#lista_multiplicar,-1,StrF(i) + " x " + numero + " = " + StrF(i*ValF(numero),2))
  Next
EndProcedure

Procedure ValidarFloat(entrada$)
  Protected i,j
  r=#True
  i=1
  validos$=".1234567890"
  For i=1 To Len(entrada$)
    For j=1 To Len(validos$)
      If Mid(entrada$,i,1)=Mid(validos$,j,1)
        cont=cont+1
      EndIf 
    Next
    If Mid(entrada$,i,1)="."
      coma=coma+1
    EndIf 
  Next
  If cont<>Len(entrada$) Or coma>1
    r=#False
  EndIf
  ProcedureReturn r
EndProcedure


OpenWindow(#ventana_principal,0,0,380,340,"Tabla de multiplicar", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

TextGadget(#PB_Any, 30, 20, 190, 25, "Seleccione la tabla que desea ver")
ComboBoxGadget(#combo_numeros, 220, 15, 100, 25)
TextGadget(#PB_Any, 30, 50, 130, 25, "Numero personalizado:")
StringGadget(#numero_personalizado, 170, 50, 100, 25, "")
ListViewGadget(#lista_multiplicar, 50, 90, 280, 180)
ButtonGadget(#boton_borrar, 140, 290, 100, 25, "Borrar lista")
ButtonGadget(#Obtener, 280, 50, 70, 25, "Obtener")


For i=1 To 10
  AddGadgetItem(#combo_numeros,-1,Str(i))
Next
SetGadgetState(#combo_numeros,0)

Repeat
  event = WindowEvent()
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #combo_numeros
          llenarlista(GetGadgetText(#combo_numeros))
        Case #Obtener
          If ValidarFloat(GetGadgetText(#numero_personalizado))
            llenarlista(GetGadgetText(#numero_personalizado))
          Else
            MessageRequester("Error","Ingresaste un valor incorrecto",#PB_MessageRequester_Error)
          EndIf 
        Case #boton_borrar
          ClearGadgetItems(#lista_multiplicar)
      EndSelect
  EndSelect
Until event= #PB_Event_CloseWindow



; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 22
; FirstLine = 9
; Folding = -
; EnableXP
; DPIAware