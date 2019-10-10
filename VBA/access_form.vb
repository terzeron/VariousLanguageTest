Option Compare Database
Option Explicit

Private Sub 본문_Click()

End Sub

Private Sub Form_Open(Cancel As Integer)
' Minimize the database window and initialize the form.

    ' Move to the switchboard page that is marked as the default.
    Me.Filter = "[ItemNumber] = 0 AND [Argument] = '기본' "
    Me.FilterOn = True
    ActiveXCtl28.MultiLine = True
    ActiveXCtl28.ScrollBars = 2
End Sub

Private Sub Form_Current()
' Update the caption and fill in the list of options.

    Me.Caption = Nz(Me![ItemText], "")
    FillOptions
    
End Sub

Private Sub FillOptions()
' Fill in the options for this switchboard page.

    ' The number of buttons on the form.
    Const conNumButtons = 5
    
    Dim dbs As Database
    Dim rst As Recordset
    Dim strSQL As String
    Dim intOption As Integer
    
    ' Set the focus to the first button on the form,
    ' and then hide all of the buttons on the form
    ' but the first.  You can't hide the field with the focus.
    Me![Option1].SetFocus
    For intOption = 2 To conNumButtons
        Me("Option" & intOption).Visible = False
        'Me("OptionLabel" & intOption).Visible = False
    Next intOption
    
    ' Open the table of Switchboard Items, and find
    ' the first item for this Switchboard Page.
    Set dbs = CurrentDb()
    strSQL = "SELECT * FROM [스위치보드 항목]"
    strSQL = strSQL & " WHERE [ItemNumber] > 0 AND [SwitchboardID]=" & Me![SwitchboardID]
    strSQL = strSQL & " ORDER BY [ItemNumber];"
    Set rst = dbs.OpenRecordset(strSQL)
    
    ' If there are no options for this Switchboard Page,
    ' display a message.  Otherwise, fill the page with the items.
    If (rst.EOF) Then
        Me![OptionLabel1].Caption = "이 스위치보드 페이지에는 항목이 없습니다"
    Else
        While (Not (rst.EOF))
            Me("Option" & rst![ItemNumber]).Visible = True
            Me("OptionLabel" & rst![ItemNumber]).Visible = True
            Me("OptionLabel" & rst![ItemNumber]).Caption = rst![ItemText]
            rst.MoveNext
        Wend
    End If

    ' Close the recordset and the database.
    rst.Close
    dbs.Close

End Sub

Private Function HandleButtonClick(intBtn As Integer)
' This function is called when a button is clicked.
' intBtn indicates which button was clicked.

    ' Constants for the commands that can be executed.
    Const conCmdGotoSwitchboard = 1
    Const conCmdOpenFormAdd = 2
    Const conCmdOpenFormBrowse = 3
    Const conCmdOpenReport = 4
    Const conCmdCustomizeSwitchboard = 5
    Const conCmdExitApplication = 6
    Const conCmdRunMacro = 7
    Const conCmdRunCode = 8

    ' An error that is special cased.
    Const conErrDoCmdCancelled = 2501
    
    Dim dbs As Database
    Dim rst As Recordset

On Error GoTo HandleButtonClick_Err

    ' Find the item in the Switchboard Items table
    ' that corresponds to the button that was clicked.
    Set dbs = CurrentDb()
    Set rst = dbs.OpenRecordset("스위치보드 항목", dbOpenDynaset)
    rst.FindFirst "[SwitchboardID]=" & Me![SwitchboardID] & " AND [ItemNumber]=" & intBtn
    
    ' If no item matches, report the error and exit the function.
    If (rst.NoMatch) Then
        MsgBox "스위치보드 항목을 읽는데 오류가 발생했습니다."
        rst.Close
        dbs.Close
        Exit Function
    End If
    
    Select Case rst![Command]
        
        ' Go to another switchboard.
        Case conCmdGotoSwitchboard
            Me.Filter = "[ItemNumber] = 0 AND [SwitchboardID]=" & rst![Argument]
            
        ' Open a form in Add mode.
        Case conCmdOpenFormAdd
            DoCmd.OpenForm rst![Argument], , , , acAdd

        ' Open a form.
        Case conCmdOpenFormBrowse
            DoCmd.OpenForm rst![Argument]

        ' Open a report.
        Case conCmdOpenReport
            DoCmd.OpenReport rst![Argument], acPreview

        ' Customize the Switchboard.
        Case conCmdCustomizeSwitchboard
            ' Handle the case where the Switchboard Manager
            ' is not installed (e.g. Minimal Install).
            On Error Resume Next
            Application.Run "WZMAIN80.sbm_Entry"
            If (Err <> 0) Then MsgBox "명령을 사용할 수 없습니다."
            On Error GoTo 0
            ' Update the form.
            Me.Filter = "[ItemNumber] = 0 AND [Argument] = '기본' "
            Me.Caption = Nz(Me![ItemText], "")
            FillOptions

        ' Exit the application.
        Case conCmdExitApplication
            CloseCurrentDatabase

        ' Run a macro.
        Case conCmdRunMacro
            DoCmd.RunMacro rst![Argument]

        ' Run code.
        Case conCmdRunCode
            Application.Run rst![Argument]

        ' Any other command is unrecognized.
        Case Else
            MsgBox "옵션을 알 수 없습니다."
    
    End Select

    ' Close the recordset and the database.
    rst.Close
    dbs.Close
    
