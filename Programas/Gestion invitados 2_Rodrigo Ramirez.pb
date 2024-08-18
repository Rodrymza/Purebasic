;Gestion de invitados con control de ingreso de porteria
;---------------------------------------------
;Progrma fichero simple v2.0
;(c) Rodry Ramirez
; rodrymza@gmail.com

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
  #ventana_porteria
  #buscardni
  #archivo
  #nombre_busqueda
  #apellido_busqueda
  #dni_busqueda
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
  #barra_estado
  #list_icon_invitados
  #lista_modificar
  #lista_borrar
  #lista_titulo
  #exportar
  #archivo_exportado
  #list_icon_porteria
  #porteria_busqueda
  #porteria_boton
  #limpiar_filtro
  #tecla_intro
EndEnumeration

Enumeration FromFont
  #calibri16
  #calibri18
EndEnumeration
;carga de fuentes
LoadFont(#calibri16,"Calibri Light", 16)
LoadFont(#calibri18,"Calibri Light", 18 , #PB_Font_Italic)
;Variables
Global nombrearchivo$="Lista de invitados.txt"

Structure datos
  apellido.s
  nombre.s
  dni.s
EndStructure

NewList invitados.datos()

 Procedure ordenar_alfabetico(List lista.datos())
  SortStructuredList(lista(),#PB_Sort_Ascending,OffsetOf(datos\apellido), TypeOf(datos\apellido))
  EndProcedure
  
  Procedure busqueda(busqueda$, List lista.datos()) ;busca ventanas de porteria
    ClearGadgetItems(#list_icon_porteria)
    If busqueda$="" : ForEach lista() 
        AddGadgetItem(#list_icon_porteria,-1,lista()\dni + Chr(10) + lista()\apellido + Chr(10) + lista()\nombre)
      Next
    Else 
      ForEach lista()
        If LCase(busqueda$)=LCase(lista()\apellido) Or LCase(busqueda$)=LCase(lista()\nombre) Or busqueda$=lista()\dni
          AddGadgetItem(#list_icon_porteria,-1,lista()\dni + Chr(10) + lista()\apellido + Chr(10) + lista()\nombre)
        EndIf
      Next
    EndIf
  EndProcedure
  
  Procedure Asignardatos(List lista.datos())    ;Funcion para leer los datos y asignarlos a la lista
                                              ;se usa la funcion stringfield que separa las cadenas de texto con un delimitador especifico, en este caso con las comas ","
  If ReadFile(#Archivo,nombrearchivo$)
    While Eof(#Archivo)=0
      AddElement(lista())
      linea$=ReadString(#Archivo)
      lista()\apellido=StringField(linea$,1,",")  ;Se le asigna a cada vector el valor leido en cada posicion delimitada por las comas
      lista()\nombre=StringField(linea$,2,",")
      lista()\dni=StringField(linea$,3,",")
    Wend
    CloseFile(#Archivo)
  EndIf   
  ordenar_alfabetico(lista())
EndProcedure

Procedure guardarArchivo(List lista.datos(),filename.s) ;guarda el archivo
  CreateFile(#archivo,filename.s)
  ForEach lista()
    texto$=lista()\apellido + "," + lista()\nombre + "," + lista()\dni
    FileSeek(#archivo,Lof(#archivo))
    WriteStringN(#archivo, texto$)
  Next
  CloseFile(#archivo)
EndProcedure

Procedure actulizar_listicon(List lista.datos())
  ordenar_alfabetico(lista())
  guardarArchivo(lista(),nombrearchivo$)
  ClearGadgetItems(#list_icon_invitados)
  ForEach lista() : AddGadgetItem(#list_icon_invitados,-1,lista()\dni + Chr(10) + lista()\apellido + Chr(10) + lista()\nombre) : Next
  SetGadgetText(#lista_titulo,"Total de invitados: " + Str(ListSize(lista())))
  StatusBarText(#barra_estado,0,"Existe un archivo de invitados (Total:" + Str(ListSize(lista())) + ")")
EndProcedure

Procedure ventana_ingreso(List lista.datos(),valor)
  If valor=-1
    label.s="Guardar"
    numero_invitado.s=Str(ListSize(lista()))
    name.s="" : surname.s="" : id.s=""
  Else
    SelectElement(lista(),valor)
    label="Modificar"
    numero_invitado=Str(ListIndex(lista())+1)
    name.s=lista()\nombre : surname.s=lista()\apellido : id.s=lista()\dni
  EndIf 
  
  LastElement(lista())
  quit=#False
  OpenWindow(#ventana_ingreso,0,0,420,300,"Sistema Ingreso de Invitados", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  TextGadget(#tituloingreso, 90, 10, 230, 30, "Agregar invitado", #PB_Text_Center)
  SetGadgetFont(#tituloingreso,FontID(#calibri16))
  ButtonGadget(#boton_guardar, 240, 240, 120, 25, label)
  StringGadget(#apellido, 170, 80, 150, 30, surname)
  StringGadget(#nombre, 170, 120, 150, 30, name)
  StringGadget(#dni, 170, 160, 150, 30, id)
  TextGadget(#PB_Any, 60, 80, 100, 30, "Apellido", #PB_Text_Center)
  TextGadget(#PB_Any, 60, 120, 100, 30, "Nombre", #PB_Text_Center)
  TextGadget(#PB_Any, 60, 160, 100, 30, "DNI", #PB_Text_Center)
  TextGadget(#posicion_invitado, 170, 50, 150, 25, numero_invitado)
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
              If valor=-1 : AddElement(lista()) : Else : EndIf
              lista()\apellido=UCase(Left(GetGadgetText(#apellido), 1)) + Mid(LCase(GetGadgetText(#apellido)), 2)  ;formateo de nombre y apellido a primer letra mayuscula
              lista()\nombre=UCase(Left(GetGadgetText(#nombre), 1)) + Mid(LCase(GetGadgetText(#nombre)), 2)
              lista()\dni=GetGadgetText(#dni)
              ordenar_alfabetico(lista())
              If valor=-1
                SetGadgetText(#posicion_invitado,Str(ListSize(lista())))
                SetGadgetText(#apellido,"")
                SetGadgetText(#nombre,"")           
                SetGadgetText(#dni,"")
              EndIf 
              
              guardarArchivo(lista(),nombrearchivo$)
              MessageRequester("Guardado","Invitado guardado correctamente",#PB_MessageRequester_Ok)
            Else
              MessageRequester("Error","Falta completar campos", #PB_MessageRequester_Error)
            EndIf 
            If label="Modificar"
              actulizar_listicon(lista())
            EndIf
            
          Case #boton_cancelar
            quit=#True
            CloseWindow(#ventana_ingreso)
            
        EndSelect
        
    EndSelect
    
  Until event=#PB_Event_CloseWindow Or quit=#True
EndProcedure

Procedure ventanaLista(List lista.datos())
  OpenWindow(#ventana_lista, 0, 0, 470, 590, "Lista de Invitados", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(#lista_titulo, 0, 10, 470, 25, "Total de invitados: " + Str(ListSize(lista())) , #PB_Text_Center)
  ListIconGadget(#list_icon_invitados, 10, 50, 450, 490, "DNI", 100, #PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
  AddGadgetColumn(#list_icon_invitados, 1, "Apellido", 160)
  AddGadgetColumn(#list_icon_invitados, 2, "Nombre", 160)
  ButtonGadget(#lista_modificar, 70, 550, 130, 25, "Modificar")
  ButtonGadget(#lista_borrar, 250, 550, 130, 25, "Borrar")
  
  ClearGadgetItems(#list_icon_invitados)
  ForEach lista()
    AddGadgetItem(#list_icon_invitados,-1,lista()\dni + Chr(10) + lista()\apellido + Chr(10) + lista()\nombre)
  Next
  
  Repeat 
    event = WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_lista)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #lista_modificar
            ventana_ingreso(lista(),GetGadgetState(#list_icon_invitados))
            
          Case #lista_borrar
            SelectElement(lista(),GetGadgetState(#list_icon_invitados))
            result= MessageRequester("Atencion","Se borrará el invitado " + lista()\apellido + ", " + lista()\nombre + Chr(10) + "¿Continuar?" ,#PB_MessageRequester_YesNo)
            If result=#PB_MessageRequester_Yes
              DeleteElement(lista())
              actulizar_listicon(lista())
              MessageRequester("Borrado","Invitado borrado exitosamente")
            EndIf 
          Case #list_icon_invitados
            Select EventType()
              Case #PB_EventType_LeftDoubleClick
                ventana_ingreso(lista(),GetGadgetState(#list_icon_invitados))
            EndSelect
        EndSelect
    EndSelect
  Until event = #PB_Event_CloseWindow
EndProcedure

Procedure ventanaPorteria (List lista.datos())
  
  OpenWindow(#ventana_porteria, x, y, 470, 590, "Gestion de Ingreso de Porteria", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(#PB_Any, 0, 10, 470, 25, "Control Porteria", #PB_Text_Center)
  CreateMenu(#PB_Any,WindowID(#ventana_porteria))
  MenuTitle("Filtro")
  MenuItem(#limpiar_filtro,"Limpiar filtro")
  ListIconGadget(#list_icon_porteria, 10, 90, 450, 490, "DNI", 100, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#list_icon_porteria, 1, "Apellido", 160)
  AddGadgetColumn(#list_icon_porteria, 2, "Nombre", 160)
  TextGadget(#PB_Any, 30, 50, 100, 25, "Busqueda")
  StringGadget(#porteria_busqueda,130, 50, 200, 25, "")
  ButtonGadget(#porteria_boton, 350, 50, 100, 25, "Buscar")
  AddKeyboardShortcut(#ventana_porteria, #PB_Shortcut_Return, #tecla_intro)
  ForEach lista()
    AddGadgetItem(#list_icon_porteria,-1,lista()\dni + Chr(10) + lista()\apellido + Chr(10) + lista()\nombre)
  Next
  Repeat  
    event.l=WindowEvent()
    Select event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_porteria)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case  #porteria_boton
            ClearGadgetItems(#list_icon_porteria)
            busqueda$=GetGadgetText(#porteria_busqueda)
            busqueda(busqueda$,lista())
        EndSelect
      Case #PB_Event_Menu
        Select EventMenu()
          Case #limpiar_filtro
            ClearGadgetItems(#list_icon_porteria)
            ForEach lista() : AddGadgetItem(#list_icon_porteria,-1,lista()\dni + Chr(10) + lista()\apellido + Chr(10) + lista()\nombre) : Next
          Case #tecla_intro
            busqueda$=GetGadgetText(#porteria_busqueda)
            busqueda(busqueda$,lista())
        EndSelect
        
    EndSelect     
  Until event= #PB_Event_CloseWindow
EndProcedure

Procedure ventana_ayuda() ;del menu de ayuda-acerca de
  OpenWindow(#ventana_ayuda, 0, 0, 310, 210, "", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  TextGadget(#PB_Any, 30, 20, 160, 20, "Gestion de invitados v2.0")
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

OpenWindow(#ventana_principal,0,0,250,270,"Sistema de gestion de invitados", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)

If OpenFile(#Archivo,nombrearchivo$)=0  : EndIf
Asignardatos(invitados())
;gadgets
TextGadget(#titulo, 40, 40, 170, 30, "Gestion invitados", #PB_Text_Center)
SetGadgetFont(#titulo,FontID(#calibri18))
ButtonGadget(#boton_ingreso, 40, 100, 170, 25, "Agregar invitados")
ButtonGadget(#boton_lista, 40, 140, 170, 25, "Ver y modificar invitados")
ButtonGadget(#boton_porteria, 40, 180, 170, 25, "Control de porteria")
CreateMenu(#menu,WindowID(#ventana_principal))
MenuTitle("Ayuda")
MenuItem(#exportar,"Exportar lista de invitados")
MenuItem(#acercade,"Acerca de")
CreateStatusBar(#barra_estado,WindowID(#ventana_principal))
AddStatusBarField(250)
StatusBarText(#barra_estado,0,"")
If ListSize(invitados())>=1
  StatusBarText(#barra_estado,0,"Existe un archivo de invitados (Total:" + Str(ListSize(invitados())) + ")")
Else
  StatusBarText(#barra_estado,0,"No hay archivo guardado")
EndIf 

Repeat
  event.l=WindowEvent()
  
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_ingreso
          ventana_ingreso(invitados(),-1)
        Case #boton_porteria
          ventanaPorteria(invitados())
        Case #boton_lista
          ventanaLista(invitados())
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #acercade
          ventana_ayuda()
        Case #exportar
          guardar.s=SaveFileRequester("Exportar archivo","C:\Invitados.txt","Archivo de texto.txt",0)
          If guardar
            guardarArchivo(invitados(),guardar)
          EndIf 
          
          Debug guardar            
      EndSelect
    EndSelect
Until event = #PB_Event_CloseWindow

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 194
; FirstLine = 88
; Folding = A7
; EnableXP
; DPIAware