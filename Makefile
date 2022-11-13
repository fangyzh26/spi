all:com sim verdi

com:
	vcs -full64 -debug_all -sverilog\
		-timescale=1ns/10ps\
		-fsdb +dedine+FSDB\
		-l com.log\
		-f file.list

sim:
	./simv -l sim.log
	
dve:
	dve -full64 -vpd vcdplus.vpd &

verdi:
	verdi -f file.list -ssf *.fsdb -nologo &

clean:
	rm -rf csrc *.log *.key *simv* *vpd *DVE*
	rm -rf verdiLog *.fsdb *.bak *.conf work
