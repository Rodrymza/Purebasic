;programa que analice texto y obtenga:
; - numero total de palabras
; - longitud media de palabras
; - numero de oraciones del texto
; - encontrar la palabra mas larga

Enumeration
  #main_window
  #texto_ingresado
  #boton_analizar
EndEnumeration

Procedure.s formateo_texto(texto.s)
  For i = 1 To Len(texto)
    Select Mid(texto,i,1)
      Case ".", ",", ")", "(", ":", UnescapeString(~"\"")
        Debug "caracter omitido"
      Default
        nuevotexto.s + Mid(texto,i,1)
    EndSelect
    
  Next
  
    ProcedureReturn nuevotexto
EndProcedure

Procedure analizar_texto(texto.s)
  oraciones = 0
  For i = 1 To Len(texto)
    If Mid(texto,i,1) = "."
      oraciones + 1
    EndIf 
  Next
  
  Debug "numero de oraciones: " + Str(oraciones)
  Debug formateo_texto(texto)
EndProcedure

OpenWindow(#PB_Any, 0, 0, 590, 410, "Analizador de texto", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
EditorGadget(#texto_ingresado, 30, 40, 530, 310, #PB_Editor_WordWrap)
ButtonGadget(#boton_analizar, 200, 370, 200, 25, "Analizar")
TextGadget(#PB_Any, 110, 10, 370, 25, "Ingrese un texto para analizarlo", #PB_Text_Center)

Repeat
  event = WindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_analizar
          analizar_texto(GetGadgetText(#texto_ingresado))
      EndSelect
  EndSelect
  
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; Folding = -
; EnableXP
; HideErrorLog