Enumeration
  #main_window
  #mesa_1
  #mesa_2
  #mesa_3
  #mesa_4
  #mesa_5
  #mesa_6
  #mesa_7
  #mesa_8
  #texto_titulo
  #lista_pedido_mesa
  #totalMesa
  #anadir_item
  #eliminar_item
  #ventana_mesa
  #lista_pedido
  #buscar_pedido
  #combo_tomarpedido
  #ventana_pedido
  #base_datos
  #boton_anadir
  #descripcion_anadir
  #precio_anadir
  #lista_anadir
  #ventana_anadir
  #agregar_elemento
    #lista_ver_menu
  #filtro_ver_menu
  #agregar_lista_menu
  #modificar_lista_menu
  #eliminar_lista_menu
  #ventana_lista_menu
  #ver_lista_menu
EndEnumeration

Structure pedido
  descripcion.s
  precio.l
  cantidad.l
EndStructure

Structure datos
  descripcion.s
  categoria.s
  precio.l
EndStructure

UseMySQLDatabase()
Global principal.s="Principales", entrada.s="Entradas", bebida.s="Bebidas", postre.s="Postres"

Global NewList menu.datos()

;variables Base de datos
Global user.s="rodry"
Global dbname.s="rodry_datos"
Global dbname.s="host=localhost port=3306 dbname=" + dbname
Global pass.s="rodry1234"

NewList mesa_1.pedido() : NewList mesa_2.pedido() : NewList mesa_3.pedido() : NewList mesa_4.pedido()
NewList mesa_5.pedido() : NewList mesa_6.pedido() : NewList mesa_7.pedido() : NewList mesa_8.pedido()