HandleButtonClick_Exit:
    Exit Function

HandleButtonClick_Err:
    ' If the action was cancelled by the user for
    ' some reason, don't display an error message.
    ' Instead, resume on the next line.
    If (Err = conErrDoCmdCancelled) Then
        Resume Next
    Else
        MsgBox "명령을 실행하는데 오류가 발생했습니다.", vbCritical
        Resume HandleButtonClick_Exit
    End If
    
End Function

Private Sub Option2_Click()
    '
    ' EA13 파일 작성
    '
    
    Dim filename As String
    Dim date_string1 As String, date_string2 As String
    Dim output As String
    Dim db As Database
    Dim rs As Recordset
    Dim record As Variant
    Dim register As String
    Dim i As Integer, j As Integer
    Dim bank_code As Variant, bank_name As Variant, tmp_bank_name As Variant
    Dim organization_code As String
    Dim account_number As String, citizen_number As String
    Dim char As String
    Dim new_output As String
    Dim count As Integer, count_new As Integer, count_change As Integer
    Dim count_unregister As Integer, count_random As Integer
    Dim use_bank As Boolean
            
    Set db = CurrentDb
    Set rs = db.OpenRecordset("회원-개인")
    
    count = 0
    count_new = 0
    count_change = 0
    count_unregister = 0
    count_random = 0
    bank_name = Array("산업", "기업", "국민", "외환", "주택", "수협", "장기", "농협", "축협", "조흥", "상업", "제일", "한일", "서울", "신한", "한미", "동화", "동남", "대동", "대구", "부산", "충청", "광주", "제주", "경기", "전북", "강원", "경남", "충북", "우체국", "하나", "보람", "평화")
    bank_code = Array("02", "03", "04", "05", "06", "07", "09", "11", "16", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "71", "81", "82", "83")
    organization_code = "9991910109"
    date_string1 = Format(Month(Now), "0#") & Format(Day(Now), "0#")
    date_string2 = Format(Now, "yymmdd")
    filename = "EA13" & date_string1
    
    'Debug.Print "현재 EA13 파일을 작성 중입니다. 잠시 기다려주십시오."
    'Debug.Print "파일 이름 : " & filename
    
    '이미 파일이 존재하면 삭제한다.
    If Dir(filename) = filename Then
        Kill filename
    End If
    Open filename For Binary As #1
    
    ' Header를 출력
    ' 1. Record 구분
    output = "H"
    Put #1, 1, output
    ' 2. 일련번호
    output = "0000000"
    Put #1, , output
    ' 3. 기관코드 - 확실하지 않음
    output = organization_code
    Put #1, , output
    ' 4. File 이름
    output = filename
    Put #1, , output
    ' 5. 신청접수일자
    output = date_string2
    Put #1, , output
    ' 6. Filler
    output = String(68, " ")
    Put #1, , output
    
    ' Data를 출력
    For i = 1 To rs.RecordCount
        ' 모든 회원 레코드를 하나씩 읽어오면서 데이타레코드를 출력한다.
        record = rs.GetRows(1)
                    
        'Debug.Print record(0, 0) & "-" & record(21, 0) & "."
        
        If IsNull(record(21, 0)) Then
            register = ""
        Else
            register = record(21, 0)
        End If
        
        If IsNull(record(14, 0)) And IsNull(record(17, 0)) Then
            ' 은행이 지정되어 있지 않은 사용자는 skip한다.
            use_bank = False
        Else
            use_bank = True
        End If
        
        If use_bank = True And (register = "" Or register = "신규") Then
            ' 등록신청(신규), 해지신청(해지, 임의해지)에 대해서만 레코드를 생성한다.
                        
            Debug.Print record(0, 0)
            
            ' 1. Record 구분
            output = "R"
            Put #1, , output
            ' 2. Data 일련번호
            output = "0000001"
            Put #1, , output
            ' 3. 기관코드
            output = organization_code
            Put #1, , output
            ' 4. 신청일자
            output = date_string2
            Put #1, , output
            ' 5. 신청구분
            If register = "해지" Then
                ' 해지
                output = "3"
                count_unregister = count_unregister + 1
            ElseIf register = "임의해지" Then
                ' 임의해지
                output = "7"
                count_random = count_random + 1
            Else
                ' 코드가 NULL이거나 신규이면 신규로 간주한다.
                output = "1"
                count_new = count_new + 1
            End If
            Put #1, , output
            ' 6. 납부자번호
            output = ""
            If IsNull(record(22, 0)) Then
                MsgBox ("경고 : " & record(0, 0) & " 회원의 식별번호가 지정되어 있지 않습니다!")
                Close #1
                Exit Sub
            Else
                output = record(22, 0)
            End If
            output = Format(output, "0###################")
            Put #1, , output
            ' 7. 은행점코드
            output = ""
            If Not IsNull(record(17, 0)) Then
                ' 17번의 은행(회원) 필드 정보를 이용
                tmp_bank_name = record(17, 0)
            Else
                ' 14번의 은행(언개연) 필드 정보를 이용
                tmp_bank_name = record(14, 0)
            End If
            ' 일치하는 은행코드 찾기
            For j = 0 To UBound(bank_name)
                If tmp_bank_name = bank_name(j) Then
                    output = bank_code(j)
                    Exit For
                End If
            Next
            If output = "" Then
                MsgBox ("경고 : " & record(0, 0) & " 회원의 알 수 없는 " & tmp_bank_name & " 은행 정보입니다!")
            End If
            ' 은행 지점 코드는 space로 처리한다.
            output = output & String(6 - Len(output), " ")
            Put #1, , output
            ' 8. 지정출금계좌번호
            output = ""
            If IsNull(record(19, 0)) Then
                account_number = ""
            Else
                account_number = record(19, 0)
            End If
            
            If account_number <> "" Then
                'Debug.Print account_number
                For j = 1 To Len(account_number)
                    char = Mid(account_number, j, 1)
                    If char <> "-" Then
                        new_output = output & char
                        output = new_output
                    End If
                Next
                'Debug.Print ":" & output
            End If
            Put #1, , output
            output = String(16 - Len(output), " ")
            Put #1, , output
            ' 9. 주민등록번호 또는 사업자등록번호
            output = ""
            If IsNull(record(20, 0)) Then
                citizen_number = ""
                MsgBox ("경고 : " & record(0, 0) & " 회원은 주민등록번호가 지정되어 있지 않습니다!")
            Else
                citizen_number = record(20, 0)
            End If
            
            If citizen_number <> "" Then
                'Debug.Print citizen_number
                For j = 1 To Len(citizen_number)
                    char = Mid(citizen_number, j, 1)
                    If char <> "-" Then
                        new_output = output & char
                        output = new_output
                    End If
                Next
                'Debug.Print ":", output
            End If
            Put #1, , output
            output = String(16 - Len(output), " ")
            Put #1, , output
            ' 10. 취급점코드
            output = String(4, " ")
            Put #1, , output
            ' 11. 자금종류
            output = "HB"
            Put #1, , output
            ' 12. 처리결과
            output = String(5, " ")
            Put #1, , output
            ' 13. Filler
            output = String(6, " ")
            Put #1, , output
            
            ' 파일 출력을 한 레코드 수를 센다
            count = count + 1
            'Debug.Print record(0, 0)
        End If
    Next
    
        
    ' Trailer를 출력
    ' 1. Record 구분
    output = "T"
    Put #1, , output
    ' 2. 일련번호
    output = "9999999"
    Put #1, , output
    ' 3. 기관코드
    output = organization_code
    Put #1, , output
    ' 4. FILE 이름
    output = filename
    Put #1, , output
    ' 5. 총 Data Record 수
    output = Format(Str(count), "0######")
    Put #1, , output
    ' 6. 등록의뢰건수 - 신규등록
    output = Format(Str(count_new), "0######")
    Put #1, , output
    ' 7. 등록의뢰건수 - 변경등록
    output = Format(Str(count_change), "0######")
    Put #1, , output
    ' 8. 등록의뢰건수 - 해지등록
    output = Format(Str(count_unregister), "0######")
    Put #1, , output
    ' 9. 등록의뢰건수 - 임의해지
    output = Format(Str(count_random), "0######")
    Put #1, , output
    ' 10. filler
    output = String(29, " ")
    Put #1, , output
    ' 11. MAC 검증값
    output = String(10, " ")
    Put #1, , output
    
    ' 파일을 닫는다.
    Close #1
    
    MsgBox ("정상적으로 파일을 출력하였습니다. 신규 " & count_new & "명, 해지 " & count_unregister & "명, 임의해지 " & count_random & "명입니다.")
