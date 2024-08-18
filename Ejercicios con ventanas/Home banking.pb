

Enumeration
  #ventanainicio
  #usuario
  #contrasenia
  #usuariotext
  #contraseniatext
  #botoningreso
  #ventanahome
  #titulohome
  #menusaldo
  #menutransferencias
  #menudepositos
  
EndEnumeration

Enumeration FormFont
  #Consolas12
  #Consolas14
  #Consolas16
EndEnumeration

LoadFont(#Consolas12,"Consolas", 12)
LoadFont(#Consolas14,"Consolas", 14)
LoadFont(#Consolas16,"Consolas", 16)

user$="rodrymza"
pass$="roro1991"

Procedure Ingresohome(usuario$)
  
  MessageRequester(usuario$,"Acceso exitoso") 
  CloseWindow(#ventanainicio)
  
  #FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget  
  
  If OpenWindow(#ventanahome, 0, 0, 510, 540, "Ingreso al sistema de Homebanking",#FLAGS)
    
    ;Menus
    CreateMenu(0, WindowID(#ventanahome))
    MenuTitle("Sistema")
     MenuItem(#menusaldo, "Consulta Saldo")
    MenuItem(#menutransferencias, "Transferencias")
    MenuItem(#menudepositos, "Deposito")
    
    ;Gadgets
    TextGadget(#titulohome, 30, 20, 260, 35, "Bienvenido " + usuario$)
    SetGadgetFont(#titulohome, FontID(#Consolas16))
    
    Repeat 
    Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
    Select Event
      Case #PB_Event_Gadget
        Select EventGadget()
    
    
            
            
        EndSelect
      EndSelect
    Until  Event= #PB_Event_CloseWindow     
            
  EndIf 
  
EndProcedure


#FLAGSp =  #PB_Window_ScreenCentered

If OpenWindow(#ventanainicio, 0, 0, 460, 270, "Ingreso al sistema de Homebanking",#FLAGSp)
  
  ;Gadgets
  TextGadget(#PB_Any, 80, 30, 260, 35, "Ingrese usuario y contraseña")
  TextGadget(#usuario, 40, 90, 130, 40, "Usuario")
  SetGadgetFont(#usuario, FontID(#Consolas12))
  TextGadget(#contrasenia, 40, 140, 130, 40, "Contraseña")
  SetGadgetFont(#contrasenia, FontID(#Consolas12))
  StringGadget(#usuariotext, 190, 90, 210, 40, "rodrymza")
  SetGadgetFont(#usuariotext, FontID(#Consolas14))
   StringGadget(#contraseniatext, 190, 140, 210, 40, "roro1991")
  SetGadgetFont(#contraseniatext, FontID(#Consolas14))
  ButtonGadget(#botoningreso, 220, 220, 150, 35, "Ingresar")
  
  Repeat 
    Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
    Select Event
        
        Case #PB_Event_Menu
          Select EventMenu()
              
              
          EndSelect
          
        Case #PB_Event_Gadget
          
        Select EventGadget()
          Case #botoningreso
            
            usuario$=GetGadgetText(#usuariotext)
            contrasenia$=GetGadgetText(#contraseniatext)

            If usuario$=user$ And contrasenia$=pass$
              
              Ingresohome(usuario$)
            Else
              cont=cont+1
              MessageRequester("Las credenciales son incorrectas", "Error, te quedan " + Str(3-cont) + " intentos")
              
              If cont=3
                MessageRequester("Bloqueo", "Error, cuenta bloqueada")
              EndIf
              
            EndIf
            
            
            
            
          EndSelect
  
      EndSelect
  Until  Event= #PB_Event_CloseWindow Or cont=3
  
EndIf

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 32
; FirstLine = 90
; Folding = -
; EnableXP