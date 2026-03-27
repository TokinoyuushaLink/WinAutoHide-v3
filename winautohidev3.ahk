#Requires AutoHotkey v2.0
#include Array.ahk
#include DPI.ahk
; 实现窗口平滑移动，越小越平滑，最小为-1
SetWinDelay(5)

; 隐藏时留出的长度以及显示时距离屏幕边缘的长度
; 由于DPI关系，margin设置，不同DPI可能不同
margin := 10
showMargin := 0
global margin
global showMargin
; 移动范围
moveDistance := 30
global moveDistance

; 隐藏的窗口
hiddenWindowList := []
global hiddenWindowList
; 中间态窗口，鼠标放置暂时显示的窗口
suspendWindowList := []
global suspendWindowList

maxHeight := 800

; 加入右键菜单
myMenu := A_TrayMenu
myMenu.Add()
myMenu.Add("Reset all hidden windows", Reset)


Reset(*){
	results := getSide()
	leftMonitor := results[1]
	rightMonitor := results[2]
	leftEdge := results[3]
	rightEdge := results[4]
	MonitorGet leftMonitor,,&leftTopEdge
	MonitorGet rightMonitor,,&rightTopEdge
	leftDPI := getDPI(leftMonitor)
	rightDPI := getDPI(rightMonitor)
	; 多显示器支持
	global leftEdge
	global rightEdge
	global leftTopEdge
	global rightTopEdge
	global leftDPI
	global rightDPI

	; 获取上下边界（取所有显示器的最上/最下）
	topEdge := getTopEdge()
	bottomEdge := getBottomEdge()
	global topEdge
	global bottomEdge

	hiddenLength := hiddenWindowList.Length
	Loop hiddenLength {
		window := hiddenWindowList.Get(hiddenWindowList.Length)
		hiddenWindowList.RemoveAt(hiddenWindowList.Length)
		WinMove(showMargin+leftEdge,showMargin+leftTopEdge,,,"ahk_id" window.id)
		WinSetAlwaysOnTop(0,"ahk_id" window.id)
	}
	suspendLength := suspendWindowList.Length
	Loop suspendLength {
		suspendWindowList.RemoveAt(suspendWindowList.Length)
	}

}



SetTimer WatchCursor, 200

WatchCursor(){
	; DPI.MouseGetPos 某些时候会出错
	Try{
		DPI.MouseGetPos , , &ahkId, &control
	    ; 判断是否为中间态，是则不需要移动
	    suspendWindowIndex := suspendWindowList.Find((v) => (v.id =ahkId))
	    if suspendWindowIndex > 0{
	    	;拖动窗口去除隐藏
	    	window := suspendWindowList.Get(suspendWindowIndex)
	    	if (isWindowMove(window)=1){
	    		hiddenWindowIndex := hiddenWindowList.Find((v) => (v.id =ahkId))
	    		hiddenWindowList.RemoveAt(hiddenWindowIndex)
	    		suspendWindowList.RemoveAt(suspendWindowIndex)
	    		WinSetAlwaysOnTop(0,"ahk_id" ahkId)
	    	}
	    }
	    else{
	    	; 不为中间态时，则若为其他隐藏窗口则不隐藏，接着判断是否为隐藏的窗口
		    hiddenWindowIndex := hiddenWindowList.Find((v) => (v.id =ahkId))
		    ; 隐藏窗口则显示
		    if hiddenWindowIndex>0 {
		    	window := hiddenWindowList.Get(hiddenWindowIndex)
		    	showWindow(window)
		    }
		    else{
		    	;按顺序隐藏
		    	if suspendWindowList.Length > 0{
		    		suspendWindow := suspendWindowList.Get(suspendWindowList.Length)
			    	suspendWindowList.RemoveAt(suspendWindowList.Length)
			    	hideWindow(suspendWindow)
	    		} 
		    }
	    }
	}
}



^Left::{
	results := getSide()
	leftMonitor := results[1]
	rightMonitor := results[2]
	leftEdge := results[3]
	rightEdge := results[4]
	MonitorGet leftMonitor,,&leftTopEdge
	MonitorGet rightMonitor,,&rightTopEdge
	leftDPI := getDPI(leftMonitor)
	rightDPI := getDPI(rightMonitor)
	global leftEdge
	global rightEdge
	global leftTopEdge
	global rightTopEdge
	global leftDPI
	global rightDPI
	topEdge := getTopEdge()
	bottomEdge := getBottomEdge()
	global topEdge
	global bottomEdge

	ahkId := WinGetID("A")
	hiddenWindowIndex := hiddenWindowList.Find((v) => (v.id =ahkId))
	suspendWindowIndex := suspendWindowList.Find((v) => (v.id =ahkId))
	if hiddenWindowIndex >0 {
		hiddenWindowList.RemoveAt(hiddenWindowIndex)
	}
	if suspendWindowIndex > 0{
		suspendWindowList.RemoveAt(suspendWindowIndex)
	}
	hideWindow({id:ahkId,mode:"left"})
}