End Sub

Private Sub Option3_Click()
    Dim db As Database
    Dim rs As Recordset
    Dim record As Variant
    Dim register As String
    Dim filename As String, tmp_filename As String
    Dim line As String
    Dim organization_code As String
    Dim position As Integer, pos As Integer
    Dim register_type As String
    Dim member_number As String
    Dim result As String
    Dim record_size As Integer
    
    Set db = CurrentDb
    Set rs = db.OpenRecordset("회원-개인", dbOpenDynaset, dbConsistent)
    
    'filename = Trim(inputbox("EA14파일의 경로 : ", "파일 불러오기", "EA14"))
    
    filename = "EA14" & Format(Now, "mmdd")
    organization_code = "9991910109"
    record_size = 100
    
    ' 파일 불러오기 창을 연다. 읽혀진 파일은 filename에 저장된다.
    ActiveXCtl23.filename = filename
    Do
        ActiveXCtl23.showopen
        tmp_filename = ActiveXCtl23.filename
    Loop While tmp_filename <> CurDir & "\" & Dir(tmp_filename)
    filename = tmp_filename
    
    '초기화 - 텍스트박스를 비운다.
    ActiveXCtl28.Text = ""
    
    Open filename For Binary As #1
    position = 1
    Do
        line = String(100, " ")
        Get #1, position, line
        Debug.Print line & "-" & position
        
        ' 하나의 레코드에 대해서 분석을 한다.
        pos = position Mod record_size
        Select Case Mid(line, pos, 1)
        Case "H"
        ' Header 레코드
            If Mid(line, pos + 8, 10) <> organization_code Then
                ActiveXCtl28.Text = ActiveXCtl28.Text & "경고 : 이용기관식별코드를 인식할 수 없습니다!" & vbCr
                Close #1
                Exit Sub
            End If
        
        Case "R"
        ' Data 레코드
            member_number = Mid(line, pos + 25, 20)
            ' register_type : 1 - 신규, 3 - 해지, 7 - 임의해지
            Select Case Mid(line, pos + 24, 1)
            Case "1"
                register_type = "신규"
            Case "3"
                register_type = "해지"
            Case "7"
                register_type = "임의해지"
            Case Else
                ActiveXCtl28.Text = ActiveXCtl28.Text & "경고 : " & member_number & _
                "번 회원의 알 수 없는 신청구분입니다. " & "신규나 해지, 임의해지로 신청되어 있지 않습니다!" & vbCr
            End Select
            ' result_code : N - 불능
            Select Case Mid(line, pos + 89, 1)
            Case "N"
                result = "신청확인 불능"
            Case Else
                result = "신청확인"
            End Select
            ActiveXCtl28.Text = ActiveXCtl28.Text & Format(member_number, "#") & _
            "번 회원의 출금이체 신청결과는 " & result & "입니다." & vbCr
        
        Case "T"
        ' Trailer 레코드
            Exit Do
            
        Case Else
            ActiveXCtl28.Text = ActiveXCtl28.Text & "경고 : 데이타의 포맷이 올바르지 않습니다!" & vbCr
            Close #1
            Exit Sub
        End Select
        
        position = position + Len(line)
    Loop Until position > FileLen(filename)
    
    Close #1
    
    MsgBox ("EA14파일을 정상적으로 분석하였습니다.")
    
    rs.Close
    db.Close
       
