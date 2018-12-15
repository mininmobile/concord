function generate {
	param (
		[string]$customtasks
	)

	$resources = $RmAPI.VariableStr("@")

	if ($customtasks) { $tasks = $customtasks } else { $tasks = $RmAPI.VariableStr("tasks.data") }
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
text = $($task)`n
"@

		Set-Content -Path ($resources + "data\tasks.items.inc") -Value $data
	}

	$RmAPI.Bang("!refresh")
}

function complete {
	param (
		[string]$ctask
	)

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
!writeKeyValue variables tasks.data "$($tasks)" "$($resources)data\tasks.inc"
"@)

	generate $tasks
}