^Right::{
	results := getSide()
	leftMonitor := results[1]
	rightMonitor := results[2]
	leftEdge := results[3]
	rightEdge := results[4]
	MonitorGet leftMonitor,,&leftTopEdge
	MonitorGet rightMonitor,,&rightTopEdge
	leftDPI := getDPI(leftMonitor)
	rightDPI := getDPI(rightMonitor)
	global leftEdge
	global rightEdge
	global leftTopEdge
	global rightTopEdge
	global leftDPI
	global rightDPI
	topEdge := getTopEdge()
	bottomEdge := getBottomEdge()
	global topEdge
	global bottomEdge

	ahkId := WinGetID("A")
	hiddenWindowIndex := hiddenWindowList.Find((v) => (v.id =ahkId))
	suspendWindowIndex := suspendWindowList.Find((v) => (v.id =ahkId))
	if hiddenWindowIndex >0 {
		hiddenWindowList.RemoveAt(hiddenWindowIndex)
	}
	if suspendWindowIndex > 0{
		suspendWindowList.RemoveAt(suspendWindowIndex)
	}
	hideWindow({id:ahkId,mode:"right"})
	
}

; ===== 新增：上边隐藏 =====
^Up::{
	results := getSide()
	leftMonitor := results[1]
	rightMonitor := results[2]
	leftEdge := results[3]
	rightEdge := results[4]
	MonitorGet leftMonitor,,&leftTopEdge
	MonitorGet rightMonitor,,&rightTopEdge
	leftDPI := getDPI(leftMonitor)
	rightDPI := getDPI(rightMonitor)
	global leftEdge
	global rightEdge
	global leftTopEdge
	global rightTopEdge
	global leftDPI
	global rightDPI
	topEdge := getTopEdge()
	bottomEdge := getBottomEdge()
	global topEdge
	global bottomEdge

	ahkId := WinGetID("A")
	hiddenWindowIndex := hiddenWindowList.Find((v) => (v.id =ahkId))
	suspendWindowIndex := suspendWindowList.Find((v) => (v.id =ahkId))
	if hiddenWindowIndex >0 {
		hiddenWindowList.RemoveAt(hiddenWindowIndex)
	}
	if suspendWindowIndex > 0{
		suspendWindowList.RemoveAt(suspendWindowIndex)
	}
	hideWindow({id:ahkId,mode:"top"})
}

; ===== 新增：下边隐藏 =====
^Down::{
	results := getSide()
	leftMonitor := results[1]
	rightMonitor := results[2]
	leftEdge := results[3]
	rightEdge := results[4]
	MonitorGet leftMonitor,,&leftTopEdge
	MonitorGet rightMonitor,,&rightTopEdge
	leftDPI := getDPI(leftMonitor)
	rightDPI := getDPI(rightMonitor)
	global leftEdge
	global rightEdge
	global leftTopEdge
	global rightTopEdge
	global leftDPI
	global rightDPI
	topEdge := getTopEdge()
	bottomEdge := getBottomEdge()
	global topEdge
	global bottomEdge

	ahkId := WinGetID("A")
	hiddenWindowIndex := hiddenWindowList.Find((v) => (v.id =ahkId))
	suspendWindowIndex := suspendWindowList.Find((v) => (v.id =ahkId))
	if hiddenWindowIndex >0 {
		hiddenWindowList.RemoveAt(hiddenWindowIndex)
	}
	if suspendWindowIndex > 0{
		suspendWindowList.RemoveAt(suspendWindowIndex)
	}
	hideWindow({id:ahkId,mode:"bottom"})
}

^F4::{
	Reset()
}


hideWindow(window){
	
	windowText := "ahk_id" window.id

	;最大化窗口不可隐藏
	if WinExist(windowText) and WinGetMinMax(windowText) != 1{
		DPI.WinGetPos(&X, &Y, &W, &H,windowText)
		mode := window.mode
		if mode="left"{
			NewX := -Round(W*leftDPI)+leftEdge+Round(margin*leftDPI)
			NewY := Max(Y,leftTopEdge)
			winSmoothMoveH(NewX, NewY, windowText)
		}
		else if mode="right"{
			NewX := rightEdge-Round(margin*rightDPI)
			NewY := Max(Y,rightTopEdge)
			winSmoothMoveH(NewX, NewY, windowText)
		}
		; ===== 新增上下方向 =====
		else if mode="top"{
			NewX := X
			NewY := topEdge - Round(H*leftDPI) + Round(margin*leftDPI)
			winSmoothMoveV(NewX, NewY, windowText)
		}
		else if mode="bottom"{
			NewX := X
			NewY := bottomEdge - Round(margin*leftDPI)
			winSmoothMoveV(NewX, NewY, windowText)
		}
		
		WinSetAlwaysOnTop(1, windowText)
		pushTo(hiddenWindowList,window)
	}
}