End Sub

Private Sub Option4_Click()
    Dim filename As String
    Dim organization_code As String
    Dim main_bank_code As String, main_account_number As String
    Dim date_string1 As String, date_string2 As String
    Dim output As String, new_output As String
    Dim db As Database
    Dim rs As Recordset
    Dim record As Variant
    Dim i As Integer, j As Integer
    Dim count As Long, count_extract As Long, total_amount As Long
    Dim bank_code As Variant, bank_name As Variant, tmp_bank_name As Variant
    Dim register As String
    Dim account_number As String
    Dim citizen_number As String
    Dim use_bank As Boolean, use_expense As Boolean
    Dim char As String
    
    Set db = CurrentDb
    Set rs = db.OpenRecordset("회원-개인")
    
    organization_code = "9991910109"
    main_bank_code = "000000"
    main_account_number = "0000000000000000"
    bank_name = Array("산업", "기업", "국민", "외환", "주택", "수협", "장기", "농협", "축협", "조흥", "상업", "제일", "한일", "서울", "신한", "한미", "동화", "동남", "대동", "대구", "부산", "충청", "광주", "제주", "경기", "전북", "강원", "경남", "충북", "우체국", "하나", "보람", "평화")
    bank_code = Array("02", "03", "04", "05", "06", "07", "09", "11", "16", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "71", "81", "82", "83")
    date_string1 = Format(Month(Now), "0#") & Format(Day(Now), "0#")
    date_string2 = Format(Now, "yymmdd")
    filename = "EA21" & date_string1
    count = 0
    count_extract = 0
    total_amount = 0
    
    'Debug.Print "현재 EA21 파일을 작성 중입니다. 잠시 기다려주십시오."
    'Debug.Print "파일 이름 : " & filename
    
    ' 이미 EA21 파일이 존재하면 지운다.
    If Dir(filename) = filename Then
        Kill filename
    End If
    
    ' EA21 파일을 연다.
    Open filename For Binary As #2
    
    ' header를 출력
    ' 1. Record 구분
    output = "H"
    Put #2, , output
    ' 2. 일련번호
    output = "0000000"
    Put #2, , output
    ' 3. 기관코드
    output = organization_code
    Put #2, , output
    ' 4. 기관코드
    output = filename
    Put #2, , output
    ' 5. 출금일자
    output = date_string2
    Put #2, , output
    ' 6. 주거래은행점코드
    output = main_bank_code
    Put #2, , output
    ' 8. 입금계좌번호
    output = main_account_number
    Put #2, , output
    ' 7. Filler
    output = String(66, " ")
    Put #2, , output
    
    ' data record를 출력
    For i = 1 To rs.RecordCount
        ' 모든 회원 레코드를 하나씩 읽어오면서 데이타레코드를 출력한다.
        record = rs.GetRows(1)
                    
        'Debug.Print record(0, 0)
        
        If IsNull(record(21, 0)) Then
            register = ""
        Else
            register = record(21, 0)
        End If
        
        If IsNull(record(14, 0)) And IsNull(record(17, 0)) Then
            ' 은행이 지정되어 있지 않은 사용자는 skip한다.
            use_bank = False
        Else
            use_bank = True
        End If
            
        If IsNull(record(15, 0)) And IsNull(record(18, 0)) Then
            ' 회비가 지정되어 있지 않은 사용자는 skip한다.
            use_expense = False
        Else
            use_expense = True
        End If
            
        If use_bank = True And use_expense = True And register = "" Then
            ' 은행 정보가 있고 회비가 지정되어 있으며 등록되어 있는 사용자에 대해서만 레코드 출력
            
            Debug.Print (record(0, 0))
            ' Data 레코드 출력
            ' 1. Record 구분
            output = "R"
            Put #2, , output
            ' 2. Data 일련번호
            output = "0000001"
            Put #2, , output
            ' 3. 기관코드
            output = organization_code
            Put #2, , output
            ' 4. 출금은행점코드
            output = ""
            If Not IsNull(record(17, 0)) Then
                ' 17번의 은행(회원) 필드 정보를 이용
                tmp_bank_name = record(17, 0)
            Else
                ' 14번의 은행(언개연) 필드 정보를 이용
                tmp_bank_name = record(14, 0)
            End If
            ' 일치하는 은행코드 찾기
            For j = 0 To UBound(bank_name)
                If tmp_bank_name = bank_name(j) Then
                    output = bank_code(j)
                    Exit For
                End If
            Next
            If output = "" Then
                MsgBox ("경고 : " & record(0, 0) & " 회원의 알 수 없는 " & tmp_bank_name & " 은행 정보입니다!")
                
            End If
            ' 은행 지점 코드는 space로 처리한다.
            output = output & String(6 - Len(output), " ")
            Put #2, , output
            ' 5. 출금계좌번호
            output = ""
            If IsNull(record(19, 0)) Then
                account_number = ""
            Else
                account_number = record(19, 0)
            End If
            
            If account_number <> "" Then
                'Debug.Print account_number
                For j = 1 To Len(account_number)
                    char = Mid(account_number, j, 1)
                    If char <> "-" Then
                        new_output = output & char
                        output = new_output
                    End If
                Next
                'Debug.Print ":" & output
            End If
            Put #2, , output
            output = String(16 - Len(output), " ")
            Put #2, , output
            ' 6. 출금의뢰금액
            output = ""
            count = count + 1
            count_extract = count_extract + 1
            If Not IsNull(record(15, 0)) Then
                output = Format(record(15, 0), "0############")
                total_amount = total_amount + record(15, 0)
            Else
                output = Format(record(18, 0), "0############")
                total_amount = total_amount + record(18, 0)
            End If
            Put #2, , output
            ' 7. 주민등록번호 또는 사업자등록번호
            output = ""
            If IsNull(record(20, 0)) Then
                citizen_number = ""
                MsgBox ("경고 : " & record(0, 0) & " 회원은 주민등록번호가 지정되어 있지 않습니다!")
            Else
                citizen_number = record(20, 0)
            End If
            
            If citizen_number <> "" Then
                'Debug.Print citizen_number
                For j = 1 To Len(citizen_number)
                    char = Mid(citizen_number, j, 1)
                    If char <> "-" Then
                        new_output = output & char
                        output = new_output
                    End If
                Next
                'Debug.Print ":", output
            End If
            Put #2, , output
            output = String(13 - Len(output), " ")
            Put #2, , output
            ' 8. 출금결과
            output = String(5, " ")
            Put #2, , output
            ' 9. 통장기재내용
            output = String(16, 0)
            Put #2, , output
            ' 10. 자금종류
            output = "HB"
            Put #2, , output
            ' 11. 이용기관사용영역
            output = ""
            If IsNull(record(22, 0)) Then
                MsgBox ("경고 : " & record(0, 0) & " 회원의 식별번호가 지정되어 있지 않습니다!")
                Close #2
                Exit Sub
            Else
                output = record(22, 0)
            End If
            output = Format(output, "0########################")
            Put #2, , output
            ' 12. 출금형태
            output = "1"
            Put #2, , output
            ' 13. Filler
            output = String(5, " ")
            Put #2, , output
        End If
    Next
    
    ' trailer를 출력
    ' 1. Record 구분
    output = "T"
    Put #2, , output
    ' 2. 일련번호
    output = "9999999"
    Put #2, , output
    ' 3. 기관코드
    output = organization_code
    Put #2, , output
    ' 4. File 이름
    output = filename
    Put #2, , output
    ' 5. 총 data record 건수
    output = Format(count, "0######")
    Put #2, , output
    ' 6. 출금의뢰 - 건수
    output = Format(count_extract, "0######")
    Put #2, , output
    ' 7. 출금의뢰 - 금액
    output = Format(total_amount, "0############")
    Put #2, , output
    ' 8. 부분출금 - 건수
    output = String(7, "0")
    Put #2, , output
    ' 9. 부분출금 - 금액
    output = String(13, "0")
    Put #2, , output
    ' 10. filler
    output = String(37, " ")
    Put #2, , output
    ' 11. MAC 검증값
    output = String(10, " ")
    Put #2, , output
    
    ' 파일을 닫는다.
    Close #2
    MsgBox ("정상적으로 파일을 출력하였습니다. 총 Data Record " & count & "건, 출금의뢰 " & count_extract & "건, 출금총액 " & total_amount & "입니다.")
End Sub
