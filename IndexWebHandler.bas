﻿B4J=true
Group=Handlers
ModulesStructureVersion=1
Type=Class
Version=10
@EndOfDesignText@
'Web Handler class
'Version 3.20
Sub Class_Globals
	Private Request As ServletRequest
	Private Response As ServletResponse
	Private Method As String
	Private Elements() As String
	Private ElementKey As String
End Sub

Public Sub Initialize
	
End Sub

Sub Handle (req As ServletRequest, resp As ServletResponse)
	Request = req
	Response = resp
	Method = Request.Method.ToUpperCase
	Dim FullElements() As String = WebApiUtils.GetUriElements(Request.RequestURI)
	Elements = WebApiUtils.CropElements(FullElements, 1)
	If Method <> "GET" Then
		WebApiUtils.ReturnHtmlMethodNotAllowed(Response)
		Return
	End If
	If ElementMatch("") Then
		ShowIndexPage
		Return
	End If
	If ElementMatch("key") Then
		Select ElementKey
			Case "modal"
				WebApiUtils.ReturnHtml(GenerateModal, Response)
				Return
		End Select
	End If
	WebApiUtils.ReturnHtmlPageNotFound(Response)
End Sub

Private Sub ElementMatch (Pattern As String) As Boolean
	Select Pattern
		Case ""
			If Elements.Length = 0 Then
				Return True
			End If
		Case "key"
			If Elements.Length = 1 Then
				ElementKey = Elements(0)
				Return True
			End If
	End Select
	Return False
End Sub

Private Sub ShowIndexPage
	Dim doc As Document
	doc.Initialize
	doc.AppendDocType
	doc.Append(GenerateIndex)
	Dim content As String = doc.ToString
	LogColor(content, -16776961)
	WebApiUtils.ReturnHTML(content, Response)
End Sub

Sub GenerateIndex As String
	Dim html1 As Tag = Html.lang("en")
	html1.comment(" generated by MiniHTML ")
	
	Head.up(html1).Meta_Preset.Title("HTMX Demo") _
	.cdnStyle("https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css", "sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC") _
	.cdnScript("https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js", "sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM") _
	.cdnScript("https://unpkg.com/htmx.org@2.0.4/dist/htmx.js", "sha384-oeUn82QNXPuVkGCkcrInrS1twIxKhkZiFfr2TdiuObZ3n3yIeMiqcRzkIcguaof1")
	'.script("assets/js/htmx.min.js")
	
	Dim body1 As Tag = Body.up(html1)
	
	Dim div1 As Tag = DIV.addClass("d-flex align-items-center").addStyle("height: 100vh").up(body1)
	Dim div2 As Tag = DIV.addStyle("margin: auto").up(div1)
	
	Dim div3 As Tag = DIV.up(div2) _
	.addId("modals-here") _
	.addClass("modal modal-blur fade") _
	.addStyle("display: none") _
	.attribute2(CreateMap("aria-hidden": "false", "tabindex": "-1"))
	
	Dim div4 As Tag = DIV.addClass("modal-dialog modal-lg modal-dialog-centered") _
	.attribute("role", "document").up(div3)
	DIV.addClass("modal-content").up(div4)
	
	Button.Text("Open Modal") _
	.hxGet("/modal") _
	.hxTarget("#modals-here") _
	.hxTrigger("click") _
	.attribute2(CreateMap("data-bs-toggle": "modal", "data-bs-target": "#modals-here")) _
	.addClass("btn btn-primary text-uppercase") _
	.up(div2)
	
'	Dim block As String = "<p>This is a <b>raw</b> HTML</p>"
'	div2.add(Html.create("").Text(block))
	
	Return html1.Build
End Sub

Sub GenerateModal As String
	Dim div4 As Tag = DIV.addClass("modal-dialog modal-lg modal-dialog-centered")
	Dim div5 As Tag = DIV.addClass("modal-content").up(div4)
	Dim div6 As Tag = DIV.addClass("modal-header").up(div5)
	
	H5.addClass("modal-title").Text("Modal title").up(div6)
	
	Dim div6 As Tag = DIV.addClass("modal-body").up(div5)
	Paragraph.Text("Modal body text goes here.").uniline.up(div6)
	
	Dim div6 As Tag = DIV.addClass("modal-footer").up(div5)
	
	Button.addType("button") _
	.addClass("btn btn-secondary text-uppercase") _
	.attribute("data-bs-dismiss", "modal") _
	.Text("Close").up(div6).uniline
	
	Return div4.Build
End Sub