showWindow(window){
	windowText := "ahk_id" window.id
	mode := window.mode
	DPI.WinGetPos(&X, &Y, &W, &H,windowText)
	if mode="left"{
		NewX := showMargin+leftEdge
		NewY := Y
		winSmoothMoveH(NewX, NewY, windowText)
	}
	else if mode="right"{
		NewX := rightEdge-Round(showMargin*rightDPI)-Round(W*rightDPI)+5
		NewY := Y
		winSmoothMoveH(NewX, NewY, windowText)
	}
	; ===== 新增上下方向 =====
	else if mode="top"{
		NewX := X
		NewY := topEdge + showMargin
		winSmoothMoveV(NewX, NewY, windowText)
	}
	else if mode="bottom"{
		NewX := X
		NewY := bottomEdge - Round(H*leftDPI) - showMargin
		winSmoothMoveV(NewX, NewY, windowText)
	}
	pushTo(suspendWindowList,window)
}

isWindowMove(window){
	windowText := "ahk_id" window.id
	mode := window.mode
	DPI.WinGetPos(&X, &Y, &W, &H,windowText)
	if mode = "left"{
		if (X>Round(showMargin*leftDPI)+leftEdge+moveDistance){
			return 1
		}
		else{
			return 0
		}
	}
	else if mode="right"{
		if (X<rightEdge-moveDistance-Round(showMargin*rightDPI) - Round(W*rightDPI)){
			return 1
		}
		else{
			return 0
		}
	}
	; ===== 新增上下方向 =====
	else if mode="top"{
		if (Y > topEdge + showMargin + moveDistance){
			return 1
		}
		else{
			return 0
		}
	}
	else if mode="bottom"{
		if (Y < bottomEdge - Round(H*leftDPI) - showMargin - moveDistance){
			return 1
		}
		else{
			return 0
		}
	}
	return 0
}

; 列表不允许存在相同的窗口
pushTo(array,value){
	if array.Find((v) => (v.id =value.id)) <= 0{
		array.push(value)
	}
}
;从a到b的数组
createArray(a, b,length) {
	; Calculate the step to divide the range into length parts
    arr := []
    step := (b - a) / (length-1)  
    value := a
    Loop length {
        arr.Push(Round(value))
        value += step  ; Increase each value by step
    }
    arr.Push(b)
    return arr
}

; 水平平滑移动（左右，固定Y）
winSmoothMoveH(newX, newY, windowText){
	DPI.WinGetPos(&X,,, , windowText)
	arr := createArray(X, newX, 10)
	for i,v in arr{
		WinMove(v, newY,,, windowText)
	}
}

; 垂直平滑移动（上下，固定X）
winSmoothMoveV(newX, newY, windowText){
	DPI.WinGetPos(, &Y,, , windowText)
	arr := createArray(Y, newY, 10)
	for i,v in arr{
		WinMove(newX, v,,, windowText)
	}
}

; 原版兼容保留（内部调用已替换为 H/V 版本）
winSmoothMove(newX,newY,windowText){
	winSmoothMoveH(newX, newY, windowText)
}

;多显示器支持
;获取左右边界和显示器索引
getSide(){
	leftEdge := 1
	rightEdge := -1
	leftMonitor :=0
	rightMonitor :=0
	i:=1
	while i<=MonitorGetCount(){
		MonitorGet i, &leftEdgeTemp,,&rightEdgeTemp
		if leftEdge > leftEdgeTemp{
			leftEdge := leftEdgeTemp
			leftMonitor := i
		}
		if rightEdge<rightEdgeTemp{
			rightEdge:=rightEdgeTemp
			rightMonitor:=i
		}
		i+=1
	}
	return [leftMonitor,rightMonitor,leftEdge,rightEdge]
}

; ===== 新增：获取所有显示器最上边界 =====
getTopEdge(){
	topEdge := 99999
	i := 1
	while i <= MonitorGetCount(){
		MonitorGet i, , &topEdgeTemp
		if topEdgeTemp < topEdge{
			topEdge := topEdgeTemp
		}
		i += 1
	}
	return topEdge
}

; ===== 新增：获取所有显示器最下边界 =====
getBottomEdge(){
	bottomEdge := -99999
	i := 1
	while i <= MonitorGetCount(){
		MonitorGet i, , , , &bottomEdgeTemp
		if bottomEdgeTemp > bottomEdge{
			bottomEdge := bottomEdgeTemp
		}
		i += 1
	}
	return bottomEdge
}

getDPI(monitorIndex){
	monitorHandles := DPI.GetMonitorHandles()
	dpiValue := DPI.GetForMonitor(monitorHandles.Get(monitorIndex))
	dpiValue := dpiValue / 96
	return dpiValue
}
