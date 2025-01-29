;Juego simple de adivinar un numero
;contiene validacion ingreso de numero entero
;contiene validacion para no ingresar un numero mas de una vez
;tanto al cambiar el numero maximo a adivinr como los intentos se hace una comprobacion de datos
;__________________________________________________________
;Rodry Ramirez (c) 2024
;rodrymza@gmail.com
;version 1.0

Enumeration
  #ventana_principal
  #mensajes
  #numero
  #aceptar
  #cambiar_intentos
  #cambiar_maximo
  #menu
  #nuevo_juego
  #intro
EndEnumeration

Global maximo, numero_adivinar, intentos
Global NewList ingresados()

Procedure validarInt(entrada$) ; validacion entero
  Protected i
  r=#True
  For i=1 To Len(entrada$)
    If Mid(entrada$,i,1)<"0" Or Mid(entrada$,i,1)>"9"
      r=#False 
    EndIf
  Next
  ProcedureReturn r
EndProcedure

Procedure actualizarMensaje() ;actualizar mensaje al cambiar maximo numero a adivinar y el numero maximo de intentos
  SetGadgetText(#mensajes,"Bienvenido!" + Chr(10) + "Intenta adivinar el numero en que estoy pensando" + Chr(10) + "(entre 0 y " + Str(maximo) + ")" + Chr(10) + "Intentos: " + Str(intentos))
EndProcedure

Procedure comprobarNumero(numero.i) ;comprobacion de numero adivinado y actualizacion de intentos, aviso de si el numero es mayor o menor
  If numero<numero_adivinar
    intentos=intentos-1
    SetGadgetText(#mensajes,"El numero es mayor, te quedan " + Str(intentos) + " intentos")
  ElseIf  numero>numero_adivinar
    intentos=intentos-1
    SetGadgetText(#mensajes,"El numero es menor, te quedan " + Str(intentos) + " intentos")
  Else
    intentos=0
  EndIf
EndProcedure

Procedure ver_repetido(numero) ; verificar si el numero ya fue ingresado
  repetido=#False
  ForEach ingresados()
    If numero=ingresados() : cont=cont+1 : EndIf
  Next
  If cont>1 : repetido=#True : MessageRequester("Atencion","Ya ingresaste el numero!") : EndIf  
  ProcedureReturn repetido
EndProcedure

Procedure aceptar() ; proceso ingresar el numero, tanto al presionar el boton como al apretar la tecla intro
  If intentos>1
            DisableMenuItem(#menu,#cambiar_intentos,1)
            DisableMenuItem(#menu,#cambiar_maximo,1)
            If validarInt(GetGadgetText(#numero))
              numero_usuario=Val(GetGadgetText(#numero))
              AddElement(ingresados())
              ingresados()=numero_usuario
              If Not ver_repetido(numero_usuario)
                comprobarNumero(numero_usuario)
              EndIf 
            Else
              MessageRequester("Error","Ingresa un numero valido",#PB_MessageRequester_Error)
            EndIf
          Else
            If numero_usuario<>numero_adivinar
              SetGadgetText(#mensajes,"Perdiste! Te quedaste sin intentos")
            Else
              SetGadgetText(#mensajes,"Adivinaste!!! :D")
            EndIf
            DisableGadget(#aceptar,1)
            DisableGadget(#numero,1)
          EndIf 
EndProcedure

maximo=100
numero_adivinar=Random(maximo)
Debug numero_adivinar
intentos=10
num_usuario=-1

OpenWindow(#ventana_principal,0,0,380,180,"Adivina el numero", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CreateMenu(#menu, WindowID(#ventana_principal))
MenuTitle("Configuracion")
MenuItem(#cambiar_intentos, "Intentos totales")
MenuItem(#cambiar_maximo, "Numero maximo")
MenuItem(#nuevo_juego,"Nuevo Juego")
TextGadget(#mensajes, 30, 10, 320, 60,"Bienvenido!" + Chr(10) + "Intenta adivinar el numero en que estoy pensando" + Chr(10) + "(entre 0 y " + Str(maximo) + ")" + Chr(10) + "Intentos: " + Str(intentos) , #PB_Text_Center)
StringGadget(#numero, 80, 80, 230, 25, "")
ButtonGadget(#aceptar, 140, 120, 100, 25, "Intentar")
AddKeyboardShortcut(#ventana_principal,#PB_Shortcut_Return,#intro)


Repeat
  event = WindowEvent()
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #aceptar
          aceptar()
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #cambiar_intentos
          
          Repeat  
            Repeat  
              aux.s=InputRequester("Cambiar Intentos","Ingrese el nuevo valor maximo de intentos","")
              If Not validarInt(aux) : MessageRequester("Error","Ingrese un valor valido",#PB_MessageRequester_Error) : EndIf  
            Until validarInt(aux)
            intentos=Val(aux)
            If intentos<1 : MessageRequester("Error","Ingrese un numero mayor o igual a 1") : EndIf 
          Until intentos>0
          actualizarMensaje()
          numero_adivinar=Random(maximo)
        Case #cambiar_maximo
          Repeat  
            Repeat  
              aux.s=InputRequester("Cambiar maximo","Ingrese el nuevo valor maximo","")
              If Not validarInt(aux) : MessageRequester("Error","Ingrese un valor valido",#PB_MessageRequester_Error) : EndIf  
            Until validarInt(aux)
            maximo=Val(aux)
            numero_adivinar=Random(maximo)
            If maximo<10 : MessageRequester("Error","Ingrese un numero mayor o igual a 10") : EndIf 
          Until maximo>9
          actualizarMensaje()
          Debug numero_adivinar
        Case #nuevo_juego
          MessageRequester("Nuevo juego","Volvamos a empezar! Valores reiniciados(Maximo=100, Intentos=10)",#PB_MessageRequester_Info)
          maximo=100
          intentos=10
          numero_adivinar=Random(maximo)
          DisableMenuItem(#menu,#cambiar_intentos,0)
          DisableMenuItem(#menu,#cambiar_maximo,0)          
          DisableGadget(#numero,0)
          DisableGadget(#aceptar,0)
          SetGadgetText(#numero,"")
          actualizarMensaje()
        Case #intro
          aceptar()
      EndSelect
  EndSelect 
Until event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 138
; FirstLine = 101
; Folding = +
; EnableXP
; DPIAware