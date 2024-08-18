;Programa Gestion de Inventario y Ventas con SQL
;Rodry Ramirez (c) 2024
;rodrymza@gmail.com

UseMySQLDatabase()

Enumeration
  #main_window : #boton_inventario : #eliminar_categoria
  #boton_venta : #boton_categorias : #text_busqueda_ventana
  #lista_general : #basedatos : #barra_estado
  #ventana_categorias : #agregar_categoria
  #text_busqueda : #boton_buscar : #acerca_de
  #combo_stock : #lista_stock : #intro_pricipal
  #cambiar_stock : #modificar_producto
  #eliminar_producto : #ventana_stock
  #ventana_modificar : #descripcion_modificar
  #combo_modificar : #precio_modificar : #boton_manual
  #boton_modificar : #nuevo_producto : #ventana_producto_manual
  #lista_ventas_principal :     #ventana_venta
  #lista_venta :  #total_venta : #historial_ventas
  #agregar_producto_venta : #eliminar_producto_venta
  #guardar_venta : #panel_principal : #ventana_ayuda
  #menu_ventana : #lista_categorias : #aceptar_manual
  #boton_nueva_categoria : #boton_eliminar_categoria
  #boton_buscar_stock_ventana : #intro_stock
  #combo_stock_ventana : #lista_stock_ventana : #txt_salida
  #descripcion_manual : #monto_manual : #boton_limpiar_venta
  
EndEnumeration

Structure datos
  producto.s
  categoria.s
  precio.l
EndStructure

Structure infoventas
  fecha.s
  descripcion.s
  total.l
EndStructure

Global NewList lista_categorias.s(), NewList lista_venta.datos(), NewList ventas_generales.infoventas() ; lista_venta guard informacion sobre la venta actual 
                                                                                                        ; y ventas generles guarda info para guardar la venta total en la base de datos
Global dbname.s="host=localhost port=3306 dbname=gestion_inventario", user.s="rodry", pass.s="rodry1234", nuevo_producto.s="New_product_bdd", limpiar_filtro.s="Limpiar Filtro", total.l

