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

Procedure.s eliminar_caracteres(texto.s)
  abecedario.s = ".abcdefghijklmnñopqrstuvwxyzáéíúóúü?! "
  nuevapalabra.s = ""
  i=1
  For i=1 To Len(texto)
    For j=1 To Len(abecedario)
      If Mid(abecedario,j,1) = LCase(Mid(texto,i,1))
        nuevapalabra + Mid(texto,i,1)
      EndIf
    Next
  Next
  texto = nuevapalabra
  nuevapalabra = ""
  For i=1 To Len(texto)
    If Mid(texto,i,1) = " "
      nuevapalabra + " "
      While Mid(texto ,i+1,1) = " " And i+1 < Len(texto)
        i + 1
      Wend
    ElseIf Mid(texto, i, 1) = "?" Or Mid(texto,i,1) = "!"
      nuevapalabra + "."
    Else
      nuevapalabra + Mid(texto,i,1)
    EndIf 
  Next 
 Debug nuevapalabra
    ProcedureReturn nuevapalabra
EndProcedure

Procedure analizar_texto(texto.s)
  If Len(texto)>0
    texto + " "
  EndIf
  
  palabra_mayor = 0
  letras = 0
  palabras = 0
  oraciones = 0
  total_letras = 0
  letras_espacios = 0
  For i = 1 To Len(texto)
    Select  Mid(texto,i,1)
      Case " "
        palabras + 1
        If Mid(texto, i-1, 1) = "."
          auxiliar = -1
        Else 
          auxiliar = 0
        EndIf 
        
          Debug palabras
          Debug "palabra " + Mid(texto,i-letras + auxiliar ,letras) + " "  + Str(letras) + " letras"
          letras_espacios + letras
          If letras>palabra_mayor
            palabra_mayor = letras
            palabra_mas_larga.s = Mid(texto,i-letras + auxiliar, letras)
          EndIf
          
          letras = 0
        
      Case "."
        oraciones + 1
        
      Case ",", ";", ":"
          
        Default
          letras + 1
          total_letras +1
          
  EndSelect
Next

  If Mid(texto,Len(texto),1)<>"."
    oraciones +1
  EndIf
  promedio_palabras = total_letras / palabras
  Debug "Cantidad de oraciones " + Str(oraciones) + " total letras en case " + Str(letras_espacios)
  Debug "Cantidad de palabras " + Str(palabras) + " total letras en default " + Str(total_letras)
  Debug "Largo promedio de palabras " + Str(promedio_palabras)
  Debug "La palabra mas larga contiene " + Str(palabra_mayor) + " letras y es la palabra " + palabra_mas_larga
  
EndProcedure

OpenWindow(#PB_Any, 0, 0, 590, 410, "Analizador de texto", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
EditorGadget(#texto_ingresado, 30, 40, 530, 310, #PB_Editor_WordWrap)
ButtonGadget(#boton_analizar, 200, 370, 200, 25, "Analizar")
TextGadget(#PB_Any, 110, 10, 370, 25, "Ingrese un texto para analizarlo", #PB_Text_Center)
SetActiveGadget(#texto_ingresado)
Repeat
  event = WindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_analizar
          analizar_texto(eliminar_caracteres(GetGadgetText(#texto_ingresado)))
      EndSelect
  EndSelect
  
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 45
; FirstLine = 54
; Folding = -
; EnableXP
; HideErrorLog