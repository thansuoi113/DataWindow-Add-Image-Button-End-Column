$PBExportHeader$ou_dwcolumn_bmp.sru
forward
global type ou_dwcolumn_bmp from nonvisualobject
end type
end forward

global type ou_dwcolumn_bmp from nonvisualobject
event type integer pfc_lbuttonup ( )
event type integer pfc_dropdown ( )
event type integer pfc_changevisible ( string as_column )
end type
global ou_dwcolumn_bmp ou_dwcolumn_bmp

type variables
String is_dwcolumns[]
String is_imagepath[]
String is_event[] //Used to save the event corresponding to the registration column
String is_dwcolumnsexp[] //Save the original edit grid of each registered column
Integer ii_bord[] //The border type of the picture (button)
Integer ii_width[] //The width of the picture (button) ranges from 60 to 100. If it exceeds 100, take 100. If it is less than 60, take 60.
datawindow idw_requestor

end variables

forward prototypes
public function boolean of_isregistered (string as_dwcolumn)
public function integer of_create_object (long al_current_note)
public function integer of_resize ()
public function integer of_dropdown ()
public function integer of_changevisible (string as_column)
public function integer of_register (string as_dwcolumn, string as_image_path)
public function integer of_register (string as_dwcolumn, string as_image_path, string as_event)
public function integer of_register (string as_dwcolumn, string as_image_path, string as_event, integer ai_bord)
public function integer of_register (string as_dwcolumn, string as_image_path, string as_event, integer ai_bord, integer ai_width)
public function integer of_setrequestor (datawindow adw_requestor)
public function integer of_unregister (string as_dwcolumn)
public function integer of_unregister ()
end prototypes

event type integer pfc_lbuttonup();//When the left mouse button is released, reset the picture position

return  of_resize()

end event

event type integer pfc_dropdown();
return of_dropdown()

end event

event type integer pfc_changevisible(string as_column);

return of_changevisible(as_column)

end event

public function boolean of_isregistered (string as_dwcolumn);//====================================================================
// Function: ou_dwcolumn_bmp.of_isregistered()
//--------------------------------------------------------------------
// Description: This function is called to determine if the passed in  column name has already been registered with the service.
//					Function is only valid when serving a DataWindow control.
//--------------------------------------------------------------------
// Arguments:
// 	value	string	as_dwcolumn	The registered column to search for.
//--------------------------------------------------------------------
// Returns:  boolean True or False depending if the column is already registered.
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_isregistered ( string as_dwcolumn )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

integer	li_count
integer	li_i

// Check arguments
If IsNull(as_dwcolumn) Or Len(Trim(as_dwcolumn))=0 Then 
	Return False
End If

// Validate the references.
If IsNull(idw_requestor) or Not IsValid(idw_requestor) Then
	Return False
End If

// Trim and Convert to lower case.
as_dwcolumn = Trim(Lower(as_dwcolumn))

// Find column name.
li_count = upperbound(is_dwcolumns)
For li_i=1 To li_count
	If is_dwcolumns[li_i] = as_dwcolumn THEN
		// Column name was found.
		Return True
	end if
Next

// Column name not found in array.
Return False
end function

public function integer of_create_object (long al_current_note);//====================================================================
// Function: ou_dwcolumn_bmp.of_create_object()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	value	long	al_current_note	is registered at the current position in the array
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_create_object ( long al_current_note )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Long ll_x, ll_y, ll_width, ll_height
String ls_create_info
String ls_rc
String ls_dwcolumn

If IsNull(al_current_note) Or al_current_note = 0 Then Return -1
If IsNull(is_dwcolumns) Or UpperBound(is_dwcolumns) < 1 Or al_current_note > UpperBound(is_dwcolumns) Then Return -1

ls_dwcolumn = is_dwcolumns[al_current_note]

ll_x = Long( idw_requestor.Describe(ls_dwcolumn+".x") )
ll_y = Long( idw_requestor.Describe(ls_dwcolumn+".y") )
ll_width = Long( idw_requestor.Describe(ls_dwcolumn+".width") )
ll_height = Long( idw_requestor.Describe(ls_dwcolumn+".height") )

ll_x = ll_x + ll_width - ii_width[al_current_note]