Procedure.s generarticket() ; generacion del ticket para guardar en la base de datos y para comprobante
  ForEach lista_venta()
    texto$=texto$ + lista_venta()\producto + " $" + lista_venta()\precio + #LF$
  Next
  texto$= texto$ + "Total $" + Str(total)
  OpenFile(#txt_salida,"ticket.txt")
  WriteStringN(#txt_salida,"Fecha: " + FormatDate("%dd-%mm-%yy %hh:%mm", Date()))
  WriteStringN(#txt_salida,"")
  WriteStringN(#txt_salida,texto$)
  CloseFile(#txt_salida)
  ClearList(lista_venta()) ; se vacian las listas de ventas para no sobreescribir productos
  ClearList(ventas_generales())
  ProcedureReturn texto$
EndProcedure

Procedure leer_categorias() ;lectura de categorias en la base de datos
  
  If OpenDatabase(#basedatos,dbname, user, pass)
    If DatabaseQuery(#basedatos, "SELECT * FROM categorias")
      ClearList(lista_categorias())
      While NextDatabaseRow(#basedatos)
        AddElement(lista_categorias())
        lista_categorias()=GetDatabaseString(#basedatos,0)
      Wend
      StatusBarText(#barra_estado,0,"Categorias importadas de la BBD correctamente")
      CloseDatabase(#basedatos)
    Else
      MessageRequester("Error","Error al ingresar a la tabla")
      
    EndIf
  Else 
    MessageRequester("Error","Error al conectarse a la base de datos")  
  EndIf 
EndProcedure

Procedure actualizar_basedatos(comando.s,mensaje.s) ; funcion para ejecutar comandos SQL
  If OpenDatabase(#basedatos,dbname, user, pass)
    If  DatabaseUpdate(#basedatos,comando)
      MessageRequester("Atencion",mensaje)
      leer_categorias()
    Else
      MessageRequester("Error","Error al ejecutar orden SQL: " + DatabaseError())
    EndIf
  Else
    MessageRequester("Error","Error al conectarse a la BDD: " + DatabaseError())
  EndIf
EndProcedure

Procedure actualizar_lista_stock(gadget, filtro.s) ; funcion que actualiza las listas en la ventana principal y en la ventana de stock independiente
  If filtro=limpiar_filtro : comandoSQL.s="Select * FROM productos ORDER BY categoria ASC"
  Else : comandoSQL="Select * FROM productos WHERE categoria='" + filtro + "' ORDER BY categoria ASC"
  EndIf 
  
  ClearGadgetItems(gadget)
  OpenDatabase(#basedatos,dbname, user, pass)
  DatabaseQuery(#basedatos,comandoSQL)
  i=0
  While NextDatabaseRow(#basedatos)
    
    AddGadgetItem(gadget, -1, GetDatabaseString(#basedatos,0) + Chr(10) + GetDatabaseString(#basedatos,1) + Chr(10) + "$ " + Str(GetDatabaseLong(#basedatos,2)) + Chr(10) + Str(GetDatabaseLong(#basedatos,3)))
    
    If GetDatabaseLong(#basedatos,3)>=10 : SetGadgetItemColor(gadget,i,#PB_Gadget_FrontColor,$701919) : SetGadgetItemColor(gadget,i,#PB_Gadget_BackColor,$EBCE87)
    ElseIf  GetDatabaseLong(#basedatos,3)<10 And GetDatabaseLong(#basedatos,3)>0 : SetGadgetItemColor(gadget,i,#PB_Gadget_FrontColor,$000080) : SetGadgetItemColor(gadget,i,#PB_Gadget_BackColor,$B5E4FF)
    Else : SetGadgetItemColor(gadget,i,#PB_Gadget_FrontColor,$FAFAFF) : SetGadgetItemColor(gadget,i,#PB_Gadget_BackColor,$1A1A8B)
    EndIf 
    
    i=i+1
  Wend  
  CloseDatabase(#basedatos)
  StatusBarText(#barra_estado,0,"Lista actualizada")
EndProcedure

Procedure ventana_modificar(producto.s,accion.s) ; para modificar productos y agregar nuevos
  
  OpenWindow(#ventana_modificar, 0, 0, 390, 280, "Agragar elemento al menu", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(#PB_Any, 40, 90, 100, 25, "Descripcion")
  StringGadget(#descripcion_modificar, 150, 90, 190, 25, "")
  TextGadget(#PB_Any, 30, 30, 330, 25, accion + " Producto", #PB_Text_Center)
  TextGadget(#PB_Any, 40, 130, 100, 25, "Categoria")
  TextGadget(#PB_Any, 40, 170, 100, 25, "Precio")
  ComboBoxGadget(#combo_modificar, 150, 130, 160, 25)
  StringGadget(#precio_modificar, 150, 170, 110, 25, "", #PB_String_Numeric)
  ButtonGadget(#boton_modificar, 220, 220, 100, 25, accion)
  ForEach lista_categorias()
    AddGadgetItem(#combo_modificar,-1,lista_categorias())
  Next
  quit=#False
  If producto<>nuevo_producto
    OpenDatabase(#basedatos,dbname, user, pass)
    If DatabaseQuery(#basedatos,"SELECT * FROM productos WHERE nombre='" + producto + "'")
      While NextDatabaseRow(#basedatos)
        SetGadgetText(#descripcion_modificar,GetDatabaseString(#basedatos,0))
        SetGadgetText(#precio_modificar,Str(GetDatabaseLong(#basedatos,2)))
        ForEach lista_categorias()
          If lista_categorias()=GetDatabaseString(#basedatos,1) :   SetGadgetState(#combo_modificar,ListIndex(lista_categorias())) : EndIf
        Next
      Wend
      CloseDatabase(#basedatos)
    EndIf
  EndIf 
  
  Repeat
    event=WindowEvent()
    Select event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_modificar)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_modificar
            OpenDatabase(#basedatos,dbname,user,pass)
            If producto<>nuevo_producto
              If DatabaseUpdate(#basedatos,"UPDATE productos SET nombre='" + GetGadgetText(#descripcion_modificar) + "', categoria='" + GetGadgetText(#combo_modificar) + "', precio=" + GetGadgetText(#precio_modificar) + " WHERE nombre='" + producto + "'")
                actualizar_lista_stock(#lista_stock,GetGadgetText(#combo_stock))
                StatusBarText(#barra_estado,0,"Producto " + producto + " modificado exitosamente")
                CloseWindow(#ventana_modificar) : quit=#True
              Else
                MessageRequester("Error",DatabaseError(),#PB_MessageRequester_Error)
              EndIf
            Else
              If DatabaseUpdate(#basedatos,"INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('" + GetGadgetText(#descripcion_modificar) + "', '" + GetGadgetText(#combo_modificar) + "', " + GetGadgetText(#precio_modificar) + ", 0)")
                actualizar_lista_stock(#lista_stock,GetGadgetText(#combo_stock))
                StatusBarText(#barra_estado,0,"Producto " + producto + " agregado al stock")
                SetGadgetText(#descripcion_modificar,"") : SetGadgetText(#precio_modificar,"") : SetGadgetState(#combo_modificar,-1)
              Else 
                MessageRequester("Error",DatabaseError())
              EndIf 
            EndIf 
            
        EndSelect
    EndSelect
  Until event=#PB_Event_CloseWindow Or quit=#True
EndProcedure

Procedure busqueda_bdd(gadget,busqueda.s) ; comando SQL para buscar productos a traves de ventana principal y de stock
  OpenDatabase(#basedatos,dbname, user, pass)
  DatabaseQuery(#basedatos,"SELECT * FROM productos WHERE nombre like '%" + busqueda + "%'")
  ClearGadgetItems(gadget)
  While NextDatabaseRow(#basedatos)
    AddGadgetItem(gadget, -1, GetDatabaseString(#basedatos,0) + Chr(10) + GetDatabaseString(#basedatos,1) + Chr(10) + Str(GetDatabaseLong(#basedatos,2)) + Chr(10) + Str(GetDatabaseLong(#basedatos,3)))
    
    If GetDatabaseLong(#basedatos,3)>=10 : SetGadgetItemColor(gadget,i,#PB_Gadget_FrontColor,$701919) : SetGadgetItemColor(gadget,i,#PB_Gadget_BackColor,$EBCE87)
    ElseIf  GetDatabaseLong(#basedatos,3)<10 And GetDatabaseLong(#basedatos,3)>0 : SetGadgetItemColor(gadget,i,#PB_Gadget_FrontColor,$000080) : SetGadgetItemColor(gadget,i,#PB_Gadget_BackColor,$B5E4FF)
    Else : SetGadgetItemColor(gadget,i,#PB_Gadget_FrontColor,$FAFAFF) : SetGadgetItemColor(gadget,i,#PB_Gadget_BackColor,$1A1A8B)
    EndIf 
    
    i=i+1
  Wend  
  CloseDatabase(#basedatos)
  StatusBarText(#barra_estado,0,"Busqueda finalizada")
EndProcedure

Procedure limpiar_venta()
  If CountGadgetItems(#lista_venta)=0
    MessageRequester("Error","La lista de venta se encuentra vacia",#PB_MessageRequester_Error)
  Else
    For i=0 To CountGadgetItems(#lista_venta)-1
      SetGadgetState(#lista_venta,i)
      producto.s=GetGadgetText(#lista_venta)
      OpenDatabase(#basedatos, dbname, user, pass)
      DatabaseQuery(#basedatos,"SELECT stock FROM productos WHERE nombre='" + producto + "'")
      NextDatabaseRow(#basedatos)
      stock=GetDatabaseLong(#basedatos,0)
      OpenDatabase(#basedatos,dbname, user, pass)
      If DatabaseUpdate(#basedatos,"UPDATE productos SET stock=" + Str(stock+1) + " WHERE nombre='" + producto + "'")
      EndIf 
    Next
    actualizar_lista_stock(#lista_stock,GetGadgetText(#combo_stock))
    If IsWindow(#ventana_stock) : actualizar_lista_stock(#lista_stock_ventana,GetGadgetText(#combo_stock_ventana)) : EndIf 
  EndIf 
  ClearGadgetItems(#lista_venta)
  StatusBarText(#barra_estado,0,"Lista borrada, stock actualizado")
EndProcedure

Procedure ventana_stock() ; ventana de stock para agregar a la lista de venta
  
  OpenWindow(#ventana_stock, 200,100, 570, 560, "Gestion de Stock", #PB_Window_SystemMenu)
  TextGadget(#PB_Any, 20, 80, 130, 25, "Busqueda de Producto:  ", #PB_Text_Right)
  StringGadget(#text_busqueda_ventana, 150, 80, 190, 25, "")
  ButtonGadget(#boton_buscar_stock_ventana, 350, 80, 100, 25, "Buscar")
  TextGadget(#PB_Any, 30, 40, 110, 25, "Filtro:  ", #PB_Text_Right)
  ComboBoxGadget(#combo_stock_ventana, 160, 40, 150, 25)
  ListIconGadget(#lista_stock_ventana, 20, 120, 540, 430, "Descripcion", 200, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#lista_stock_ventana, 1, "Categoria", 150)
  AddGadgetColumn(#lista_stock_ventana, 2, "Precio", 100)
  AddGadgetColumn(#lista_stock_ventana, 3, "Stock", 80)
  TextGadget(#PB_Any, 60, 10, 310, 25, "Agregar Productos a la venta")
  AddKeyboardShortcut(#ventana_stock, #PB_Shortcut_Return, #intro_stock)
  
  AddGadgetItem(#combo_stock_ventana,-1,limpiar_filtro)
  ForEach lista_categorias()
    AddGadgetItem(#combo_stock_ventana,-1,lista_categorias())
  Next
  SetGadgetState(#combo_stock_ventana,0)
  
  actualizar_lista_stock(#lista_stock_ventana,limpiar_filtro)
  Repeat
    event=WindowEvent()
    Select event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_stock)
      Case #PB_Event_Gadget
        Select EventGadget()
            
          Case #text_busqueda_ventana
            If EventType()=#PB_EventType_Focus : stringactive=#True : EndIf 
            If EventType()=#PB_EventType_LostFocus : stringactive=#False  : EndIf 
            
          Case #boton_buscar_stock_ventana 
            busqueda_bdd(#lista_stock_ventana,GetGadgetText(#text_busqueda_ventana))
            SetGadgetState(#combo_stock_ventana,0)
            
          Case #combo_stock_ventana
            actualizar_lista_stock(#lista_stock_ventana,GetGadgetText(#combo_stock_ventana))
            
          Case #lista_stock_ventana
            If EventType()=#PB_EventType_LeftDoubleClick And GetGadgetState(#lista_stock_ventana)>=0
              producto.s=GetGadgetText(#lista_stock_ventana)
              If OpenDatabase(#basedatos,dbname, user, pass)
                DatabaseQuery(#basedatos,"SELECT * FROM productos where nombre='" + producto + "'")
                NextDatabaseRow(#basedatos)
                stock=GetDatabaseLong(#basedatos,3)
                If GetDatabaseLong(#basedatos,3)>0
                  AddElement(lista_venta()) : lista_venta()\producto=GetDatabaseString(#basedatos,0) : lista_venta()\categoria=GetDatabaseString(#basedatos,1)
                  lista_venta()\precio=GetDatabaseDouble(#basedatos,2)
                  AddGadgetItem(#lista_venta,-1, lista_venta()\producto + Chr(10) + lista_venta()\categoria + Chr(10) + lista_venta()\precio)
                  total=total+lista_venta()\precio
                  SetGadgetText(#total_venta,Str(total))
                  OpenDatabase(#basedatos,dbname,user,pass)
                  DatabaseUpdate(#basedatos,"UPDATE productos SET stock=" + Str(stock-1) + " WHERE nombre='" + producto + "'")
                  actualizar_lista_stock(#lista_stock_ventana,GetGadgetText(#combo_stock_ventana))
                  actualizar_lista_stock(#lista_stock,GetGadgetText(#combo_stock))
                  SetGadgetItemColor(#lista_venta, CountGadgetItems(#lista_venta)-1,#PB_Gadget_BackColor, $90EE90)
                Else
                  MessageRequester("Atencion","El producto seleccionado no tiene STOCK",#PB_MessageRequester_Warning)
                EndIf 
              EndIf 
            EndIf 
            
          Case #eliminar_producto_venta 
            indice=GetGadgetState(#lista_venta)
            Debug indice
            If GetGadgetText(#lista_venta)=""
              MessageRequester("Atencion","No seleccionaste ningun producto para eliminar",#PB_MessageRequester_Info)
            Else
              If OpenDatabase(#basedatos,dbname, user, pass) 
                If DatabaseQuery(#basedatos,"SELECT * FROM productos WHERE nombre='" + GetGadgetText(#lista_venta) +"'" )
                  While NextDatabaseRow(#basedatos)
                    stock=GetDatabaseLong(#basedatos,3)
                  Wend
                EndIf
                If DatabaseUpdate(#basedatos, "UPDATE productos SET stock=" + Str(stock+1) + " WHERE nombre='" + GetGadgetText(#lista_venta) + "'")
                Else 
                  MessageRequester("",DatabaseError())
                EndIf 
                actualizar_lista_stock(#lista_stock,limpiar_filtro)
                actualizar_lista_stock(#lista_stock_ventana,GetGadgetText(#combo_stock_ventana))
                SelectElement(lista_venta(),indice)
                DeleteElement(lista_venta())
                RemoveGadgetItem(#lista_venta,GetGadgetState(#lista_venta))
                ForEach lista_venta() : Debug lista_venta()\producto : Next 
                MessageRequester("Atencion","Producto eliminado satisfactoriamente")
              Else 
                MessageRequester("Error al abrir base de datos",DatabaseError())
              EndIf 
            EndIf 
            
            Case #boton_limpiar_venta
            limpiar_venta()
        EndSelect
      Case #PB_Event_Menu
        Select EventMenu()
          Case #intro_stock
            If stringactive=#True : busqueda_bdd(#lista_stock_ventana,GetGadgetText(#text_busqueda_ventana)) : SetGadgetState(#combo_stock_ventana,0)  : EndIf 
            
        EndSelect
        
    EndSelect
  Until event=#PB_Event_CloseWindow
  
EndProcedure

Procedure ventana_ayuda() ;del menu de ayuda-acerca de
  OpenWindow(#ventana_ayuda, 0, 0, 400, 210, "Acerca de", #PB_Window_ScreenCentered | #PB_Window_SystemMenu)
  TextGadget(#PB_Any, 30, 20, 300, 20, "Gestion de Ventas y Stock con SQL v1.0")
  TextGadget(#PB_Any, 30, 50, 160, 20, "Rodry Ramirez (c) 2024")
  TextGadget(#PB_Any, 30, 80, 160, 20, "rodrymza@gmail.com")
  TextGadget(#PB_Any, 30, 110, 190, 20, "Curso Programacion Profesional")
  TextGadget(#PB_Any, 30, 140, 190, 20, "Profesor: Ricardo Ponce")
  Repeat  
    event.l= WindowEvent()
    Select Event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_ayuda)
    EndSelect
  Until event= #PB_Event_CloseWindow
EndProcedure

Procedure actualizar_historial()
  ClearGadgetItems(#historial_ventas)
  OpenDatabase(#basedatos, dbname, user, pass)
  DatabaseQuery(#basedatos, "SELECT * FROM ventas")
  While NextDatabaseRow(#basedatos)
    lineas=CountString(GetDatabaseString(#basedatos,4),#LF$)
    For i=1 To lineas
      texto.s=texto + StringField(GetDatabaseString(#basedatos,4),i,#LF$) + " - "
    Next
    AddGadgetItem(#historial_ventas,-1, GetDatabaseString(#basedatos,1) + Chr(10) + GetDatabaseString(#basedatos,2) + Chr(10) + "$ " + Str(GetDatabaseLong(#basedatos,3)) + Chr(10) + texto)
    texto=""
  Wend  
  CloseDatabase(#basedatos)
EndProcedure

Procedure guardarventa() ; guardar la venta actual, reinicia la varialbe total a 0 ya que es global
    AddElement(ventas_generales())
    ventas_generales()\fecha=FormatDate("%yyyy/%mm/%dd",Date())
    ventas_generales()\descripcion=InputRequester("Descripcion venta","Ingrese descripcion de venta","Consumidor Final ") + FormatDate("%hh:%ii:%ss", Date())
    ventas_generales()\total=Val(GetGadgetText(#total_venta))
    ;Debug ventas_generales()\fecha + " " + ventas_generales()\descripcion + " " + ventas_generales()\total
    OpenDatabase(#basedatos,dbname, user, pass)
    If DatabaseUpdate(#basedatos, "INSERT INTO ventas (fecha, descripcion, total, ticket) VALUES ('" + ventas_generales()\fecha +"', '" + ventas_generales()\descripcion + "' ," + ventas_generales()\total + ", '" + generarticket() + "')")
    Else
      MessageRequester("",DatabaseError())
    EndIf
    total=0
    actualizar_historial()
EndProcedure

Procedure producto_manual()
  
    OpenWindow(#ventana_producto_manual, x, y, 430, 170, "Agregar Producto Manual", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(#PB_Any, 50, 30, 100, 25, "Descripcion")
  TextGadget(#PB_Any, 50, 70, 100, 25, "Monto")
  StringGadget(#descripcion_manual, 140, 30, 240, 25, "")
  StringGadget(#monto_manual, 140, 70, 150, 25, "", #PB_String_Numeric)
  ButtonGadget(#aceptar_manual, 250, 120, 140, 25, "Aceptar")
  
  Repeat
    event = WindowEvent()
    Select event 
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_producto_manual)
        
        Case #PB_Event_Gadget : Select EventGadget()
          Case #aceptar_manual
            AddGadgetItem(#lista_venta,-1,GetGadgetText(#descripcion_manual) + Chr(10) + "Otros" + Chr(10) + GetGadgetText(#monto_manual))
            AddElement(lista_venta()) : lista_venta()\producto=GetGadgetText(#descripcion_manual) : lista_venta()\categoria="Otros" : lista_venta()\precio=Val(GetGadgetText(#monto_manual))
            CloseWindow(#ventana_producto_manual)
            quit=#True
    EndSelect : EndSelect
    Until event=#PB_Event_CloseWindow Or quit=#True
EndProcedure



MessageRequester("Atencion","Esta es una version experimental, pueden existir errores")

OpenWindow(#main_window, 0, 0, 590, 790, "Gestion de Stock y Ventas", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CreateMenu(#menu_ventana, WindowID(#main_window))
MenuTitle("Archivo")
MenuItem(#acerca_de,"Acerca de")
PanelGadget(#panel_principal, 10, 48, 570, 692)

AddGadgetItem(#panel_principal, -1, "Control de Stock", 0, 1)
TextGadget(#PB_Any, 240, 10, 110, 25, "Filtro:  ", #PB_Text_Right)
ButtonGadget(#nuevo_producto, 20, 620, 120, 40, "Nuevo Producto")
ButtonGadget(#eliminar_producto, 160, 620, 120, 40, "Eliminar Producto")
ButtonGadget(#modificar_producto, 300, 620, 120, 40, "Modificar Producto")
ButtonGadget(#cambiar_stock, 440, 620, 120, 40, "Cambiar Stock")
ListIconGadget(#lista_stock, 20, 78, 540, 532, "Descripcion", 200, #PB_ListIcon_GridLines | #PB_ListIcon_FullRowSelect)
AddGadgetColumn(#lista_stock, 1, "Categoria", 150)
AddGadgetColumn(#lista_stock, 2, "Precio", 100)
AddGadgetColumn(#lista_stock, 3, "Stock", 80)
ComboBoxGadget(#combo_stock, 360, 10, 150, 25)
ButtonGadget(#boton_buscar, 360, 40, 100, 25, "Buscar")
StringGadget(#text_busqueda, 160, 40, 190, 25, "")
TextGadget(#PB_Any, 20, 40, 130, 25, "Busqueda de Producto:  ", #PB_Text_Right)
TextGadget(#PB_Any, 20, 10, 180, 25, "Control de Stock de Productos")

AddGadgetItem(#panel_principal, -1, "Gestion de Ventas")
ButtonGadget(#boton_manual, 30, 570, 140, 25, "Agregar Personalizado")
SetGadgetItemColor(#panel_principal,0,#PB_Gadget_FrontColor,$90EE90)
TextGadget(#PB_Any, 330, 570, 80, 25, "Total           $")
ButtonGadget(#guardar_venta, 380, 610, 130, 45, "Guardar Venta")
TextGadget(#total_venta, 430, 570, 80, 25, "0", #PB_Text_Center)
ButtonGadget(#eliminar_producto_venta, 220, 620, 140, 35, "Eliminar Producto")
ButtonGadget(#agregar_producto_venta, 60, 620, 140, 35, "Agragar Producto")
ListIconGadget(#lista_venta, 20, 60, 490, 500, "Producto", 200, #PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines)
AddGadgetColumn(#lista_venta, 1, "Categoria", 150)
AddGadgetColumn(#lista_venta, 2, "Precio", 120)
TextGadget(#PB_Any, 20, 20, 230, 30, "Nueva Venta", #PB_Text_Center)
ButtonGadget(#boton_limpiar_venta, 380, 20, 130, 25, "Limpiar Venta")


AddGadgetItem(#panel_principal, -1, "Administrar Categorias", 0, 2)
ListViewGadget(#lista_categorias, 30, 60, 290, 210)
TextGadget(#PB_Any, 40, 20, 180, 30, "Administracion de Categorias")
ButtonGadget(#boton_nueva_categoria, 40, 290, 120, 40, "Nueva")
ButtonGadget(#boton_eliminar_categoria, 180, 290, 120, 40, "Eliminar")
TextGadget(#PB_Any, 50, 350, 230, 25, "Historial de ventas")
ListIconGadget(#historial_ventas, 10, 380, 530, 270, "Fecha", 80,#PB_ListIcon_FullRowSelect | #PB_ListIcon_GridLines | #PB_ListIcon_HeaderDragDrop)
AddGadgetColumn(#historial_ventas, 1, "Descripcion", 170)
AddGadgetColumn(#historial_ventas, 2, "Total", 80)
AddGadgetColumn(#historial_ventas, 3, "Detalle", 190)
CloseGadgetList()
TextGadget(#PB_Any, 30, 10, 300, 25, "Centro de Ventas y Stock")
CreateStatusBar(#barra_estado, WindowID(#main_window))
AddStatusBarField(500)
AddKeyboardShortcut(#main_window,#PB_Shortcut_Return,#intro_pricipal)

leer_categorias()
ClearGadgetItems(#lista_categorias) : ForEach lista_categorias() : AddGadgetItem(#lista_categorias, -1, lista_categorias()) : Next
actualizar_lista_stock(#lista_stock,limpiar_filtro)
AddGadgetItem(#combo_stock,-1,limpiar_filtro)
ForEach lista_categorias()
  AddGadgetItem(#combo_stock,-1,lista_categorias())
Next
SetGadgetState(#combo_stock,0)

actualizar_lista_stock(#lista_stock,limpiar_filtro)
actualizar_historial()

Repeat  
  event=WindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_buscar
            busqueda_bdd(#lista_stock,GetGadgetText(#text_busqueda))
            SetGadgetState(#combo_stock,0)
            
          Case #text_busqueda
            If EventType()=#PB_EventType_Focus : stringactive=#True : EndIf 
            If EventType()=#PB_EventType_LostFocus : stringactive=#False  : EndIf
            
          Case #boton_nueva_categoria
            texto.s="'" + InputRequester("Nueva Categoria","Ingrese el nombre de la nueva categoria","") + "'"
            If Len(texto)>4
              comando_sql.s="INSERT INTO categorias (descripcion) VALUES (" + texto + ")"
              mensaje.s="Categoria agregada con exito"
              actualizar_basedatos(comando_sql,mensaje)
              ClearGadgetItems(#lista_categorias) : ForEach lista_categorias() : AddGadgetItem(#lista_categorias, -1, lista_categorias()) : Next
            Else 
              MessageRequester("Error","Nombre de categoria no valido",#PB_MessageRequester_Error)
            EndIf 
            
          Case #boton_manual
            producto_manual()
            
          Case #boton_eliminar_categoria
            comando_sql.s="DELETE FROM categorias WHERE descripcion=" + "'" + GetGadgetText(#lista_categorias) + "'"
            mensaje.s="Categoria '" + GetGadgetText(#lista_categorias) + "' eliminada satisfactoriamente"
            actualizar_basedatos(comando_sql,mensaje)
            ClearGadgetItems(#lista_categorias) : ForEach lista_categorias() : AddGadgetItem(#lista_categorias, -1, lista_categorias()) : Next
            
          Case #nuevo_producto
            ventana_modificar(nuevo_producto, "Agregar")
            
          Case #modificar_producto
            If GetGadgetText(#lista_stock)=""
              MessageRequester("ATENCION","No seleccionaste ningun producto",#PB_MessageRequester_Error)
            Else
              ventana_modificar(GetGadgetText(#lista_stock),"Modificar")
            EndIf 
            
          Case #eliminar_producto
            If GetGadgetText(#lista_stock)<>""
              
              result=MessageRequester("ATENCION","Se va a proceder a borrar el producto '" + GetGadgetText(#lista_stock) + "'", #PB_MessageRequester_YesNo)
              If result=#PB_MessageRequester_Yes
                OpenDatabase(#basedatos,dbname, user, pass)
                If DatabaseUpdate(#basedatos,"DELETE FROM productos WHERE nombre='" + GetGadgetText(#lista_stock) + "'")
                  actualizar_lista_stock(#lista_stock,limpiar_filtro)
                
                  MessageRequester("Exito","Producto borrado satisfactoriamante")
              
                Else
                  MessageRequester("Error", DatabaseError())
                EndIf 
              EndIf 
            Else 
              MessageRequester("Atencion","No selecciono ningun producto a eliminar",#PB_MessageRequester_Info)
            EndIf
          
          Case #combo_stock
            actualizar_lista_stock(#lista_stock,GetGadgetText(#combo_stock))
            
          Case #cambiar_stock
            If GetGadgetText(#lista_stock)=""
              MessageRequester("ERROR","No seleccionaste ningun producto",#PB_MessageRequester_Info)
            Else
              Repeat
                stock=Val(InputRequester("Cambio de stock","Ingresa el stock actual de " + GetGadgetText(#lista_stock),""))
                If stock<=0 : MessageRequester("Error","Ingresa al menos 1") : EndIf
              Until stock>=1
              OpenDatabase(#basedatos,dbname, user, pass)
              DatabaseUpdate(#basedatos,"UPDATE productos SET stock=" + stock + " WHERE nombre='" + GetGadgetText(#lista_stock) + "'")
              actualizar_lista_stock(#lista_stock,limpiar_filtro)
              StatusBarText(#barra_estado,0,"Stock modificado")
            EndIf 
            
          Case #agregar_producto_venta
            ventana_stock()
            
          Case #eliminar_producto_venta
            indice=GetGadgetState(#lista_venta)
            If GetGadgetText(#lista_venta)=""
              MessageRequester("Atencion","No seleccionaste ningun producto para eliminar",#PB_MessageRequester_Info)
            Else
              If OpenDatabase(#basedatos,dbname, user, pass) 
                If DatabaseQuery(#basedatos,"SELECT * FROM productos WHERE nombre='" + GetGadgetText(#lista_venta) +"'" )
                  While NextDatabaseRow(#basedatos)
                    stock=GetDatabaseLong(#basedatos,3)
                  Wend
                EndIf
                If DatabaseUpdate(#basedatos, "UPDATE productos SET stock=" + Str(stock+1) + " WHERE nombre='" + GetGadgetText(#lista_venta) + "'")
                Else 
                  MessageRequester("",DatabaseError())
                EndIf 
                actualizar_lista_stock(#lista_stock,limpiar_filtro)
                RemoveGadgetItem(#lista_venta,GetGadgetState(#lista_venta))
                SelectElement(lista_venta(),indice)
                DeleteElement(lista_venta())
                ForEach lista_venta() : Debug lista_venta()\producto : Next
                MessageRequester("Atencion","Producto borrado de la lista de venta")
              Else 
                MessageRequester("Error al abrir base de datos",DatabaseError())
              EndIf 
            EndIf 
            
          Case #guardar_venta
            result=MessageRequester("Atencion","Desea finalizar la compra?",#PB_MessageRequester_YesNo)
            If result=#PB_MessageRequester_Yes 
              guardarventa()
              ClearGadgetItems(#lista_venta)
              StatusBarText(#barra_estado,0,"Venta finalizada")
            EndIf 
            
          Case #boton_limpiar_venta
            limpiar_venta()
         

        EndSelect
      Case #PB_Event_Menu
        Select EventMenu()
          Case #intro_pricipal
            If stringactive=#True : busqueda_bdd(#lista_stock,GetGadgetText(#text_busqueda)) : SetGadgetState(#combo_stock,0): EndIf 
          Case #acerca_de
            ventana_ayuda()
        EndSelect
    EndSelect
  Until event=#PB_Event_CloseWindow

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 215
; FirstLine = 58
; Folding = AD-
; EnableXP
; HideErrorLog