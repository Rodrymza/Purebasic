Enumeration
  #ventana_principal
  #numero
  #lista_numeros
  #boton_aceptar
  #barra_progreso
EndEnumeration

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

OpenWindow(#ventana_principal,0,0,200,470,"Fizz Buzz", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)

TextGadget(#PB_Any, 20, 20, 160, 25, "¿Hasta que numero contar?")
  StringGadget(#numero, 40, 57, 120, 25, "12")
  ListViewGadget(#lista_numeros, 20, 120, 160, 310)
  ButtonGadget(#boton_aceptar, 50, 90, 100, 25, "Aceptar")
  ProgressBarGadget(#barra_progreso, 20, 440, 160, 25, 0, 100)
  
  Repeat
    event = WindowEvent()
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_aceptar
            If validarInt(GetGadgetText(#numero))
              ClearGadgetItems(#lista_numeros)
              num=Val(GetGadgetText(#numero))
              For i=1 To num
                Delay(75)
                If i%3=0
                  If i%5=0
                    AddGadgetItem(#lista_numeros,-1,"Fizz Buzz")
                  Else
                    AddGadgetItem(#lista_numeros,-1,"Fizz")                 
                  EndIf 
                Else
                  AddGadgetItem(#lista_numeros,-1,Str(i))
                EndIf
                progresobarra=i*100/num
                SetGadgetState(#barra_progreso,progresobarra)
                WindowEvent()
              Next  
            Else
              MessageRequester("Error","Ingresaste un valor incorrecto",#PB_MessageRequester_Error)
            EndIf 
        EndSelect
    EndSelect
  Until event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 37
; Folding = -
; EnableXP
; DPIAware