If ll_height >= 60 And ll_height <= 100 Then //When the column height is within the visible range, keep the width and height equal
	ii_width[al_current_note] = ll_height
End If

//create image
ls_create_info = "create bitmap(band=detail filename='" + is_imagepath[al_current_note] + "'" + &
	"x='" + String(ll_x) + "'" + &
	" y='" + String (ll_y) + "' height='" + String (ll_height - 8 ) + "' width='" + String ( ii_width[al_current_note] -4 ) + "' border='" + String ( ii_bord[al_current_note] ) + "' name=p_" + ls_dwcolumn + " visible='1')"
//create button
//ls_create_info = "create button(band=detail text='' filename='" + is_bmp[al_current_note] + "'" + &
// " enabled=yes action='0' border='1' color='33554432' x='" + String(ll_x) + "'" + " y='" + String (ll_y) + "' height= '" + String (ll_height) + "' width='" + String (il_widht + 4 ) + "'" + &
// " vtextalign='0' htextalign='0' name=p_" + ls_dwcolumn + " visible='1' font.face='Arial' font.height='-8' font.weight='400' font. family='2' font.pitch='2' font.charset='0' background.mode='2' background.color='67108864' )"

ls_rc = idw_requestor.Modify(ls_create_info)
If Len(ls_rc) > 0 Then Return -1

Return 1

end function

public function integer of_resize ();//====================================================================
// Function: ou_dwcolumn_bmp.of_resize()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_resize ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Integer	 li_upperbound, li_cnt
Long		ll_x, ll_y, ll_width, ll_heigth
String	ls_rc
String	ls_dwcolumn

// Get the upperbound of all registered columns.
li_upperbound = UpperBound(is_dwcolumns)
For li_cnt = 1 To li_upperbound
	
	ls_dwcolumn = is_dwcolumns[li_cnt]
	If IsNull(ls_dwcolumn) Or Len(Trim(ls_dwcolumn)) = 0 Then  Continue
	ll_x = Long ( idw_requestor.Describe (ls_dwcolumn+".x") )
	ll_y = Long ( idw_requestor.Describe (ls_dwcolumn+".y") )
	ll_width = Long ( idw_requestor.Describe (ls_dwcolumn+".width") )
	ll_heigth = Long ( idw_requestor.Describe (ls_dwcolumn+".height") )
	
	ll_x = ll_x + ll_width - ii_width[li_cnt]
	ll_heigth = ll_heigth
	
	ls_rc = idw_requestor.Modify ('p_' + ls_dwcolumn + '.x = ' + String (ll_x) )
	ls_rc = idw_requestor.Modify ('p_' + ls_dwcolumn + '.width = ' + String ( ii_width[li_cnt] -4 )  )
	ls_rc = idw_requestor.Modify ('p_' + ls_dwcolumn + '.height = ' + String (ll_heigth -4 )  )
	If Len(ls_rc) > 0 Then Continue
	
Next

Return 1


end function

public function integer of_dropdown ();//====================================================================
// Function: ou_dwcolumn_bmp.of_dropdown()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_dropdown ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

String		ls_colname, ls_event
Integer		li_position,  ll_i

// Check the required references.
If IsNull(idw_requestor) Or Not IsValid(idw_requestor)  Then
	Return -1
End If

// Get the current column name.
ls_colname = idw_requestor.GetColumnName()
// Check if column is in the search column array.
If Not of_IsRegistered(ls_colname) Then
	Return 0
End If

For ll_i = 1  To UpperBound(is_dwcolumns)
	If is_dwcolumns[ll_i] = ls_colname Then
		li_position = ll_i
		ls_event = is_event[ll_i]
		Exit
	End If
Next
If li_position > 0 Then
	If idw_requestor.TriggerEvent (ls_event, 2, ls_colname) = 1 Then
		Return 1
	Else
		Return 0
	End If
Else
	Return 0
End If

Return 1

end function

public function integer of_changevisible (string as_column);//====================================================================
// Function: ou_dwcolumn_bmp.of_changevisible()
//--------------------------------------------------------------------
// Description:
//--------------------------------------------------------------------
// Arguments:
// 	value	string	as_column	
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_changevisible ( string as_column )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Integer	 li_upperbound, li_cnt
Long		ll_x, ll_y, ll_width, ll_heigth
String	ls_rc
String	ls_dwcolumn

