;no se elimina archivo detalles --- parece que funciona, probar
;sacar acceso directo de intro, inferfiere pare escribir en editor

Enumeration
  #ventana_principal :  #panel_principal
  #boton_eliminar : #boton_guardar
  #boton_modificar :  #boton_anadir : #editor_mini
  #boton_buscar : #lista_obras_sociales : #title_os
  #string_busqueda :  #string_nombre : #calibri
  #editor_detalle :  #string_requisito_especial : #icono
  #combo_autorizacion : #boton_descripcion : #title_pestana
  #mini_lista :  #guardar_detalle : #combo_coseguro
  #calibri14 :  #archivo_detalles : #archivo_bdd
  #calibri_negrita : #tecla_intro : #calibri13 : #icono_2
  #imagen_principal : #gadget_imagen : #xray_icon : #ayuda
  #ventana_ayuda : #about_ico : #about_image
EndEnumeration

Structure info
  nombre.s
  autorizacion.i
  coseguro.i
  requisito_especial.s
  modificacion.i
  detallado.s
EndStructure
UsePNGImageDecoder()

LoadImage(#icono,"rx.ico")
LoadImage(#imagen_principal,"image.ico")
LoadImage(#xray_icon, "xray.png")
ResizeImage(#xray_icon, 88, 88)
LoadFont(#calibri, "Calibri", 12)
LoadFont(#calibri14, "Calibri Light", 14)
LoadFont(#calibri13, "Calibri Light", 13)
LoadFont(#calibri_negrita, "Calibri", 13, #PB_Font_Bold | #PB_Font_Italic)
NewList obras_sociales.info()

Global Dim boolean.s(1) : boolean(0) = "No" : boolean(1) = "Si"
Global anadir.s="Añadir Obra Social", modificar.s="Modificar Obra Social", base_datos.s="Data/Base_datos.txt"
NewList gadgetlist()

Procedure ventana_acercade() ;del menu de ayuda-acerca de
  OpenWindow(#ventana_ayuda, 0, 0, 480, 190, "Acerca de", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  SendMessage_(WindowID(#ventana_ayuda), #WM_SETICON, 0, LoadImage(#about_ico, "about.ico"))
  TextGadget(#PB_Any, 30, 50, 260, 25, "Autorizacion de Obras Sociales v1")
  TextGadget(#PB_Any, 30, 90, 260, 25, "Rodry Ramirez (c) 2024")
  TextGadget(#PB_Any, 30, 130, 260, 25, "rodrymza@gmail.com")
  ImageGadget(#PB_Any, 320, 32, 128, 128, LoadImage(#about_image, "medical.ico"))
  Repeat  
    event=WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_ayuda) 
      EndSelect
    Until event= #PB_Event_CloseWindow
  EndProcedure

Procedure$ title(palabra$)
  If palabra$<>UCase(palabra$)
  i.l=2
  r$=UCase(Mid(palabra$,1,1))
  While i<= Len(palabra$)
    If Mid(palabra$,i,1)=" "
      r$=r$+ UCase(Mid(palabra$,i,2))
      i=i+2
    Else
      r$=r$+LCase(Mid(palabra$,i,1))
      i=i+1
    EndIf
  Wend
  ProcedureReturn r$
Else 
  ProcedureReturn palabra$
  EndIf
EndProcedure

Procedure guardar_base_datos(List lista.info())
  CreateFile(#archivo_detalles, "Data/" + lista()\nombre + ".txt")
  WriteString(#archivo_detalles,lista()\detallado)
  CloseFile(#archivo_detalles)
  CreateFile(#archivo_bdd,base_datos)
  ForEach lista()
    WriteStringN(#archivo_bdd, lista()\nombre + "," + Str(lista()\autorizacion) + "," + Str(lista()\coseguro) + "," + lista()\requisito_especial + "," + lista()\modificacion)
  Next
  CloseFile(#archivo_bdd)
EndProcedure

Procedure actualizar_lista(List lista.info(),gadget)
  ClearGadgetItems(gadget)
  ClearGadgetItems(#mini_lista)
  ForEach lista()
    AddGadgetItem(gadget, n, lista()\nombre + Chr(10) + boolean(lista()\autorizacion) + Chr(10) + boolean(lista()\coseguro) + Chr(10) + lista()\requisito_especial + Chr(10) + FormatDate("%dd-%mm-%yyyy", lista()\modificacion))
    If CountGadgetItems(gadget)%2=0 : SetGadgetItemColor(gadget,n,#PB_Gadget_BackColor,$E6E0B0)
    Else : SetGadgetItemColor(gadget,n,#PB_Gadget_BackColor,$EBCE87)
    EndIf 
    n=n+1
    AddGadgetItem(#mini_lista, -1, lista()\nombre)
  Next
  SetGadgetAttribute(#editor_detalle, #PB_Editor_ReadOnly | #PB_Editor_WordWrap, 1)
EndProcedure

Procedure buscar_elemento(string.s,List lista.info())
  ResetList(lista())
  While NextElement(lista())
    If LCase(lista()\nombre)=LCase(string)
      ProcedureReturn 1
    EndIf 
  Wend
    MessageRequester("Atencion","No seleccionaste ningun elemento",#PB_MessageRequester_Error)
  ProcedureReturn 0
EndProcedure

Procedure guardar_os(List lista.info())
  If GetGadgetText(#string_nombre)<>""
    If GetGadgetText(#title_pestana)=anadir : AddElement(lista()) : EndIf
    lista()\nombre=title(GetGadgetText(#string_nombre))
    lista()\autorizacion=GetGadgetState(#combo_autorizacion)
    lista()\coseguro=GetGadgetState(#combo_coseguro)
    lista()\requisito_especial=GetGadgetText(#string_requisito_especial)
    lista()\detallado=GetGadgetText(#editor_detalle)
    lista()\modificacion=Date()
    guardar_base_datos(lista())
    MessageRequester("Atencion","Guardado correctamente", #PB_MessageRequester_Info)
    SortStructuredList(lista(), #PB_Sort_Ascending, OffsetOf(info\nombre), TypeOf(info\nombre))
    actualizar_lista(lista(), #lista_obras_sociales)
  Else
    MessageRequester("Error","No introduciste nombre de obra social",#PB_MessageRequester_Warning)
    ProcedureReturn 0
  EndIf 
EndProcedure

Procedure leer_datos(List lista.info())
  
  If ReadFile(#archivo_bdd, base_datos)
    While Eof(#archivo_bdd)=0
      string.s=ReadString(#archivo_bdd) 
      AddElement(lista())
      lista()\nombre=StringField(String,1,",") ;: Debug lista()\nombre + "."
      lista()\autorizacion=Val(StringField(String,2,",")) ;: Debug lista()\autorizacion
      lista()\coseguro=Val(StringField(String,3,","))     ;: Debug lista()\coseguro
      lista()\requisito_especial=StringField(String,4,",") ;: Debug  "." + lista()\requisito_especial + "."
      lista()\modificacion=Val(StringField(String, 5, ","))
      
      ReadFile(#archivo_detalles,"Data/" + lista()\nombre + ".txt")
      While Eof(#archivo_detalles)=0
        lista()\detallado=lista()\detallado + ReadString(#archivo_detalles) + Chr(10)
      Wend 
      ;Debug lista()\detallado
    Wend
    SortStructuredList(lista(), #PB_Sort_Ascending, OffsetOf(info\nombre), TypeOf(info\nombre))
    actualizar_lista(lista(), #lista_obras_sociales)
  Else 
    MessageRequester("Error","No se pudo leer la base de datos", #PB_MessageRequester_Error)
  EndIf 
EndProcedure

Procedure seleccion_elemento(List obras_sociales.info(),string.s)
  If buscar_elemento(string.s, obras_sociales())
    SetGadgetText(#title_pestana, modificar)
    SetGadgetText(#string_nombre, obras_sociales()\nombre)
    SetGadgetState(#combo_autorizacion, obras_sociales()\autorizacion)
    SetGadgetState(#combo_coseguro, obras_sociales()\coseguro)
    SetGadgetText(#string_requisito_especial, obras_sociales()\requisito_especial)
    SetGadgetText(#editor_mini, obras_sociales()\detallado)
    SetGadgetText(#editor_detalle, obras_sociales()\detallado)
    SetGadgetState(#panel_principal,1)
    SetActiveGadget(#string_nombre)
    DisableGadget(#string_nombre,1)
    SetGadgetText(#title_os, "Obra Social: " + obras_sociales()\nombre)
  EndIf
EndProcedure

Procedure busqueda(List obras_sociales.info(),string.s)
  If string=""
    actualizar_lista(obras_sociales(),#lista_obras_sociales)
  Else
    NewList lista_auxiliar.info()
    ForEach obras_sociales()
      If FindString(LCase(obras_sociales()\nombre),LCase(string))
        AddElement(lista_auxiliar())
        lista_auxiliar()=obras_sociales()
      EndIf
    Next
    actualizar_lista(lista_auxiliar(),#lista_obras_sociales)
  EndIf
EndProcedure

OpenWindow(#ventana_principal, 0, 0, 780, 590, "Autorizacion de Obras Sociales", #PB_Window_SystemMenu  | #PB_Window_ScreenCentered)
SendMessage_(WindowID(#ventana_principal), #WM_SETICON, 0, ImageID(#icono))
SetGadgetFont(#PB_Any, FontID(#calibri))
TextGadget(#PB_Any, 250, 20, 230, 25, "Autorizacion Obras Sociales", #PB_Text_Center)
CreateMenu(#PB_Any,WindowID(#ventana_principal))
MenuTitle("Ayuda")
MenuItem(#ayuda,"Acerca de")

PanelGadget(#panel_principal, 10, 50, 760, 530)
AddGadgetItem(#panel_principal, -1, "Panel Principal")
ImageGadget(#icono_2, 22, 10, 88, 88, ImageID(#xray_icon))
ImageGadget(#gadget_imagen, 532, 10, 128, 128, ImageID(#imagen_principal))
TextGadget(#PB_Any, 10, 110, 100, 25, "Busqueda")
StringGadget(#string_busqueda, 120, 110, 210, 25, "")
ButtonGadget(#boton_buscar, 340, 110, 100, 25, "Buscar")
ListIconGadget(#lista_obras_sociales, 10, 140, 740, 280, "Obra Social", 200, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
AddGadgetColumn(#lista_obras_sociales, 1, "Autoriz Previa", 100)
AddGadgetColumn(#lista_obras_sociales, 2, "Paga coseguro", 100)
AddGadgetColumn(#lista_obras_sociales, 3, "Requisito especial", 180)
AddGadgetColumn(#lista_obras_sociales, 4, "Ultima modificacion", 150)
ButtonGadget(#boton_anadir, 110, 430, 150, 38, "Añadir")
ButtonGadget(#boton_modificar, 310, 430, 150, 38, "Modificar")
ButtonGadget(#boton_eliminar, 510, 430, 150, 38, "Eliminar")
AddGadgetItem(#panel_principal, -1, "Modificar/Añadir Datos", 0, 1)
TextGadget(#title_pestana, 250, 0, 180, 25, "Añadir Obra Social", #PB_Text_Center)
SetGadgetColor(#title_pestana, #PB_Gadget_BackColor, $AACD66)
TextGadget(#PB_Any, 30, 38, 150, 25, "Nombre")
StringGadget(#string_nombre, 190, 38, 250, 25, "")
SetGadgetFont(#string_nombre,FontID(#calibri_negrita))
TextGadget(#PB_Any, 30, 78, 150, 25, "Autorizacion Previa?")
ComboBoxGadget(#combo_autorizacion, 210, 78, 110, 25)
SetGadgetColor(#string_nombre, #PB_Gadget_BackColor, $E6E0B0)
TextGadget(#PB_Any, 30, 118, 150, 25, "Coseguro?")
ComboBoxGadget(#combo_coseguro, 210, 118, 110, 25)
TextGadget(#PB_Any, 30, 158, 150, 25, "Requisito especial")
StringGadget(#string_requisito_especial, 190, 158, 250, 25, "")
ButtonGadget(#boton_descripcion, 30, 208, 180, 50, "Modificar Nota General")
ButtonGadget(#boton_guardar, 320, 218, 120, 35, "Guardar")
ListIconGadget(#mini_lista, 480, 18, 230, 240, "Obras Sociales", 220, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
SetGadgetColor(#mini_lista, #PB_Gadget_BackColor, $E6E0B0)
EditorGadget(#editor_mini, 20, 278, 720, 200, #PB_Editor_WordWrap | #PB_Editor_ReadOnly)
SetGadgetFont(#editor_mini, FontID(#calibri13))

AddGadgetItem(#panel_principal, -1, "Nota General", 0, 2)
TextGadget(#title_os, 160, 10, 350, 25, "Obra Social: " , #PB_Text_Center)
SetGadgetColor(#title_os, #PB_Gadget_BackColor, $7280FA)
EditorGadget(#editor_detalle, 10, 38, 740, 420, #PB_Editor_WordWrap)
SetGadgetFont(#editor_detalle,FontID(#calibri14))
ButtonGadget(#guardar_detalle, 510, 468, 190, 25, "Guardar Cambios")
CloseGadgetList()
For i=0 To 1
  AddGadgetItem(#combo_autorizacion, -1,boolean(i))
  AddGadgetItem(#combo_coseguro, -1,boolean(i))
Next
SetGadgetState(#combo_autorizacion,0)
SetGadgetState(#combo_coseguro,0)

leer_datos(obras_sociales())

Repeat  
  event=WindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_guardar
          guardar_os(obras_sociales())
          
        Case #guardar_detalle
          guardar_os(obras_sociales())
          SetGadgetState(#panel_principal,0)
          
        Case #boton_eliminar
          If GetGadgetText(#lista_obras_sociales)=""
            MessageRequester("Error","No seleccionaste ninguna OS de la lista",#PB_MessageRequester_Error)
          Else
            ResetList(obras_sociales())
            While NextElement(obras_sociales())
              If GetGadgetText(#lista_obras_sociales)=obras_sociales()\nombre
                Break
              EndIf 
            Wend  
            result=MessageRequester("Atencion","Desea borrar la obra social " + obras_sociales()\nombre, #PB_MessageRequester_YesNo | #PB_MessageRequester_Warning)
            If result=#PB_MessageRequester_Yes
              If DeleteFile("Data/" + obras_sociales()\nombre + ".txt")
                DeleteElement(obras_sociales())
                actualizar_lista(obras_sociales(), #lista_obras_sociales)
                guardar_base_datos(obras_sociales())
                MessageRequester("Proceso Exitoso","Se borro correctamente la Obra Social del sistema", #PB_MessageRequester_Info)
              Else
                Debug "error al borrar archivo"
              EndIf 
            EndIf 
          EndIf 
          
        Case #mini_lista
          If EventType()=#PB_EventType_LeftDoubleClick : seleccion_elemento(obras_sociales(), GetGadgetText(#mini_lista)) : EndIf 
          
        Case #lista_obras_sociales
          If EventType()=#PB_EventType_LeftDoubleClick : seleccion_elemento(obras_sociales(), GetGadgetText(#lista_obras_sociales)) : EndIf 
          
        Case #boton_anadir
          DisableGadget(#string_nombre,0)
          SetGadgetText(#title_pestana, anadir)
          SetGadgetText(#string_nombre, "") : SetGadgetText(#editor_detalle, "") : SetGadgetState(#combo_autorizacion,0)
          SetGadgetText(#string_requisito_especial, "") : SetGadgetText(#editor_mini, "") : SetGadgetState(#combo_coseguro,0)
          SetGadgetState(#panel_principal,1) : SetActiveGadget(#string_nombre)
          SetGadgetText(#title_os, "Nueva Obra Social")
          
        Case #string_nombre
          If EventType()=#PB_EventType_LostFocus
            If GetGadgetText(#title_pestana)=anadir
              ForEach obras_sociales()
                If LCase(obras_sociales()\nombre)=LCase(GetGadgetText(#string_nombre))
                  MessageRequester("Error", "La obra social ya se encuentra en el sistema", #PB_MessageRequester_Error)
                  seleccion_elemento(obras_sociales(), GetGadgetText(#string_nombre))
                EndIf
              Next
            EndIf 
          EndIf 
              
        Case #boton_descripcion
          SetGadgetState(#panel_principal,2)
        Case #editor_detalle
          If EventType()=#PB_EventType_LostFocus
            text$=GetGadgetText(#editor_detalle)
            SetGadgetText(#editor_mini,text$)
          EndIf 
          
        Case #boton_modificar
          seleccion_elemento(obras_sociales(), GetGadgetText(#lista_obras_sociales))
          
        Case #boton_buscar
          busqueda(obras_sociales(),GetGadgetText(#string_busqueda)) 
          
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #ayuda
          ventana_acercade()
      EndSelect
  EndSelect
Until event = #PB_Event_CloseWindow 
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 315
; FirstLine = 154
; Folding = A5
; EnableXP
; UseIcon = rx.ico
; Executable = C:\Users\Rodrigo\Desktop\Gestion Obras Sociales\Autorizaciones.exe
; HideErrorLog