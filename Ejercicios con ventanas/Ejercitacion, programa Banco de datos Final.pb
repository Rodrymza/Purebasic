;Banco de datos, fichero simple que guarde nombrea, apellido y dni (ficha)
;ventana debe tener
;menu con ingreso de datos, consulta
;3 campos para guardar
;boton avanzar y retroceder
;boton de grabacion
;---------------------------------------------
;Progrma fichero simple
;(c) Rodry Ramirez
; rodrymza@gmail.com
Enumeration
  #Principal
  #Nombre
  #Nombretext
  #Apellido
  #Apellidotext
  #DNI
  #DNItext
  #Ficha
  #BotonAnterior
  #BotonGuardar
  #BotonPosterior
  #MenuIngreso
  #MenuConsulta
  #MenuModificacion
  #Titulo
  #Archivo
  #Contrasenia
  #Botoncontrasenia
  #Ventanacontrasenia
  #ModificarArchivo
EndEnumeration

Enumeration FormFont
  #Calibri16
  #Calibri18
EndEnumeration

;Carga de fuentes necesarias
LoadFont(#Calibri16,"Calibri Light", 16)
LoadFont(#Calibri18,"Calibri Light", 18)

;Definicion de variables

Global posicion.l, Dim listaNombre$(20), Dim listaDni$(20), Dim listaApellido$(20), nombrefichero$

posicion.l
texto$ = ""
pass$="1234" ;contraseña para modificacion de datos
nombrefichero$="Fichero Simple.txt"

Procedure Asignardatos()    ;Funcion para leer los datos y asignarlos a los vetores de apellido, nombre y dni
  ;se usa la funcion stringfield que separa las cadenas de texto con un delimitador especifico, en este caso con las comas ","
  n.l=0
  If ReadFile(#Archivo,nombrefichero$)
    While Eof(#Archivo)=0
      text$=ReadString(#Archivo)
      listaApellido$(n)=StringField(text$,1,",")  ;Se le asigna a cada vector el valor leido en cada posicion delimitada por las comas
      listaNombre$(n)=StringField(text$,2,",")
      listaDni$(n)=StringField(text$,3,",")
      n=n+1
      
    Wend
    
  EndIf   
EndProcedure
 
Procedure.s login() ;login para colocar contraseña para entrar al menu de modificacion (no se guardan las modificaciones en el archivo txt)
pass$="1234"
salir=#False
#Propiedades = #PB_Window_SystemMenu | #PB_Window_ScreenCentered 


OpenWindow(#Ventanacontrasenia, 0, 0, 470, 140, "Login Gerencia", #Propiedades)
  
  ;Elementos de ventana (Gadgets y menus)
  TextGadget(#Ventanacontrasenia, 120, 30, 200, 30, "Ingrese contraseña de gerencia", #PB_Text_Center)
  StringGadget(#Contrasenia, 140, 60, 180, 25, "")
  ButtonGadget(#Botoncontrasenia, 180, 100, 100, 25, "Ingresar", #PB_Button_MultiLine)
  
  Repeat 
    Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
    Select Event
        
      Case  #PB_Event_Gadget
        Select EventGadget()
          Case #botoncontrasenia
            contrasenia$=GetGadgetText(#Contrasenia)
            If contrasenia$=pass$
              MessageRequester("Accedido","Acceso concedido", #PB_MessageRequester_Info)
              salir=#True
              CloseWindow(#Ventanacontrasenia)
            Else
             
              MessageRequester("Error","Contraseña incorrecta", #PB_MessageRequester_Error )
              CloseWindow(#Ventanacontrasenia)
            EndIf 

        EndSelect
        
    EndSelect

  Until Event= #PB_Event_CloseWindow Or salir=#True
  ProcedureReturn contrasenia$
EndProcedure

Procedure actualizarvalores() ;Procedimiento para actualizar los datos en pantalla con la nueva posicion, usado al guardar los datos y al usar los botones anterior y posterior
  SetGadgetText(#Ficha, "N° Ficha: " + Str(posicion+1))
  SetGadgetText(#Apellidotext, listaApellido$(posicion))
  SetGadgetText(#Nombretext, listaNombre$(posicion))
  SetGadgetText(#DNItext, listaDni$(posicion))
  
EndProcedure

Procedure valorposicion(posicion)
  
  posicioninicial.l=0
  If ReadFile(#Archivo, nombrefichero$) 
    While Eof(#Archivo) = 0
      text$=ReadString(#Archivo)
      ;listaApellido$(posicioninicial)=text$
      ;Debug text$
      posicioninicial=posicioninicial+1
     
      
    Wend
    CloseFile(#Archivo)
    MessageRequester("Atencion","Se encontro un archivo de Fichas guardado",#PB_MessageRequester_Info) ;Mensaje al encontrar archivo de fichas
 
  EndIf
  ProcedureReturn posicioninicial
EndProcedure

Procedure encontrar_espacio(linea)
  
EndProcedure  


;Propiedades de la ventana principal
#FLAGS = #PB_Window_SystemMenu | #PB_Window_ScreenCentered | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_SizeGadget

If OpenWindow(#Principal, 0, 0, 650, 340, "Banco de Datos: Fichero Simple",#FLAGS)
  
  posicion=valorposicion(posicion)
  posini=posicion
  
  Asignardatos()
  
  CreateMenu(0, WindowID(#Principal))
  MenuTitle("Sistema")                    ;Barras de menu
  MenuItem(#MenuIngreso, "Ingreso")
  MenuItem(#MenuConsulta, "Consulta")
  MenuItem(#MenuModificacion, "Modificar")
  
  
  TextGadget(#Apellido, 40, 70, 100, 25, "Apellido")
  SetGadgetFont(#Apellido, FontID(#Calibri16))
  TextGadget(#Nombre, 40, 120, 100, 25, "Nombre")
  SetGadgetFont(#Nombre, FontID(#Calibri16))
  TextGadget(#DNI, 40, 170, 100, 25, "DNI")
  SetGadgetFont(#DNI, FontID(#Calibri16))
  TextGadget(#Ficha, 490, 20, 130, 40, "N° Ficha: " + Str(posicion+1))     ;Cuadros de texto
  SetGadgetFont(#Ficha, FontID(#Calibri18))
  StringGadget(#Apellidotext, 150, 70, 200, 30, listaApellido$(posicion))
  SetGadgetFont(#Apellidotext, FontID(#Calibri18))
  StringGadget(#Nombretext, 150, 120, 200, 30, listaNombre$(posicion))
  SetGadgetFont(#Nombretext, FontID(#Calibri18))
  StringGadget(#DNItext, 150, 170, 200, 30, listaDni$(posicion))
  SetGadgetFont(#DNItext, FontID(#Calibri18))
  TextGadget(#Titulo, 0, 10, 650, 35, "Sistema de Ingreso", #PB_Text_Center)
  SetGadgetFont(#Titulo, FontID(#Calibri18))
  
  ButtonGadget(#BotonAnterior, 210, 260, 120, 35, "<- Anterior")
  DisableGadget(#BotonAnterior,1)
  ButtonGadget(#BotonGuardar, 360, 260, 120, 35, "Grabar")        ;Botones
  ButtonGadget(#BotonPosterior, 510, 260, 120, 35, "Posterior ->")
  DisableGadget(#BotonPosterior,1)
  ButtonGadget(#ModificarArchivo, 420, 180, 140, 40, "Modificar archivo")
  HideGadget(#ModificarArchivo,1)
  
  
  Repeat 
    Event.l= WindowEvent()    ;esta linea capta los eventos que pasan en la ventana
    Select Event
        
        Case #PB_Event_Menu
        Select EventMenu()
          Case #MenuConsulta
            ;MessageRequester("Consulta", "Consulta de ficha")
              DisableGadget(#BotonAnterior,0)
              DisableGadget(#BotonPosterior,0)
              DisableGadget(#BotonGuardar,1)
              DisableGadget(#Apellidotext,1)
              DisableGadget(#Nombretext,1)
              DisableGadget(#DNItext,1)
              SetGadgetText(#Titulo,"Sistema de Consultas")
              SetGadgetText(#Ficha, "N° Ficha: " + Str(posicion+1))
              HideGadget(#ModificarArchivo,1)

               
            Case  #MenuIngreso
              ;MessageRequester("Ingreso", "Ingreso de nueva ficha")
              DisableGadget(#BotonAnterior,1)
              DisableGadget(#BotonPosterior,1)
              DisableGadget(#BotonGuardar,0)
              SetGadgetText(#Titulo,"Sistema de Ingreso")
              SetGadgetText(#Ficha, "N° Ficha: " + Str(posicion+1))
              apellido$=GetGadgetText(#Apellidotext)
               If apellido$=""
                DisableGadget(#Apellidotext,0)
                DisableGadget(#Nombretext,0)
                DisableGadget(#DNItext,0)
                HideGadget(#ModificarArchivo,1)
                
              Else
                MessageRequester("Error","Este dato ya se encuentra grabado",#PB_MessageRequester_Warning)
                DisableGadget(#Apellidotext,1)
                DisableGadget(#Nombretext,1)
                DisableGadget(#DNItext,1)
                HideGadget(#ModificarArchivo,1)
              EndIf
              
            Case #MenuModificacion
              entrada$=login()
              
              If entrada$=pass$
                
                SetGadgetText(#Titulo,"Modificacion de datos")
                DisableGadget(#BotonAnterior,1)
                DisableGadget(#BotonPosterior,1)
                DisableGadget(#BotonGuardar,0)
                DisableGadget(#Nombretext,0)
                DisableGadget(#Apellidotext,0)
                DisableGadget(#DNItext,0)
                HideGadget(#ModificarArchivo,0)
              Else
                SetGadgetText(#Titulo,"Error de autenticacion")
                DisableGadget(#BotonAnterior,1)
                DisableGadget(#BotonPosterior,1)
                DisableGadget(#BotonGuardar,1)
                DisableGadget(#Nombretext,1)
                DisableGadget(#Apellidotext,1)
                DisableGadget(#DNItext,1)
                HideGadget(#ModificarArchivo,1)
              EndIf
                    
              
              
        EndSelect
        
      Case #PB_Event_Gadget
        Select EventGadget()
          
          Case #BotonGuardar
            nombre$=GetGadgetText(#Nombretext)
            apellido$=GetGadgetText(#Apellidotext)
            dni$=GetGadgetText(#DNItext)

            texto$ = nombre$ + "," + apellido$ + "," + dni$
             
            If nombre$=""
              MessageRequester("Error","No completaste el nombre")
            EndIf
            If apellido$=""
              MessageRequester("Error","No completaste el apellido")
            EndIf
            If dni$=""
              MessageRequester("Error","No completaste el DNI")
            EndIf
            If nombre$<>"" And apellido$<>"" And  dni$<>""
              listaApellido$(posicion)=GetGadgetText(#Apellidotext)
              listanombre$(posicion)=GetGadgetText(#Nombretext)
              listaDni$(posicion)=GetGadgetText(#DNItext)
              posicion = posicion+1
            EndIf
            If GetGadgetText(#Titulo)<>"Modificacion de datos"
              If OpenFile(#Archivo,"Fichero Simple.txt")
               FileSeek(#Archivo, Lof(#Archivo)) 
                WriteStringN(#Archivo, texto$)
                CloseFile(#Archivo)
                
                MessageRequester("Exito", "Datos grabados correctamente", #PB_MessageRequester_Ok)
                actualizarvalores()
              EndIf 
       
            Else

                    MessageRequester("Mensaje","Datos modificados correctamente",#PB_MessageRequester_Info)
               
              DisableGadget(#BotonAnterior,0)
              DisableGadget(#BotonPosterior,0)
              DisableGadget(#BotonGuardar,1)
              DisableGadget(#Nombretext,1)
              DisableGadget(#Apellidotext,1)
              DisableGadget(#DNItext,1)
              SetGadgetText(#Titulo,"Sistema de Consultas")
            EndIf
           
              
             
            Case  #BotonAnterior
              If posicion>0
                posicion=posicion-1
                actualizarvalores()
                
              Else
                posicion=19
                actualizarvalores()
              EndIf
              
            Case #BotonPosterior
              If posicion<19
                posicion=posicion+1
                actualizarvalores()
              Else
                posicion=0
                actualizarvalores()
              EndIf 
              
            Case #ModificarArchivo
              If OpenFile(#Archivo,"Fichero Simple.txt")
                FileSeek(#Archivo, posicion+1)
                
                
                
                
                EndIf

            
            
            EndSelect
     EndSelect
  Until Event= #PB_Event_CloseWindow
EndIf

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 106
; FirstLine = 48
; Folding = k
; Markers = 68
; EnableXP