// Get the upperbound of all registered columns.
li_upperbound = UpperBound(is_dwcolumns)
For li_cnt = 1 To li_upperbound
	ls_dwcolumn = is_dwcolumns[li_cnt]
	If as_column = ls_dwcolumn Then
		idw_requestor.Modify ('p_' + ls_dwcolumn + ".visible = '1~tif ( currentrow() =Getrow (), 1, 0)'")
	Else
		idw_requestor.Modify ('p_' + ls_dwcolumn + ".visible = 0")
	End If
Next

Return 1

end function

public function integer of_register (string as_dwcolumn, string as_image_path);//====================================================================
// Function: ou_dwcolumn_bmp.of_register()
//--------------------------------------------------------------------
// Description: The style of the registered column must be: 'ddlb' or 'edit' or 'editmask'.
//--------------------------------------------------------------------
// Arguments:
// 	value	string	as_dwcolumn  		Column to register.
// 	value	string	as_image_path		The path of the image file
//--------------------------------------------------------------------
// Returns:  integer 1 if the column was added.  0 if the column was not added. -1 if an error is encountered.
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_register ( string as_dwcolumn, string as_image_path )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

String ls_event

ls_event = 'ue_find' //The data window ue_find event is triggered by default

Return of_register(as_dwcolumn, as_image_path, ls_event)

end function

public function integer of_register (string as_dwcolumn, string as_image_path, string as_event);//====================================================================
// Function: ou_dwcolumn_bmp.of_register()
//--------------------------------------------------------------------
// Description: The style of the registered column must be: 'ddlb' or 'edit' or 'editmask'.
//--------------------------------------------------------------------
// Arguments:
// 	value	string	as_dwcolumn  		Column to register.
// 	value	string	as_image_path		The path of the image file
// 	value	string	as_event     			The event when the clicked event .
//--------------------------------------------------------------------
// Returns:  integer	1 if the column was added. 0 if the column was not added. -1 if an error is encountered.
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_register ( string as_dwcolumn, string as_image_path, string as_event )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Integer li_bord

li_bord = 6 //The border is 6

Return of_register(as_dwcolumn, as_image_path, as_event, li_bord)

end function

public function integer of_register (string as_dwcolumn, string as_image_path, string as_event, integer ai_bord);//====================================================================
// Function: ou_dwcolumn_bmp.of_register()
//--------------------------------------------------------------------
// Description: The style of the registered column must be: 'ddlb' or 'edit' or 'editmask'.
//--------------------------------------------------------------------
// Arguments:
// 	value	string 	as_dwcolumn  		Column to register.
// 	value	string 	as_image_path		The path of the image file
// 	value	string 	as_event     			The event when the clicked event .
// 	value	integer	ai_bord      			the bord type of the picture(button)
//--------------------------------------------------------------------
// Returns:  integer	 1 if the column was added. 0 if the column was not added. -1 if an error is encountered.
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_register ( string as_dwcolumn, string as_image_path, string as_event, integer ai_bord )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Integer li_width

li_width = 75
Return of_register(as_dwcolumn, as_image_path, as_event, ai_bord, li_width)

end function

public function integer of_register (string as_dwcolumn, string as_image_path, string as_event, integer ai_bord, integer ai_width);//====================================================================
// Function: ou_dwcolumn_bmp.of_register()
//--------------------------------------------------------------------
// Description: The style of the registered column must be: 'ddlb' or 'edit' or 'editmask'.
//--------------------------------------------------------------------
// Arguments:
// 	value	string 	as_dwcolumn  		Column to register.
// 	value	string 	as_image_path		The path of the image file
// 	value	string 	as_event     			The event when the clicked event .
// 	value	integer	ai_bord      			the bord type of the picture(button)
// 	value	integer	ai_width     			the width of the picture(button), the height is the same to the row
//--------------------------------------------------------------------
// Returns:  integer	 1 if the column was added. 0 if the column was not added. -1 if an error is encountered.
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_register ( string as_dwcolumn, string as_image_path, string as_event, integer ai_bord, integer ai_width )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Integer li_cnt, li_rc
Integer li_availableentry
Integer li_upperbound
String ls_editstyle
String ls_modexp
String ls_descexp
String ls_descret
String ls_storemodify
String ls_rc