Procedure adquirirdatos()
  If OpenDatabase(#base_datos,dbname,user,pass)
    DatabaseQuery(#base_datos,"SELECT * FROM bdd_menu ORDER BY categoria")
    While NextDatabaseRow(#base_datos)
      AddElement(menu())
      menu()\descripcion=GetDatabaseString(#base_datos,0)
      menu()\categoria=GetDatabaseString(#base_datos,1)
      menu()\precio=GetDatabaseLong(#base_datos,2)
    Wend
    FinishDatabaseQuery(#base_datos)
    CloseDatabase(#base_datos)
  EndIf 
EndProcedure


Procedure actualizar_lista()
  ClearGadgetItems(#lista_pedido)
  ForEach menu()
    If menu()\categoria=GetGadgetText(#combo_tomarpedido)
      AddGadgetItem(#lista_pedido,-1,Str(ListIndex(menu())) + Chr(10) + menu()\descripcion + Chr(10) + menu()\categoria + Chr(10) + Str(menu()\precio))
    ElseIf GetGadgetText(#combo_tomarpedido)="Todos"
      AddGadgetItem(#lista_pedido,-1,Str(ListIndex(menu())) + Chr(10) + menu()\descripcion + Chr(10) + menu()\categoria + Chr(10) + Str(menu()\precio))
      
    EndIf
  Next
EndProcedure

Procedure actualizar_mesa(List mesa.pedido())
  ClearGadgetItems(#lista_pedido_mesa)
  ForEach mesa()
    AddGadgetItem(#lista_pedido_mesa,-1,mesa()\descripcion + Chr(10) + Str(mesa()\cantidad) + Chr(10) + Str(mesa()\precio) + Chr(10) + Str(mesa()\precio * mesa()\cantidad))
    total= total + mesa()\precio * mesa()\cantidad
  Next
  SetGadgetText(#totalMesa,"$   " + Str(total))
EndProcedure

Procedure tomarPedido(List mesa.pedido())
  
  OpenWindow(#ventana_pedido, 0, 0, 370, 410, "Tomar pedido a mesa", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(#PB_Any, 20, 20, 330, 25, "Agregar al Pedido", #PB_Text_Center)
  TextGadget(#PB_Any, 10, 60, 70, 25, "Categoria")
  ComboBoxGadget(#combo_tomarpedido, 80, 55, 160, 25)
  ListIconGadget(#lista_pedido, 10, 120, 350, 280, "Id", 30,#PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#lista_pedido, 1, "Descripcion", 140)
  AddGadgetColumn(#lista_pedido, 2, "Categoria", 95)
  AddGadgetColumn(#lista_pedido, 3, "Precio", 80)
  StringGadget(#PB_Any, 90, 90, 170, 25, "")
  TextGadget(#PB_Any, 10, 90, 70, 25, "Buscar")
  ButtonGadget(#buscar_pedido, 270, 90, 80, 25, "Buscar")
  AddGadgetItem(#combo_tomarpedido,-1,"Todos") : AddGadgetItem(#combo_tomarpedido,-1,entrada) :  AddGadgetItem(#combo_tomarpedido,-1,principal) :   AddGadgetItem(#combo_tomarpedido,-1,bebida) :   AddGadgetItem(#combo_tomarpedido,-1,postre)
  SetGadgetState(#combo_tomarpedido,0)
  
  actualizar_lista()
  
  Repeat 
    event= WindowEvent()
    Select event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_pedido)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #combo_tomarpedido
            actualizar_lista()
          Case #lista_pedido
            repetido=0
            If EventType()=#PB_EventType_LeftDoubleClick
              SelectElement(menu(),Val(GetGadgetText(#lista_pedido)))
              ForEach mesa()
                If menu()\descripcion=mesa()\descripcion
                  repetido=1
                  index=ListIndex(mesa())
                  Break
                EndIf
              Next
              If repetido=1
                SelectElement(mesa(),index)
                mesa()\cantidad=mesa()\cantidad+1
              Else
                AddElement(mesa())
                mesa()\descripcion=menu()\descripcion
                mesa()\precio=menu()\precio
                mesa()\cantidad=1
              EndIf 
              actualizar_mesa(mesa())
            EndIf           
        EndSelect
        
    EndSelect
    
  Until event=#PB_Event_CloseWindow
  
EndProcedure

Procedure ventana_mesa(List mesa.pedido(),numero_mesa)
  
  OpenWindow(#ventana_mesa, 0, 0, 400, 460, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(#texto_titulo, 50, 20, 100, 25, "Mesa " + Str(numero_mesa))
  ListIconGadget(#lista_pedido_mesa, 20, 60, 360, 310, "Descripcion", 130,#PB_ListIcon_FullRowSelect)
  AddGadgetColumn(#lista_pedido_mesa, 1, "Cantidad", 70)
  AddGadgetColumn(#lista_pedido_mesa, 2, "Unitario", 60)
  AddGadgetColumn(#lista_pedido_mesa, 3, "Total", 80)
  TextGadget(#PB_Any, 190, 380, 100, 25, "Total Mesa")
  TextGadget(#totalMesa, 290, 380, 80, 25, "$total", #PB_Text_Right)
  ButtonGadget(#anadir_item, 50, 420, 130, 25, "Agrregar Item")
  ButtonGadget(#eliminar_item, 210, 420, 130, 25, "Eliminar Item")
  
  actualizar_mesa(mesa())
  Repeat 
  event= WindowEvent()
  Select event
    Case #PB_Event_CloseWindow
      CloseWindow(#ventana_mesa)
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #anadir_item
          tomarPedido(mesa())
        Case #eliminar_item
          If GetGadgetState(#lista_pedido_mesa)>=0 : valor=GetGadgetState(#lista_pedido_mesa)
            SelectElement(mesa(),GetGadgetState(#lista_pedido_mesa))
            If mesa()\cantidad>1
              mesa()\cantidad=mesa()\cantidad-1
              actualizar_mesa(mesa())
              SetGadgetState(#lista_pedido_mesa,valor)
            Else
              DeleteElement(mesa())
              actualizar_mesa(mesa())
            EndIf
          Else 
            MessageRequester("Atencion","No selecciono ningun elemento",#PB_MessageRequester_Info)
          EndIf 
      EndSelect
  EndSelect
Until event=#PB_Event_CloseWindow

EndProcedure

Procedure actualizar_ventana_menu(label.s)
  ClearGadgetItems(#lista_ver_menu)
  ForEach menu()
    If label="Limpiar filtro"
      AddGadgetItem(#lista_ver_menu,-1,Str(ListIndex(menu())) + Chr(10) + menu()\descripcion + Chr(10) + menu()\categoria + Chr(10) + "$  " + Str(menu()\precio))
    Else
      If label=menu()\categoria
        AddGadgetItem(#lista_ver_menu,-1,Str(ListIndex(menu())) + Chr(10) + menu()\descripcion + Chr(10) + menu()\categoria + Chr(10) + "$  " + Str(menu()\precio))
      EndIf
    EndIf
      Next
    EndProcedure

Procedure anadir_elemento()
  
  OpenWindow(#ventana_anadir, 0, 0, 390, 280, "Agragar elemento al menu", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
  TextGadget(#PB_Any, 40, 90, 100, 25, "Descripcion")
  StringGadget(#descripcion_anadir, 150, 90, 190, 25, "")
  TextGadget(#PB_Any, 30, 30, 330, 25, "Agregar menu", #PB_Text_Center)
  TextGadget(#PB_Any, 40, 130, 100, 25, "Categoria")
  TextGadget(#PB_Any, 40, 170, 100, 25, "Precio")
  ComboBoxGadget(#lista_anadir, 150, 130, 160, 25)
  StringGadget(#precio_anadir, 150, 170, 110, 25, "")
  ButtonGadget(#boton_anadir, 220, 220, 100, 25, "Guardar")
  
  AddGadgetItem(#lista_anadir,-1,entrada)
  AddGadgetItem(#lista_anadir,-1,principal)
  AddGadgetItem(#lista_anadir,-1,bebida)
  AddGadgetItem(#lista_anadir,-1,postre)
  
  Repeat 
    event=WindowEvent()
    Select event
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_anadir)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #boton_anadir
            descripcion.s=GetGadgetText(#descripcion_anadir)
            categoria.s=GetGadgetText(#lista_anadir)
            precio.l=Val(GetGadgetText(#precio_anadir))
            If descripcion="" Or categoria="" Or precio=0
              MessageRequester("Error","Falta completar campos")
            Else
              
              If OpenDatabase(#base_datos,dbname,user,pass)
                DatabaseQuery(#base_datos,"INSERT INTO bdd_menu (descripcion, categoria, precio) VALUES ('" + descripcion + "', '" + categoria + "', " + precio + ")")
                MessageRequester("Atencion","Elemento agregado exitosamente")
                SetGadgetText(#descripcion_anadir,"") : SetGadgetState(#lista_anadir,-1) : SetGadgetText(#precio_anadir,"")
              EndIf 
            EndIf
            adquirirdatos()
            If IsWindow(#ventana_lista_menu) : actualizar_ventana_menu(GetGadgetText(#filtro_ver_menu)) : EndIf 
        EndSelect
    EndSelect
    
  Until event = #PB_Event_CloseWindow
EndProcedure

Procedure ventana_lista_menu()
  
  OpenWindow(#ventana_lista_menu, 0, 0, 480, 510, "Elementos del menu", #PB_Window_SystemMenu | #PB_Window_ScreenCentered )
  TextGadget(#PB_Any, 60, 30, 100, 20, "Carta", #PB_Text_Center)
  ListIconGadget(#lista_ver_menu, 30, 120, 420, 320, "ID", 50)
  AddGadgetColumn(#lista_ver_menu, 1, "Descripcion", 170)
  AddGadgetColumn(#lista_ver_menu, 2, "Categoria", 110)
  AddGadgetColumn(#lista_ver_menu, 3, "Precio", 80)
  TextGadget(#PB_Any, 60, 80, 100, 25, "")
  ComboBoxGadget(#filtro_ver_menu, 180, 80, 160, 25)
  ButtonGadget(#agregar_lista_menu, 30, 460, 110, 25, "Agregar")
  ButtonGadget(#modificar_lista_menu, 180, 460, 110, 25, "Modificar")
  ButtonGadget(#eliminar_lista_menu, 320, 460, 110, 25, "Eliminar")
  AddGadgetItem(#filtro_ver_menu, -1, "Limpiar filtro") :AddGadgetItem(#filtro_ver_menu, -1, entrada) : AddGadgetItem(#filtro_ver_menu, -1, principal) : AddGadgetItem(#filtro_ver_menu, -1, bebida) : AddGadgetItem(#filtro_ver_menu, -1, postre) 
  SetGadgetState(#filtro_ver_menu,0)
  actualizar_ventana_menu(GetGadgetText(#filtro_ver_menu))
  
  
  Repeat 
    event=WindowEvent()
    Select event 
      Case #PB_Event_CloseWindow
        CloseWindow(#ventana_lista_menu)
      Case #PB_Event_Gadget
        Select EventGadget()
          Case #filtro_ver_menu
            actualizar_ventana_menu(GetGadgetText(#filtro_ver_menu))
          Case #agregar_lista_menu
            anadir_elemento()
            
        EndSelect
    EndSelect
  Until event=#PB_Event_CloseWindow
  
EndProcedure


OpenWindow(#main_window, 0,0, 610, 350, "", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
CreateMenu(#PB_Any, WindowID(#main_window))
MenuTitle("Menu")
MenuItem(#agregar_elemento,"Agregar elemento al menu")
MenuItem(#ver_lista_menu,"Ver elementos del menu")
TextGadget(#PB_Any, 60, 80, 100, 25, "Mesas")
ButtonGadget(#mesa_1, 50, 130, 100, 40, "Mesa 1" )
ButtonGadget(#mesa_2, 190, 130, 100, 40, "Mesa 2")
ButtonGadget(#mesa_3, 330, 130, 100, 40, "Mesa 3")
ButtonGadget(#mesa_4, 460, 130, 100, 40, "Mesa 4")
ButtonGadget(#mesa_5, 50, 200, 100, 40, "Mesa 5")
ButtonGadget(#mesa_6, 190, 200, 100, 40, "Mesa 6")
ButtonGadget(#mesa_7, 330, 200, 100, 40, "Mesa 7")
ButtonGadget(#mesa_8, 460, 200, 100, 40, "Mesa 8")

adquirirdatos()

Repeat 
  event= WindowEvent()
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #mesa_1
          ventana_mesa(mesa_1(),1)
        Case #mesa_2
          ventana_mesa(mesa_2(),2)
        Case #mesa_3
          ventana_mesa(mesa_3(),3)
        Case #mesa_4
          ventana_mesa(mesa_4(),4)
        Case #mesa_5
          ventana_mesa(mesa_5(),5)
        Case #mesa_6
          ventana_mesa(mesa_6(),6)
        Case #mesa_7
          ventana_mesa(mesa_7(),7)
        Case #mesa_8
          ventana_mesa(mesa_8(),8)
      EndSelect
    Case #PB_Event_Menu
      Select EventMenu()
        Case #agregar_elemento
          anadir_elemento()
        Case #ver_lista_menu
          ventana_lista_menu()
          
      EndSelect
      
  EndSelect
Until event=#PB_Event_CloseWindow

; IDE Options = PureBasic 6.11 LTS (Windows - x64)
; CursorPosition = 184
; FirstLine = 78
; Folding = x0
; EnableXP
; HideErrorLog
; Compiler = PureBasic 6.11 LTS (Windows - x64)