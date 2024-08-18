Enumeration
  #ventana_principal
  #aceptar
  #tecla_intro
  #string
EndEnumeration

  OpenWindow(#ventana_principal, 0, 0, 420, 170, "Atajo del tecado", #PB_Window_SystemMenu)
  ButtonGadget(#aceptar, 120, 110, 160, 25, "Aceptar")
  StringGadget(#string, 80, 70, 240, 25, "")
  TextGadget(#PB_Any, 20, 30, 370, 25, "Para aceptar haz click en el boton o presiona la tecla intro", #PB_Text_Center)
  AddKeyboardShortcut(#ventana_principal,#PB_Shortcut_Return,#tecla_intro)
  ;Para agregar un atajo del teclado debe introducirse primero la ventana donde se captara la tecla presionada, la tecla que sera el atajo y por ultimo la clave
  ;numerica para detectarla a traves del select del EventMenu()
  ;La combinacion de teclas se hace con el simbolo | 


Repeat 
  Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
  Select Event
      
    Case #PB_Event_Menu
      Select EventMenu()
        Case #tecla_intro
          If GetActiveGadget()=#string ;aqui hacemos que el atajo solo responda cuando estemos en la caja de texto
            MessageRequester("Captado con tecla intro", "Presionaste la tecla intro, el texto es: '" +GetGadgetText(#string) + "'")
          EndIf 
          
      EndSelect
    Case  #PB_Event_Gadget
      Select EventGadget()
        Case #aceptar
          MessageRequester("Captado con boton aceptar" , "Presionaste boton aceptar, el texto es: '" +GetGadgetText(#string) + "'")
          
      EndSelect
  EndSelect
Until Event= #PB_Event_CloseWindow
; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 14
; EnableXP