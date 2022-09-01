// victoria
~revbus = Bus.audio(s,2);
~del = Bus.audio(s,2);
~stem = Bus.audio(s,2);
~popsynths = ();
~popsynths1 = ();
~popsynths2 = ();

(
Ndef(\del, {[In.ar(~revbus)+CombN.ar(In.ar(~revbus), t.tempo/4, t.tempo/2, 4)].sum }).play(0,1); // 2
Ndef(\del2, {[In.ar(~del)+CombN.ar(In.ar(~del), t.tempo/2, t.tempo/2, 2)].sum }).play(0,1); // 3
Ndef(\revs, {GVerb.ar (In.ar(~stem), 180, 24, drylevel:0.01).sum }).play(0,2); //3
);

MIDIIn.connectAll;
(
/*MIDIdef.noteOn(\solveigOn, {|val,num,chan,source|
	["on", val,num,chan,source].postln;
	switch(chan,
		1, { ~popsynths1[num] = {|gate=1, rate=0.01, amp=0.3|  amp*Saw.ar([num.midicps, (num-12).midicps], LFTri.kr([1/40,rate.lag(8)]).range(0.01,0.1)).sum * EnvGen.kr(Env.adsr(0.2, 0, 1, 0.2), gate, doneAction:2) }.play(s, ~stem); },
		2, { ~popsynths2[num] = {|gate=1, rate=(t.tempo*8), amp=0.3|  amp*Saw.ar([num.midicps, (num-12).midicps], LFTri.kr([t.tempo*4 ,rate.rrand(16)]).range(0.01,0.1)).sum * EnvGen.kr(Env.adsr(0.2, 0, 1, t.tempo*val), gate, doneAction:2) }.play(s, ~revbus); }
	);
});*/


MIDIdef.noteOn(\solveigOn, {|val,num,chan,source|
	["on", val,num,chan,source].postln;
	switch(chan,
		1, { ~popsynths1[num] = {|gate=1, rate=0.01, amp=0.3|  amp*Saw.ar([(num+12).midicps, (num+24).midicps], LFTri.kr([1/40,rate.lag(8)]).range(0.01,0.1)).sum * EnvGen.kr(Env.perc(0.1, 0.01), gate, doneAction:2) }.play(s, ~stem); },
		2, { ~popsynths2[num] = {|gate=1, rate=(t.tempo*8), amp=0.1|  amp*Saw.ar([num.midicps, (num-12).midicps], LFTri.kr([t.tempo*4 ,rate.rrand(16)]).range(0.01,0.1)).sum * EnvGen.kr(Env.adsr(0.2, 0, 1, t.tempo*val), gate, doneAction:2) }.play(s, ~revbus); }
	);
});


// ~popsynths1[64] = {|gate=1, rate=0.01, amp=0.3|  amp*Saw.ar([64.midicps, (64-12).midicps], LFTri.kr([1/40,rate.lag(8)]).range(0.01,0.1)).sum * EnvGen.kr(Env.adsr(0.2, 0, 1, 0.2), gate, doneAction:2) }.play(s, ~stem);

// MIDIdef.noteOn(\solveigOn_partB, {|val,num,chan,source|
// 	// ["on", val,num,chan,source].postln;
// 	switch(chan,
// 		0, { ~popsynths[num] = {|gate=1, rate=(t.tempo*8), amp=1 | amp*Saw.ar([num.midicps, (num+12).midicps]*Line.kr(1/2,1,0.1), LFTri.kr([t.tempo*4 ,rate.rrand(16)]).range(0.01,0.1)).sum * EnvGen.kr(Env.linen(0.2, 0, t.tempo*val.clip2(0.01)), gate, doneAction:2) }.play(s, ~del ); },
// 		1, { ~popsynths1[num] = {|gate=1, rate=0.01, amp=0.4| amp*Saw.ar([num.midicps, (num).midicps], LFTri.kr([1/40,rate.lag(8)]).range(0.01,0.1)).sum * EnvGen.kr(Env.adsr(0.2, 0, 1, 0.2), gate, doneAction:2) }.play(s, ~stem); },
// 		2, { ~popsynths2[num] = {|gate=1, rate=(t.tempo*8), amp=1 | amp*Saw.ar([num.midicps, (num-12).midicps], LFTri.kr([t.tempo*4 ,rate.rrand(12)]).range(0.01,0.1)).sum * EnvGen.kr(Env.linen(0.2, 0, t.tempo*val.clip2(1)), gate, doneAction:2) }.play(s, 2); }
// 	);
// });

MIDIdef.noteOff(\solveigOff, {|val,num,chan,source|
	// ["off", val,num,chan,source].postln;
	switch(chan,
		0, {  ~popsynths[num].release; },
		1, {  ~popsynths1[num].release; },
		2, { ~popsynths2[num].release; }
	);
});

~popsynths1.do{|i| i.release; }; ~popsynths2.do{|i| i.release; };

MIDIdef.cc(\t, {|val,chan, num, src|
	// [val, chan, num].postln;
	("tempo change to " ++ val).warn;
	if (val > 59) {
		t.tempo = val/60;
	};
	if (val == 100) {
		("signatire change to 3/4").warn;
		z.beats=3;
	} {
		("signature change to 4/4").warn;
		z.beats=4;
	}
},nil,9);

t.tempo=50/60;
MIDIdef.cc(\beat, {|val,num,chan, src|
	[val, num, chan].postln;
	switch(num,
		3, {
			switch(val,
				1, {
					if (z.routine.isPlaying.not) {
						z.routine.play;
					};
					z.dict=();
					z.dict['k'] = { PZ_layer2(~perc2Str, b['perc']['kick'][0],1,0.01,0.2,1,0).rhythm(2) };
					z.dict['hh'] = { PZ_layer2(~perc2, {b['perc']['hh'][0.rrand(2)]},0.5,0.01,0.5,1,{0.rrand(1)}).rhythm(1) };
				},
				2, {
					z.dict['k'] = { PZ_layer2(~perc2Str, b['perc']['kick'][0],1,0.01,0.2,1,0).rhythm([4,1,2].choose,2,2,[0,2]) };
					z.dict['hh'] = { PZ_layer2(~perc2, {b['perc']['hh'][0.rrand(2)]},0.9,0.01,0.1,1,{0.rrand(1)}).rhythm(4,[0,4],4,[0,1,0,1]) };
					z.dict['s'] = { PZ_layer2(~perc2, b['perc']['clap'],0.5,0.01,0.3,1,1).rhythm(0,1,0,1) };
					// z.dict['r'] = { PZ_layer2(~perc2, b['perc']['rim'],1,0.01,1,1,{0.rrand(1)}).rhythm([0,1],[0,0,0,1],0,[1,1]) };
					z.dict['sn'] = { PZ_layer2(~perc2, b['perc']['clap'],0.3,0.01,0.2,1,0).rhythm(0, 0, 0, [0,2,0,1]) };
				},
		)},
		9, {
			if (z.routine.isPlaying.not) {
						z.routine.play;
					};
			("part B - signature change to 3/4").warn;
			z.beats=val;
			switch(val,
				3, { z.dict['k'] = { PZ_layer(~perc2Str, b['perc']['kick'][0],1,0.01,0.2,1,0).rhythm([2,1],0,[0,1]) };},
				4, { z.dict['k'] = { PZ_layer(~perc2Str, b['perc']['kick'][0],1,0.01,0.2,1,0).rhythm([2,1],0,[0,1],[2, 4]) }; }
			);
			// z.dict['k'] = { PZ_layer(~perc2Str, b['perc']['kick'][0],1,0.01,0.2,1,0).rhythm(1,0,0,0) };
			z.dict['hh'] = { PZ_layer(~perc2, {b['perc']['hh'][1.rrand(1)]},0.9,0.01,0.1,1,{0.rrand(1)}).rhythm(0,0,[0,0,0,4]) };
			z.dict['sn'] = { PZ_layer(~perc2, b['perc']['snare'],0.5,0.01,1,1,{0.rrand(1)}).rhythm([1,0,0,1], [0, 1], 0) };
			z.dict['s'] = { PZ_layer(~perc2, b['perc']['clap'],0.5,0.01,0.3,1,1).rhythm(0,1,1) };
			z.dict['r'] = { PZ_layer(~perc2, b['perc']['rim'],0.3,0.01,1,1,{0.rrand(1)}).rhythm(0,[0,0,0,4.rrand(1)],0) };
		}
		);
},nil,10);
//
);

