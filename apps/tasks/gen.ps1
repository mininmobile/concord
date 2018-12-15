$ran = 0

function update {
	if ($ran -eq 0) {
		$script:ran = 1

		$resources = $RmAPI.VariableStr("@")

		$tasks = $RmAPI.VariableStr("tasks.data")
		$tasks = $tasks.Split("|")

		$data = "";

		0..$tasks.Length | % {
			$taskdata = $tasks[$_].Split(",")

			$task = $taskdata[1]
			$done = $taskdata[0]

			$data += @"
[tasks.item$_]
meter = shape
meterStyle = tasks.control.item`n
"@

			if ($_ -eq 0) {
				$data += "y = 47`n"
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
	}
}
