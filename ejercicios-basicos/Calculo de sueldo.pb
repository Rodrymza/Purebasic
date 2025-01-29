;implementar programa que haga el calculo de un sueldo

;sueldo = dias trabajados por importe unitario
;antiguedad = unidades * importe unitario
;presentismo = 10% del sueldo base
;jubilacion = 11% retencion
;ley 19032 = 3% retencion
;obra social = 2,55%
;fondo solidario = 0,45%

Enumeration
  #ventana_principal
  #horas_trabajadas
  #antiguedad
  #boton_consulta
  #combo_presentismo
EndEnumeration

unitario_sueldo=1333.33333
Define.f antiguedad_percent = 0.01, jubilacion = 0.11, ley_19032 = 0.03, obra_social = 0.0255 , fondo_solidario = 0.0045, valor_presentismo = 0.10000000, cuota_sindical = 0.02, sueldo_bruto

descuentos.f= jubilacion + ley_19032 + fondo_solidario + cuota_sindical + obra_social
Define.l horas_trabajadas, presentismo_bool

OpenWindow(#ventana_principal, 0, 0, 470, 280, "Calcular Sueldo", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
TextGadget(#PB_Any, 80, 80, 110, 25, "Horas trabajadas")
StringGadget(#horas_trabajadas, 200, 80, 130, 25, "", #PB_String_Numeric)
TextGadget(#PB_Any, 80, 120, 110, 25, "Antiguedad")
StringGadget(#antiguedad, 200, 120, 130, 25, "", #PB_String_Numeric)
TextGadget(#PB_Any, 80, 160, 110, 25, "Presentismo")
ComboBoxGadget(#combo_presentismo, 210, 160, 110, 25)
AddGadgetItem(#combo_presentismo, -1, "No")
AddGadgetItem(#combo_presentismo, -1, "Si", 0, 1)
ButtonGadget(#boton_consulta, 250, 230, 140, 25, "Generar Consulta")
TextGadget(#PB_Any, 110, 20, 200, 25, "Calculo de Sueldo", #PB_Text_Center)

Repeat 
  event = WindowEvent()
  Select Event
    Case #PB_Event_Gadget
      Select EventGadget()
        Case #boton_consulta
          horas_trabajadas=Val(GetGadgetText(#horas_trabajadas))
          total_por_hora = Round(horas_trabajadas * unitario_sueldo,#PB_Round_Nearest)
          antiguedad_unitario = Val(GetGadgetText(#antiguedad))
          antiguedad_total.f= (antiguedad_percent * antiguedad_unitario) * total_por_hora
          If GetGadgetState(#combo_presentismo)=1
            presentismo_total = (total_por_hora + antiguedad_total) * valor_presentismo
          Else
            presentismo_bool = 0
          EndIf 
          sueldo_bruto = total_por_hora + antiguedad_total + presentismo_total
          
          Debug "Total horas: " + total_por_hora
          Debug "Antiguedad :" + antiguedad_total
          Debug "Presentismo: " + presentismo_total
          
          sueldo_neto.f=sueldo_bruto - sueldo_bruto * descuentos
          
          Debug "Neto: " + StrF(sueldo_neto,2)
          Debug "Descuentos: " + StrF(sueldo_bruto*descuentos,2)
          Debug "Bruto: " + StrF(sueldo_bruto,2)
          
      EndSelect
  EndSelect
Until event = #PB_Event_CloseWindow
; IDE Options = PureBasic 6.10 LTS (Windows - x64)
; CursorPosition = 27
; FirstLine = 11
; EnableXP
; HideErrorLog