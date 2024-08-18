Enumeration
  #ventana_principal
  #titulo
  #apellido
  #nombre
  #dni
  #menu
  #ventana_ayuda
  #acercade
  #boton_de_ayuda
  #boton_guardar
  #boton_cancelar
  #boton_ingreso
  #ventana_ingreso
  #posicion_invitado
  #boton_lista
  #boton_porteria
  #ventana_poreteria
  #buscardni
  #buscar_porteria
  #archivo
  #nombre_busqueda
  #apellido_busqueda
  #dni_busqueda
  #combobox
  #tituloingreso
  #guardar_lista
  #apellido_lista
  #nombre_lista
  #dni_lista
  #salir_lista
  #combo_lista
  #buscar_lista
  #buscar_dni_lista
  #ventana_lista
  #invitado_lista
EndEnumeration

Enumeration FromFont
  #calibri16
  #calibri18
EndEnumeration
;carga de fuentes
LoadFont(#calibri16,"Calibri Light", 16)
LoadFont(#calibri18,"Calibri Light", 18 , #PB_Font_Italic)
;Variables
Global posicion.l=0, maxInvitados=100, Dim texto$(maxInvitados), nombrearchivo$="Invitados.txt"
Global Dim nombrelista$(maxInvitados), Dim apellidolista$(maxInvitados), Dim dnilista$(maxInvitados)

Procedure posfinal() ;establece la ultima posicion donde se encuentra un arreglo con datos
  For i=0 To maxInvitados-1
    If texto$(i)<>""
      posicionfinal=i : ;Debug posicionfinal
    EndIf
  Next
  ProcedureReturn posicionfinal
EndProcedure

Procedure busquedaDni(busqueda$) ;busca dni en ventanas de porteria y lista
  posicionfinal=posfinal()
  posbusqueda=-1
  For i=0 To posicionfinal
    If dnilista$(i)=busqueda$
      posbusqueda=i
      Break
    EndIf 
  Next
  
  ProcedureReturn posbusqueda
EndProcedure

Procedure Asignardatos()    ;Funcion para leer los datos y asignarlos a los vetores de apellido, nombre y dni
                            ;se usa la funcion stringfield que separa las cadenas de texto con un delimitador especifico, en este caso con las comas ","
  n.l=0
  If ReadFile(#Archivo,nombrearchivo$)
    While Eof(#Archivo)=0
      linea$=ReadString(#Archivo)
      texto$(n)=linea$
      apellidolista$(n)=StringField(linea$,1,",")  ;Se le asigna a cada vector el valor leido en cada posicion delimitada por las comas
      nombrelista$(n)=StringField(linea$,2,",")
      dnilista$(n)=StringField(linea$,3,",")
      n=n+1
      posicion=n
    Wend
    CloseFile(#Archivo)
  EndIf   
EndProcedure

Procedure ordenar() ;ordena el arreglo en orden alfabetico
  posicionfinal=posfinal()
  
  For i=0 To posicionfinal
    For j=i To posicionfinal
      If texto$(i)>texto$(j)
        aux$=texto$(i)
        texto$(i)=texto$(j)
        texto$(j)=aux$
      EndIf
    Next
  Next
EndProcedure

Procedure guardarArchivo() ;guarda el archivo
  DeleteFile(nombrearchivo$)  ;borra el archivo viejo y vuelve a crear uno nuevo
  i.l=0
  ordenar()
  For i=0 To 99
    If texto$(i)<>""
       OpenFile(#Archivo,nombrearchivo$)
      FileSeek(#Archivo, Lof(#Archivo)) 
      WriteStringN(#Archivo, texto$(i))
    EndIf 
  Next
  CloseFile(#archivo)
  
EndProcedure

Procedure ventana_ingreso()
  posicion=posfinal()
  quit=#False
  OpenWindow(#ventana_ingreso,0,0,420,300,"Sistema Ingreso de Invitados", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  TextGadget(#tituloingreso, 90, 10, 230, 30, "Agregar invitado", #PB_Text_Center)
  SetGadgetFont(#tituloingreso,FontID(#calibri16))
  ButtonGadget(#boton_guardar, 240, 240, 120, 25, "Guardar")
  StringGadget(#apellido, 170, 80, 150, 30, "")
  StringGadget(#nombre, 170, 120, 150, 30, "")
  StringGadget(#dni, 170, 160, 150, 30, "")
  TextGadget(#PB_Any, 60, 80, 100, 30, "Apellido", #PB_Text_Center)
  TextGadget(#PB_Any, 60, 120, 100, 30, "Nombre", #PB_Text_Center)
  TextGadget(#PB_Any, 60, 160, 100, 30, "DNI", #PB_Text_Center)
  TextGadget(#posicion_invitado, 170, 50, 150, 25, Str(posicion+1))
  ButtonGadget(#boton_cancelar, 60, 240, 120, 25, "Salir")
  TextGadget(#PB_Any, 80, 50, 100, 25, "Nº Invitado")
  

  Repeat
    event.l= WindowEvent()
    Select event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_ingreso)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_guardar
            If GetGadgetText(#apellido)<>"" And GetGadgetText(#nombre)<>"" And GetGadgetText(#dni)<>""
              lastname$=UCase(Left(GetGadgetText(#apellido), 1)) + Mid(LCase(GetGadgetText(#apellido)), 2)  ;formateo de nombre y apellido a primer letra mayuscula
              name$=UCase(Left(GetGadgetText(#nombre), 1)) + Mid(LCase(GetGadgetText(#nombre)), 2)
              texto$(posicion)=  lastname$+ "," + name$ + "," + GetGadgetText(#dni)
              posicion=posicion+1
              SetGadgetText(#posicion_invitado,Str(posicion+1))
              SetGadgetText(#apellido,"")
              SetGadgetText(#nombre,"")           
              SetGadgetText(#dni,"")
              guardarArchivo()
              Asignardatos()
              MessageRequester("Guardado","Invitado guardado correctamente",#PB_MessageRequester_Ok)
            Else
              MessageRequester("Error","Falta completar campos", #PB_MessageRequester_Error)
            EndIf 
         
            Case #boton_cancelar
              quit=#True
              CloseWindow(#ventana_ingreso)
              
          EndSelect
          
      EndSelect
      
    Until event=#PB_Event_CloseWindow Or quit=#True
  EndProcedure
  
  Procedure agregarCombo() ;agrega elementos a combobox
    ClearGadgetItems(#combobox) ;limpia los elementos anteriores asi no aparecen duplicados
    posfinal=posfinal()
    For i=0 To posfinal
      AddGadgetItem(#combobox,-1,texto$(i))
    Next
  EndProcedure  
    
Procedure ventanaPorteria ()
  
  
  OpenWindow(#ventana_poreteria,0,0,350,250,"Gestion de porteria",#PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  TextGadget(#PB_Any, 30, 70, 120, 30, "Ingrese DNI", #PB_Text_Center)
  StringGadget(#buscardni, 160, 60, 130, 30, "Coloque DNI")
  StringGadget(#apellido_busqueda, 150, 100, 100, 25, "Apellido", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 60, 100, 90, 25, "Apellido", #PB_Text_Center)
  StringGadget(#nombre_busqueda, 150, 130, 100, 25, "Nombre", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 60, 130, 90, 25, "Nombre", #PB_Text_Center)
  StringGadget(#dni_busqueda, 150, 160, 100, 25, "DNI", #PB_String_ReadOnly)
  TextGadget(#PB_Any, 60, 160, 90, 25, "DNI", #PB_Text_Center)
  ComboBoxGadget(#combobox, 50, 10, 210, 25) : ClearGadgetItems(#combobox) :  agregarCombo()
  ButtonGadget(#buscar_porteria, 90, 210, 180, 25, "Buscar", #PB_Button_MultiLine)
  
  Repeat  
    event.l=WindowEvent()
    Select event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_poreteria)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case  #buscar_porteria
            busqueda$=GetGadgetText(#buscardni)
            valor_encontrado=busquedaDni(busqueda$)
            If valor_encontrado>=0
              MessageRequester("Encontrado","Invitado encontrado en la lista", #PB_MessageRequester_Ok)
              SetGadgetText(#apellido_busqueda,apellidolista$(valor_encontrado))
              SetGadgetText(#nombre_busqueda,nombrelista$(valor_encontrado))
              SetGadgetText(#dni_busqueda,dnilista$(valor_encontrado))
            ElseIf busqueda$=""
              MessageRequester("Error","No se ingreso DNI",#PB_MessageRequester_Warning)
            Else
            MessageRequester("Error","No se encontro invitado con DNI ingresado",#PB_MessageRequester_Error)
          EndIf 
        Case #combobox
          posicionfinal=posfinal()
          For i=0 To posicionfinal
            If GetGadgetText(#combobox)=texto$(i)
              valor=i
              Break
            EndIf 
          Next
          SetGadgetText(#nombre_busqueda,nombrelista$(valor)) : SetGadgetText(#apellido_busqueda,apellidolista$(valor)) : SetGadgetText(#dni_busqueda,dnilista$(valor)) 
          
        Case #buscardni
          c=0
          If GetGadgetText(#buscardni)="Coloque DNI" : SetGadgetText(#buscardni,"") : EndIf 
        EndSelect
    EndSelect     
  Until event= #PB_Event_CloseWindow
EndProcedure

Procedure ventanaLista()
  quit=#False
  posicion=0
  OpenWindow(#ventana_lista, 0, 0, 420, 300, "Lista de invitados", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(#PB_Any, 90, 10, 230, 30, "Lista de invitados:", #PB_Text_Center)
  ButtonGadget(#guardar_lista, 240, 260, 120, 25, "Guardar")
  StringGadget(#apellido_lista, 170, 80, 150, 30, apellidolista$(posicion))
  StringGadget(#nombre_lista, 170, 120, 150, 30, nombrelista$(posicion))
  StringGadget(#dni_lista, 170, 160, 150, 30, dnilista$(posicion))
  TextGadget(#PB_Any, 60, 80, 100, 30, "Apellido", #PB_Text_Center)
  TextGadget(#PB_Any, 60, 120, 100, 30, "Nombre", #PB_Text_Center)
  TextGadget(#PB_Any, 60, 160, 100, 30, "DNI", #PB_Text_Center)
  ButtonGadget(#salir_lista, 60, 260, 120, 25, "Salir")
  ComboBoxGadget(#combobox, 80, 30, 270, 25)
  agregarCombo()
  ButtonGadget(#buscar_lista, 60, 220, 120, 30, "Buscar DNI")
  StringGadget(#buscar_dni_lista, 190, 220, 150, 30, "Ingrese DNI a buscar")
  TextGadget(#invitado_lista, 120, 195, 160, 25, "Invitado N° " + Str(posicion+1))
  
  Repeat  
    event.l=WindowEvent()
    Select event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_lista)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #combobox
            posicionfinal=posfinal()
            For i=0 To posicionfinal
              If GetGadgetText(#combobox)=texto$(i)
                posicion=i
                Break
              EndIf 
            Next
            SetGadgetText(#nombre_lista,nombrelista$(posicion)) : SetGadgetText(#apellido_lista,apellidolista$(posicion)) : SetGadgetText(#dni_lista,dnilista$(posicion)) : SetGadgetText(#invitado_lista, "Invitado N° "+ Str(posicion+1))
          Case #guardar_lista
            If GetGadgetText(#apellido_lista)<>"" And GetGadgetText(#nombre_lista)<>"" And GetGadgetText(#dni_lista)<>""
              lastname$=UCase(Left(GetGadgetText(#apellido_lista), 1)) + Mid(LCase(GetGadgetText(#apellido_lista)), 2)  ;formateo de nombre y apellido a primer letra mayuscula
              name$=UCase(Left(GetGadgetText(#nombre_lista), 1)) + Mid(LCase(GetGadgetText(#nombre_lista)), 2)
              texto$(posicion)=  lastname$+ "," + name$ + "," + GetGadgetText(#dni_lista)
              
              guardarArchivo()
              Asignardatos()
              agregarCombo()
              MessageRequester("Guardado","Invitado guardado correctamente",#PB_MessageRequester_Ok)
            Else
              MessageRequester("Error","Falta completar campos", #PB_MessageRequester_Error)
            EndIf 
          Case  #buscar_lista
            busqueda$=GetGadgetText(#buscar_dni_lista)
            valor=busquedaDni(busqueda$)
            If  busqueda$=""
              MessageRequester("Error","No se ingreso ningun DNI",#PB_MessageRequester_Warning)
            ElseIf  valor=-1
              MessageRequester("Error","No se encontro invitado con DNI ingresado",#PB_MessageRequester_Error)
            Else
              SetGadgetText(#nombre_lista,nombrelista$(valor)) : SetGadgetText(#apellido_lista,apellidolista$(valor)) : SetGadgetText(#dni_lista,dnilista$(valor)) : SetGadgetText(#invitado_lista, "Invitado N° "+ Str(valor+1))
            EndIf 
          Case #buscar_dni_lista
            If GetGadgetText(#buscar_dni_lista)="Ingrese DNI a buscar"
              SetGadgetText(#buscar_dni_lista,"")
            EndIf 
            
          Case #salir_lista
            CloseWindow(#ventana_lista) : quit=#True   
        EndSelect
        
    EndSelect
  Until event = #PB_Event_CloseWindow Or quit=#True
EndProcedure

Procedure ventana_ayuda() ;del menu de ayuda-acerca de
  
   
  OpenWindow(#ventana_ayuda, 0, 0, 310, 210, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
    TextGadget(#PB_Any, 30, 20, 160, 20, "Gestion de invitados v1.0")
    TextGadget(#PB_Any, 30, 50, 160, 20, "Rodry Ramirez (c) 2024")
    TextGadget(#PB_Any, 30, 80, 160, 20, "rodrymza@gmail.com")
    TextGadget(#PB_Any, 30, 110, 190, 20, "Curso Programacion Profesional")
    TextGadget(#PB_Any, 30, 140, 190, 20, "Profesor: Ricardo Ponce")
    ButtonGadget(#boton_de_ayuda, 110, 170, 100, 25, "Aceptar")
    
    Repeat  
      event.l= WindowEvent()
      Select Event
        Case #PB_Event_CloseWindow
          CloseWindow(#ventana_ayuda)
        Case #PB_Event_Gadget
          Select EventGadget()
            Case #boton_de_ayuda
              CloseWindow(#ventana_ayuda)
              quit=#True
          EndSelect
      EndSelect
      
    Until event= #PB_Event_CloseWindow Or quit=#True
  
  EndProcedure

#FLAGS = #PB_Window_ScreenCentered | #PB_Window_SystemMenu

OpenWindow(#ventana_principal,0,0,250,250,"Sistema de gestion de invitados", #flags)

If OpenFile(#Archivo,nombrearchivo$)=0  
  CreateFile(#Archivo,nombrearchivo$)   
EndIf 
Asignardatos()
If posicion<>0
  MessageRequester("Atencion","Se encontro un archivo con " + Str(posicion) + " invitados",#PB_MessageRequester_Info)
EndIf 


;gadgets
TextGadget(#titulo, 40, 40, 170, 30, "Gestion invitados", #PB_Text_Center)
SetGadgetFont(#titulo,FontID(#calibri18))
ButtonGadget(#boton_ingreso, 40, 100, 170, 25, "Agregar invitados")
ButtonGadget(#boton_lista, 40, 140, 170, 25, "Ver y modificar invitados")
ButtonGadget(#boton_porteria, 40, 180, 170, 25, "Control de porteria")
CreateMenu(#menu,WindowID(#ventana_principal))
MenuTitle("Ayuda")
MenuItem(#acercade,"Acerca de")
Repeat
  event.l=WindowEvent()
  
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_ingreso
          ventana_ingreso()
        Case #boton_porteria
          ventanaPorteria()
        Case #boton_lista
          ventanaLista()
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #acercade
          ventana_ayuda()
          EndSelect
  EndSelect
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 204
; FirstLine = 73
; Folding = Ay
; EnableXP
; DPIAware