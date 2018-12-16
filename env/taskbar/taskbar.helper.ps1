$skin = $RmAPI

function updateTaskbar {
	$open = $skin.VariableStr("taskbar.open")
	$open = $open.Split(",")

	$skin.Bang("!setOptionGroup taskbar.buttons hidden 1")

	0..($open.Length - 1) | % {
		$openName = $skin.VariableStr("concord.apps.$($open[$_]).name")
		$openImage = $skin.VariableStr("concord.apps.$($open[$_]).image")
		$openPath = $skin.VariableStr("concord.apps.$($open[$_]).path")

		$skin.Bang("!setOption taskbar.buttons.button$_ leftMouseUpAction `"[!zpos '2' $openPath][!zpos '0' $openPath]`"")
		$skin.Bang("!setOption taskbar.buttons.button$_.image imageName `"$openImage`"")
		$skin.Bang("!setOption taskbar.buttons.button$_.text text `"$openName`"")

		$skin.Bang("!setOption taskbar.buttons.button$_ hidden 0")
		$skin.Bang("!setOption taskbar.buttons.button$_.image hidden 0")
		$skin.Bang("!setOption taskbar.buttons.button$_.text hidden 0")
	}

	$skin.Bang("!update")
}

function open {
	param (
		[string]$appid
	)

	# add an app to the taskbar.open variable
}

function remove {
	param (
		[string]$appid
	)

	# remove an app from the taskbar.open variable
}
