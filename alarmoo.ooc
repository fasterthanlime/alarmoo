import structs/[Array, ArrayList], os/Process, os/Time

AlarmClock: class {

	cmd: ArrayList<String>

	init: func (=cmd) {
		cmd add(0, "mplayer")
	}

	ring: func -> Int {
		SubProcess new(cmd data) execute()
	}

}

main: func (args: Array<String>) {

	if(args size() <= 3) {
		printf("Syntax: %s hour min file.mp3 [file2.mp3 ...]\nNote: hour must be in 24H format\n", argv[0])
		exit(0)
	}
	
	hour := args[1] toInt()
	min := args[2] toInt()
	
	files := ArrayList<String> new()
	for(i in 3..args size())
		files += args[i]
	
	if(hour < 0 || hour >= 24) {
		"Hour must be in 24H format, between 0 and 23\n" println()
		exit(1)
	}
	
	if(min < 0 || min >= 59) {
		"Min must be between 0 and 59" println()
		exit(1)
	}
	
	clock := AlarmClock new(files)
	
	target := hour * 60 + min;
	while(Time hour() * 60 + Time min() < target) {
		printf("Time: %02d:%02d:%02d  %d\t\tTarget: %02d:%02d  %d\n", Time hour(), Time min(), Time sec(), Time hour() * 60 + Time min(), hour, min, target)
		Time sleepSec(1)
	}
	printf("Time: %02d:%02d:%02d\t\tTarget: %02d:%02d reached! Ringing   \n", Time hour(), Time min(), Time sec(), hour, min);
	
	clock ring()
}