// beat
~perc = {|buf, amp, at=0.1, rl=1, rate=1, out| { amp*PlayBuf.ar(1, buf, rate, loop: 0, doneAction:2) *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~perc2 = {|buf, amp, at=0.1, rl=1, rate=1, out=0| { [amp*PlayBuf.ar(2, buf, rate, loop: 0, doneAction:2).sum].sum *EnvGen.ar(  Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~perc2Str = {|buf, amp, at=0.1, rl=1, rate=1, out=0| { amp*PlayBuf.ar(2, buf, rate, loop: 0, doneAction:2) *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
z = PZ_machine(s);
z.beats=4;
z.ignite;
z.dict['k'] = { PZ_layer2(~perc2Str, b['perc']['kick'][0],1 ,0.01,0.2,1,0).rhythm([4,1,2].choose,2,2,[0,2]) };
z.dict['hh'] = { PZ_layer2(~perc2, {b['perc']['hh'][0.rrand(2)]},1,0.01,0.5,1,{0.rrand(1)}).rhythm(4,[0,4],4,[0,1,0,1]) };
z.dict['s'] = { PZ_layer2(~perc2, b['perc']['clap'],1.2,0.01,0.3,1,1).rhythm(0,1,0,1) };
z.dict['r'] = { PZ_layer2(~perc2, b['perc']['rim'],1,0.01,1,1,0).rhythm([0,1],[0,0,0,1],0,[1,1]) };
z.dict['sn'] = { PZ_layer2(~perc2, b['perc']['snare'],0.6,0.01,1,1,0).rhythm(0, 0, 0, [0,2,0,1]) };

// slow beat (50bpm)
z.dict['k'] = { PZ_layer(~perc2Str, b['perc']['kick'][0],1,0.01,0.2,1,0).rhythm(1,0,0,0) };
z.dict['hh'] = { PZ_layer(~perc2, {b['perc']['hh'][1.rrand(1)]},0.9,0.01,0.1,1,{0.rrand(1)}).rhythm(0,0,[0,0,0,4]) };
z.dict['sn'] = { PZ_layer(~perc2, b['perc']['snare'],0.5,0.01,1,1,{0.rrand(1)}).rhythm([1,0,0,1], [0, 1], 0) };
z.dict['s'] = { PZ_layer(~perc2, b['perc']['clap'],0.5,0.01,0.3,1,1).rhythm(0,1,1) };
z.dict['r'] = { PZ_layer(~perc2, b['perc']['rim'],0.3,0.01,1,1,{0.rrand(1)}).rhythm(0,[0,0,0,4.rrand(1)],0) };

z.routine.play;
z.routine.stop.reset;

// ~popSynth = {|freq, gate=1, rate=4|  Saw.ar(freq.midicps, LFTri.kr([2,rate.lag(8)]).range(0.01,0.1)).sum * EnvGen.kr(Env.adsr(0.01, 0, 1, 0.2), gate, doneAction:2) }.play(s, ~revbus); // empty freq arg sounds cool.


// debug
~perc2.(b['perc']['snare'],1,0.01,1,1,3);
Ndef.all.do{|n|n.stop}

/// piano & toy piano