// Check the required reference.
If IsNull(idw_requestor) Or Not IsValid(idw_requestor) Then
	Return -1
End If

// Check arguments
If (IsNull(as_dwcolumn) Or Len(Trim(as_dwcolumn)) = 0) Or &
	IsNull(idw_requestor) Or Not IsValid(idw_requestor) Then
	Return -1
End If

// Trim and Convert to lower case.
as_dwcolumn = Trim(Lower(as_dwcolumn))

// Check if the column is already registered.
If of_IsRegistered(as_dwcolumn) Then
	Return 0
End If

// Get the upperbound of all registered columns.
li_upperbound = UpperBound(is_dwcolumns)

// Find if there is an empty string in the array, if so, register the newly registered column to the string
For li_cnt = 1 To li_upperbound
	If IsNull(is_dwcolumns[li_cnt]) Or Len(Trim(is_dwcolumns[li_cnt])) = 0 Then
		If li_availableentry = 0 Then
			//Get the first slot found
			li_availableentry = li_cnt
			Exit
		End If
	End If
Next
//If an available slot was not found then create a new entry
If li_availableentry = 0 Then
	li_availableentry = li_upperbound + 1
End If
// Add/Initilize the new entry.
is_dwcolumns[li_availableentry] = as_dwcolumn
is_imagepath[li_availableentry] = as_image_path
is_event[li_availableentry] = as_event
ii_bord[li_availableentry] = ai_bord
ii_width[li_availableentry] = ai_width

// Store the Modify expression needed to unregister the column.
ls_editstyle = idw_requestor.Describe(as_dwcolumn+".Edit.Style")
Choose Case Lower(ls_editstyle)
	Case 'edit'
		ls_descret = idw_requestor.Describe(as_dwcolumn+".Edit.Required")
		If ls_descret = 'yes' Or ls_descret = 'no' Then
			ls_storemodify += as_dwcolumn+".Edit.Required=" + ls_descret + " "
			ls_modexp = as_dwcolumn+".DDLB.Required=" + ls_descret + " "
		End If
		ls_descret = idw_requestor.Describe(as_dwcolumn+".Edit.NilIsNull")
		If ls_descret = 'yes' Or ls_descret = 'no' Then
			ls_storemodify += as_dwcolumn+".Edit.NilIsNull=" + ls_descret + " "
			ls_modexp += as_dwcolumn+".DDLB.NilIsNull=" + ls_descret + " "
		End If
	Case 'editmask'
		ls_descret = idw_requestor.Describe(as_dwcolumn+".EditMask.Mask")
		If ls_descret = '!' Or ls_descret = '?' Then
			ls_storemodify += as_dwcolumn+".EditMask.Mask='' "
		Else
			ls_storemodify += as_dwcolumn+".EditMask.Mask='" + ls_descret + "' "
		End If
		ls_descret = idw_requestor.Describe(as_dwcolumn+".EditMask.Required")
		If ls_descret = 'yes' Or ls_descret = 'no' Then
			ls_storemodify += as_dwcolumn+".EditMask.Required=" + ls_descret + " "
			ls_modexp = as_dwcolumn+".DDLB.Required=" + ls_descret + " "
		End If
		ls_descret = idw_requestor.Describe(as_dwcolumn+".EditMask.NilIsNull")
		If ls_descret = 'yes' Or ls_descret = 'no' Then
			ls_storemodify += as_dwcolumn+".EditMask.NilIsNull=" + ls_descret + " "
			ls_modexp += as_dwcolumn+".DDLB.NilIsNull=" + ls_descret + " "
		End If
	Case 'ddlb'
		ls_descret = idw_requestor.Describe(as_dwcolumn+".DDLB.useasborder")
		If ls_descret = 'yes' Or ls_descret = 'no' Then
			ls_storemodify = as_dwcolumn+".DDLB.useasborder=" + ls_descret + " "
		End If
	Case 'dddw' //Cannot support the following data window
		Return -1
	Case Else
		// Not a valid original edit style.
		Return -1
End Choose

// Store the Modify statement that allows unregister.
is_dwcolumnsexp[li_availableentry] = ls_storemodify

// Convert the current format to ddlb and limit the length to 0 to allow editing without drop-down arrov

