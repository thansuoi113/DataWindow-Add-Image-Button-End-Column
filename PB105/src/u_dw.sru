$PBExportHeader$u_dw.sru
forward
global type u_dw from datawindow
end type
end forward

global type u_dw from datawindow
integer width = 686
integer height = 400
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_find ( )
event dropdown pbm_dwndropdown
event ue_resize ( )
event lbuttonup pbm_lbuttonup
event type integer ue_changevisible ( string as_column )
end type
global u_dw u_dw

type variables
ou_dwcolumn_bmp inv_colun_bmp
end variables

forward prototypes
public function integer of_setcolumnbmp (boolean ab_true)
end prototypes

event ue_find();String PassedString

PassedString = String(Message.LongParm, "address")

Choose Case PassedString
	Case 'comp_code'
		MessageBox('Warning', PassedString) 
		//open(w_popo)
	Case 'comp_zip'
		MessageBox('Warning', PassedString)
		//open(w_response)
	Case Else
		MessageBox('','')
End Choose


end event

event dropdown;If IsValid(inv_colun_bmp) Then
	// Check if this a column that has the column bmp associated to it.
	If inv_colun_bmp.Event pfc_dropdown() = 1 Then
		// Column is a bmp  column.  Prevent listbox from appearing.
		Return 1
	End If
End If


end event

event ue_resize();If IsValid (inv_colun_bmp) Then
	inv_colun_bmp.Event pfc_lbuttonup ( )
End If

end event

event lbuttonup;PostEvent ('ue_resize')


end event

event type integer ue_changevisible(string as_column);If IsValid(inv_colun_bmp) Then
	If inv_colun_bmp.Event pfc_changevisible(as_column) = 1 Then
	End If
End If

Return 1

end event

public function integer of_setcolumnbmp (boolean ab_true);//====================================================================
// Function: u_dw.of_setcolumnbmp()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	value	boolean	ab_true	
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: u_dw.of_setcolumnbmp ( boolean ab_true )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

If ab_true Then
	If Not IsValid (inv_colun_bmp) Then
		inv_colun_bmp = Create ou_dwcolumn_bmp
	End If
	inv_colun_bmp.of_setrequestor( This )
Else
	If IsValid(inv_colun_bmp) Then
		Destroy inv_colun_bmp
		Return 1
	End If
	Return 0
End If

Return 1


end function

on u_dw.create
end on

on u_dw.destroy
end on

event constructor;//inv_colun_bmp.of_register( 'comp_code', 'pic\FIND_DW.BMP')   
//inv_colun_bmp.of_register( 'comp_zip', 'pic\test.gif')   


end event

event destructor;//of_setcolumnbmp (False)
end event

event itemfocuschanged;If IsValid(inv_colun_bmp) Then
	// Check if this a column that has the bmp column associated to it.
	If inv_colun_bmp.Event pfc_changevisible(dwo.Name) = 1 Then
		// Column is a bmp column.  Prevent listbox from appearing.
	End If
End If


end event

