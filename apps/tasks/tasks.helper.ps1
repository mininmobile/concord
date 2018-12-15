function generate {
	param (
		[string]$customtasks
	)

	$resources = $RmAPI.VariableStr("@")

	$tasks = if ($customtasks) { $customtasks } else { $RmAPI.VariableStr("tasks.data") }

	$RmAPI.Bang(@"
!writeKeyValue variables tasks.data "$tasks" "$($resources)data\tasks.inc"
"@)

	$tasks = $tasks.Split("|")

	$data = "";

	0..($tasks.Length - 1) | % {
		$taskdata = $tasks[$_].Split(",")

		$task = $taskdata[1]
		$done = $taskdata[0]

		$data += @"
[tasks.item$_]
meter = shape
meterStyle = tasks.control.item
leftMouseUpAction = [[generator:Invoke(complete "$($task)")]]`n
"@

		if ($_ -eq 0) {
			$data += "y = 54`n"
		}

		if ($done -eq "1") {
			$data += "completed = fill color 0, 0, 0`n"
		}

		$data += @"
[tasks.item$_.text]
meter = string
meterStyle = tasks.control.item.text
text = $($task)`n`n
"@
	}
	
	Set-Content -Path ($resources + "data\tasks.items.inc") -Value $data

	$RmAPI.Bang("!refresh")
}

function complete {
	param (
		[string]$ctask
	)

	if ($RmAPI.VariableStr("tasks.mode") -eq "1") { remove $ctask; return $null }

	$resources = $RmAPI.VariableStr("@")

	$tasks = $RmAPI.VariableStr("tasks.data")
	$temp = $tasks.ToCharArray()

	# toggle complete status
	$done = $temp[$tasks.IndexOf($ctask) - 2]
	if ($done -eq "1") { $done = "0" } else { $done = "1" }
	$temp[$tasks.IndexOf($ctask) - 2] = $done

	# set new tasks
	$tasks = $temp -join ""
	$RmAPI.Bang(@"
!writeKeyValue variables tasks.data "$tasks" "$($resources)data\tasks.inc"
"@)

	generate $tasks
}

function remove {
	param (
		[string]$rtask
	)

	$resources = $RmAPI.VariableStr("@")

	$tasks =  $RmAPI.VariableStr("tasks.data")
	$tasks = $tasks.Split("|")

	$data = "";

	0..($tasks.Length - 1) | % {
		$task = $tasks[$_].Split(",")[1]

		if ($rtask -ne $task) {
			$data += $tasks[$_]

			if ($_ -ne $tasks.Length - 1) { $data += "|" }
		}
	}

	if ($data.EndsWith("|")) {
		$data = $data.Substring(0, $data.Length - 1)
	}

	$RmAPI.Bang(@"
!writeKeyValue variables tasks.data "$data" "$($resources)data\tasks.inc"
"@)

	generate $data
}
