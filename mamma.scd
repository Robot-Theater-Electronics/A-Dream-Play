// mamma

a = PZ_machine(s);
~revbus = Bus.audio(s,1);
~revbus1 = Bus.audio(s,1);


~aM = ["c#3".namecps, "e3".namecps, "a3".namecps, "a4".namecps];
~gM = ["f3".namecps, "g3".namecps, "d3".namecps, "B4".namecps];
~eM = ["e3".namecps, "B3".namecps, "g#3".namecps, "e3".namecps];
~bm = ["d3".namecps, "B3".namecps, "f#3".namecps, "d3".namecps];

~prrr = {|freq, amp=1,at=4,rl=6, rate=0.001, out=0| { amp*SinOsc.ar([freq, freq/2]).distort.sum.sum*LFTri.kr(LFNoise1.kr(rate).range(1,1/5)).range(0.1, 0.3)*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out) };

~prrr.(~aM*2, 0.1, 0.1, 10, 0.1);

~perc = {|buf, amp, at=0.1, rl=1, rate=1, out| { amp*PlayBuf.ar(1, buf, rate, loop: 0, doneAction:2) *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~perc2 = {|buf, amp, at=0.1, rl=1, rate=1, out=0| { amp*PlayBuf.ar(2, buf, rate, loop: 0, doneAction:2).sum *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~perc2r = {|buf, amp, at=0.1, rl=1, rate=1, out=0| { amp*PlayBuf.ar(2, buf, LFSaw.kr(rate).range(0.5, 1.5), loop: 0, doneAction:2).sum *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }

a.ignite;
a.beats = 16;
PZ_layer2.bar = 8;
t.tempo = 115/60;
//v2
a.dict['sirens'] = { PZ_layer(~perc2, b['mum'][0], 0.8, 0.1, 14, 1, ~out.next).rhythm(1) };
a.dict['vib'] = { PZ_layer2(~perc2r, b['mum'][1], 1.1, 0.1, 4, {~v.next/8}, 0).rhythm([1], 0,0,[0,1]) };
a.dict['harm'] = { PZ_layer(~prrr, ~h.next, 0.15, 5, 4, 0.1, 0).rhythm(1,0,0,0) };
a.dict['harm2'] = { PZ_layer(~prrr, ~h2.next*2, 0.3, 5, 4, 0.1, 0).rhythm(1,0,0,[0,0,1]) };
a.dict['harmL'] = { PZ_layer2(~prrr, ~hL.next/2, 0.3, 0.1, 0.1, 0.1, 0).rhythm([3],0,0,0) };

a.dict['sirens'] = ();
//v2
a.dict['sirens'] = { PZ_layer(~perc2, b['mum'][0], 0.8, 0.1, 9, 1, 0).rhythm(1) };
a.dict['vib'] = { PZ_layer2(~perc2r, b['mum'][1], 1.1, 0.1, 4, {~v.next/8}, 0).rhythm([1], 0,0,[0,1]) };
a.dict['cuffs'] = { PZ_layer(~perc2, b['mum'][2], 1, 0.1, 4, {~r.next}, 0).rhythm(1,0,0,0,1,0,0,0) };
a.dict['vib2'] = { PZ_layer2(~perc2, b['mum'][4], 1.2, 0.1, 2, 1, 0).rhythm(0,1) };
a.dict['harm'] = { PZ_layer(~prrr, ~h.next, 0.15, 5, 4, 0.1, 0).rhythm(1,0,0,0) };
a.dict['harm2'] = { PZ_layer(~prrr, ~h2.next*2, 0.3, 5, 4, 0.1, 0).rhythm(1,0,0,[0,0,1]) };
a.dict['harmL'] = { PZ_layer2(~prrr, ~hL.next/2, 0.3, 0.1, 0.1, 0.1, 0).rhythm([3],0,0,0) };

//v3
a.dict['sirens'] = { PZ_layer(~perc2, b['mum'][0], 0.8, 0.1, 9, 1, 0).rhythm(1) };
a.dict['harm'] = { PZ_layer(~prrr, ~h.next, 0.3, 5, 4, 0.1, 0).rhythm(1,0,0,0) };
a.dict['harm2'] = { PZ_layer(~prrr, ~h2.next*2, 0.2, 5, 4, 0.1, 0).rhythm(1,0,0,[0,0,1]) };
a.dict['harmL'] = { PZ_layer2(~prrr, ~hL.next, 0.3, 0.1, 3, 0.1, 0).rhythm([3],0,0,0) };
a.dict['harmL2'] = { PZ_layer2(~prrr, ~hL.next/2, 0.1, 3, 0.1, 0.1, 0).rhythm([3],0) };

(
~v = Pseq([1,1,1,2],inf).asStream;
~r = Pseq([1.5,1],inf).asStream;
~h = Pseq([~aM, ~aM, ~eM, ~eM].stutter(1),inf).asStream;
~h2 = Pseq([~aM, ~aM, ~eM, ~eM].stutter(1),inf).asStream;
~hL = Pseq([~aM, ~aM, ~eM, ~eM].stutter(1),inf).asStream;
~hL = Pseq([~aM, ~aM, ~eM, ~eM].stutter(1),inf).asStream;
~out = Pseq([0,1],inf).asStream;
);

a.dict = ()
a.routine.stop.reset;
a.routine.play;

~perc.(b['mum'][0], 1, 0.1,4,1,0)

// harmony
~prrr.(~eM.next*2, 0.5, 4, 3, 0.1);

// dtmf
~dial = [350, 440];
~ring = [440, 480];
~busy = [480, 620];

~dtmf= Prand([[697, 1209], [697, 1336], [697, 1477],
	[770, 1209],[770, 1336],[770, 1477],
	[852, 1209],[852, 1336],[852, 1477],
	[941, 1209],[941, 1336],[941, 1477],
], inf).asStream;
~mel = Pseq(~eM++~aM, inf).asStream;
~tone = {|freq, st=0.5, amp=1,at=0, fc=1345, out=0| { amp*BPF.ar(SinOsc.ar(freq), fc, 0.5)*EnvGen.ar(Env.linen(at, st, 0.001), doneAction:2) }.play(s, out) };
~tone.(~ring);

Tdef(\ring, {
	loop{
		~tone.(~ring, 2);
		6.wait;
	}
}).play;

Tdef(\busy, {
	loop{
		~tone.(~busy, 1/2);
		1.wait;
	}
}).play;

Tdef(\dial, {
	loop{
		~tone.(~dial, 9);
		20.wait;
	}
}).play;

//
PZ_layer2.bar = 8;
a = PZ_machine(s);
n = PZ_machine(s);
n.beats=5;
a.beats=4;
r = PZ_machine(s);
d = PZ_machine(s);
d.beats=8;
r.beats=7
t.tempo_(60/60);
n.ignite;a.ignite;r.ignite;d.ignite;
a.dict['tone0'] = { PZ_layer(~tone, [440, 441]*2, 0.01, 1, 0.01, 1000, 0).rhythm(1, 0, 1, 0) };
n.dict['tone1'] = { PZ_layer(~tone, {~dtmf.next*2}, 0.01, 0.8, 0.01, {690.rrand(4230)}, 0).rhythm([1], [0,0], [0,1], [0]) };
r.dict['tone2'] = { PZ_layer(~tone, [440, 849]*4, 0.01, 0.5, 0.01, 789, 0).rhythm([0,0,1], 0, [0,1,0], 0) };
a.dict['hh'] = { PZ_layer2(~perc2, {b['perc']['hh'][~hh.next.postln]}, 0.1, 0.01, 0.2, 1, 0).rhythm([4]) };
a.dict['snare'] = { PZ_layer(~perc2, b['perc']['rim'], 0.5, 0.01, 0.02, 1, 0).rhythm([0, 1], [0,1, 0, 0], [1,0,0,1], [0,1]) };
a.dict['bd'] = { PZ_layer2(~perc2, b['perc']['kick'][0], 0.1, 0.01, 0.2, 1, 0).rhythm([1,0,0,1]) };
d.dict['toneM'] = { PZ_layer(~tone, {~dtmf.next}, {0.15.rrand(0.02).round(0.1)}, 0.1, 0, 1690, 0).rhythm([0.rrand(4),0.rrand(2)], [0.rrand(4),0.rrand(2)], [0.rrand(4),0.rrand(2)]) };
~hh = Pseq([1,1,0,0].reverse,inf).asStream;
a.dict['hh']=();
a.dict['snare']=();
a.dict['bd']=();
d.dict['toneM']=();
n.dict=();a.dict=();r.dict=();d.dict=()
Tdef(\dial).stop;
Tdef(\ring).stop;
Tdef(\busy).stop; 