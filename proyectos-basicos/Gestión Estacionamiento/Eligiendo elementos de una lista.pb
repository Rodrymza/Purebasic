Enumeration
  #lista
  #boton
  #horaadquirida
  #ventanaprincipal
  #reloj
EndEnumeration

Dim lista.s(2)
lista(0)="rodry"
lista(1)="roci"
lista(2)="clara"
OpenWindow(#ventanaprincipal,0,0,260,180,"Ventana principal", #PB_Window_ScreenCentered)
AddWindowTimer(#ventanaprincipal,#reloj,1000)
ListViewGadget(#lista, 50, 20, 160, 25)
ButtonGadget(#boton, 80, 70, 100, 25, "Adquirir hora")
StringGadget(#horaadquirida, 80, 120, 140, 25, "")

For i=0 To ArraySize(lista())
  AddGadgetItem(#lista,-1,lista(i))
Next
Repeat
  event = WindowEvent()

  
  
  Select event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton
          For i=0 To ArraySize(lista())
            If lista(i)=GetGadgetText(#lista)
              SetGadgetText(#horaadquirida,"Elegiste el elemento " + Str(i))
            EndIf
            
          Next
            

      EndSelect
      
  EndSelect
Until event = #PB_Event_CloseWindow


; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 16
; EnableXP
; DPIAware