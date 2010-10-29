VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Handler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Public Sub OnContext(vRef As String, vCookie As String, vURL As String, vInfo As String, vText As String)
    On Error GoTo ErrorOnContext
    Load frmContextInfo
       
    With frmContextInfo
    'http://hn.sslibrary.com/books.jsp?fenleiID=0I&username=jxnydx
        .txtRefer.Text = vRef
        .txtCookie.Text = vCookie
    'javascript:readbook('showbook.do?dxNumber=11113267&d=C20E1BEE8AE9706BF62A75701E974C3A&fenleiID=0I3050605040&username=jxnydx');
        .txtURL.Text = vURL
    '�����������ˡ�
        .txtInfo.Text = vInfo
    '1.�����������ˡ�
    '��ʾ��������ʹ�����ϰ汾�����������������ذ�װ"����������4.0"
    '��ʾ: �����ܻ�û�а�װ "����������4.0", �����ذ�װ��ȷ���Ѱ�װ.���������Ķ�
    '�����Ķ�  |  ��ͨ�Ķ�
    '����: ��¥�� Flaubert
    'ҳ��:318   ��������:2003��
    '�����: ��ƪС˵
        
        
        
        Dim RootURl As String
        RootURl = MgCString.RightLeft(vRef, "/", vbBinaryCompare, ReturnOriginalStr)
        vText = vText & vbCrLf & RootURl
        
        Dim URL As String
        URL = LeftRight(vURL, "'")
        URL = RightLeft(URL, "'")
        
        vText = vText & vbCrLf & URL
        
        Dim tmpfile As String
        tmpfile = GetTempName()
        Dim net As CNetConnection
        Set net = New CNetConnection
        net.URL = RootURl & "/" & URL
        
        Dim header As String
        header = "Accept: image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, application/x-shockwave-flash, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, application/QVOD, application/x-silverlight, */*" & vbCrLf & _
        "Accept-Language: zh-cn" & vbCrLf & _
        "Accept-Encoding: gzip , deflate" & vbCrLf & _
        "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.1.4322)" & vbCrLf & _
        "Connection: Keep-Alive" & vbCrLf & _
        "Cache-Control: no-cache" & vbCrLf & _
        "Cookie: " & vCookie
        
        net.header = header
        net.Destination = tmpfile
        net.Connect
        net.StartDownload
        
        Dim fNum As Integer
        fNum = FreeFile
        Open tmpfile For Input As #fNum
        If Not EOF(fNum) Then
            Line Input #fNum, URL
        End If
        Close fNum
        MsgBox URL
        
        vText = vText & vbCrLf & URL
        vText = vText & vbCrLf & header
        vText = vText & vbCrLf & net.Respone.HeaderString
        
        Set net = Nothing
ErrorOnContext:
        .txtText.Text = vText
    End With
    DoEvents
    

    frmContextInfo.Show
    'Unload frmContextInfo
End Sub

Private Function GetTempName() As String
    Dim tempFolder As String
    tempFolder = Environ$("TEMP")
    If tempFolder = "" Then tempFolder = Environ$("Tmp")
    If tempFolder = "" Then tempFolder = App.Path
    
    GetTempName = bddir(tempFolder) & "temp.sslib"
End Function