ls_modexp += as_dwcolumn+".DDLB.limit=0 " + &
	as_dwcolumn+".DDLB.AllowEdit=Yes " + as_dwcolumn+".DDLB.ShowList=no"
ls_rc = idw_requestor.Modify(ls_modexp)
If Len(ls_rc) > 0 Then Return -1


//create image (button)
If of_create_object( li_availableentry ) <> 1 Then Return -1

// The column was registered.
Return 1

end function

public function integer of_setrequestor (datawindow adw_requestor);//====================================================================
// Function: ou_dwcolumn_bmp.of_setrequestor()
//--------------------------------------------------------------------
// Description: Associates a datawindow control with a datawindow service NVO by setting the idw_Requestor instance variable.
//--------------------------------------------------------------------
// Arguments:
// 	value	datawindow	adw_requestor	The datawindow requesting the service
//--------------------------------------------------------------------
// Returns:  integer
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_setrequestor ( datawindow adw_requestor )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================


If IsNull(adw_requestor) Or Not IsValid(adw_requestor) Then
	Return -1
End If

idw_Requestor = adw_requestor
Return 1

end function

public function integer of_unregister (string as_dwcolumn);//====================================================================
// Function: ou_dwcolumn_bmp.of_unregister()
//--------------------------------------------------------------------
// Description: UnRegisters the object from the service by the column name. Function is only valid when serving a DataWindow control.
//--------------------------------------------------------------------
// Arguments:
// 	value	string	as_dwcolumn	The registered column to search for.
//--------------------------------------------------------------------
// Returns:  integer 1 successful. 0 not previously registered. -1 error.
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_unregister ( string as_dwcolumn )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Integer	li_upper
Integer	li_cnt
String	ls_rc
Constant String EMPTY = ''

// Check for a valid ID.
If IsNull(as_dwcolumn) Or Len(Trim(as_dwcolumn)) = 0  Then
	Return -1
End If

// Trim and Convert to lower case.
as_dwcolumn = Trim(Lower(as_dwcolumn))

// Find the Column.
li_upper = UpperBound(is_dwcolumns)
For li_cnt = 1 To li_upper
	If as_dwcolumn = is_dwcolumns[li_cnt] Then
		// The entry has been found.  
		// Clear out any attribute changes.
		If Len(is_dwcolumnsexp[li_cnt]) > 0 Then
			ls_rc = idw_requestor.Modify (is_dwcolumnsexp[li_cnt])
			If Len(ls_rc) > 0 Then
				Return -1
			End If
		End If
		
		// Perform the actual Unregister.
		is_dwcolumns[li_cnt] = ''
		is_imagepath[li_cnt] = ''
		is_dwcolumnsexp[li_cnt] = ''
		is_event[li_cnt] = ''
		//ii_dwcolumnstyle[li_cnt]= 0
		
		Return 1
	End If
Next

// The column was not found.
Return 0

end function

public function integer of_unregister ();//====================================================================
// Function: ou_dwcolumn_bmp.of_unregister()
//--------------------------------------------------------------------
// Description: UnRegisters all registerd columns from the service. Function is only valid when serving a DataWindow control.
//--------------------------------------------------------------------
// Arguments:
//--------------------------------------------------------------------
// Returns:  integer 1 successful. 0 nothing previously registered.
//--------------------------------------------------------------------
// Author:	PB.BaoGa		Date: 2022/02/20
//--------------------------------------------------------------------
// Usage: ou_dwcolumn_bmp.of_unregister ( )
//--------------------------------------------------------------------
//	Copyright (c) PB.BaoGa(TM), All rights reserved.
//--------------------------------------------------------------------
// Modify History:
//
//====================================================================

Integer	li_upper
Integer	li_cnt
Integer	li_unregistered = 0

// Loop around all registered columns.
li_upper = UpperBound(is_dwcolumns)
For li_cnt = 1 To li_upper
	If Len(is_dwcolumns[li_cnt]) > 0 Then
		If of_Unregister(is_dwcolumns[li_cnt]) = 1 Then
			li_unregistered ++
		End If
	End If
Next

If li_unregistered > 0 Then
	Return 1
End If

Return 0

end function

on ou_dwcolumn_bmp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on ou_dwcolumn_bmp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;of_Unregister()

end event

