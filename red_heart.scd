// heart

// normal 60 ~ 100
~t2 = TempoClock.new;
~t2.tempo
a = PZ_machine(s);
~revbus = Bus.audio(s,1);
~revbus1 = Bus.audio(s,1);

~perc = {|buf, amp, at=0.1, rl=1, rate=1, out| { amp*PlayBuf.ar(1, buf, rate, loop: 0, doneAction:2) *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~perc2 = {|buf, amp, at=0.1, rl=1, rate=1, out=0| { amp*PlayBuf.ar(2, buf, rate, loop: 0, doneAction:2).sum *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
a.ignite;
a.beats=4;
PZ_layer2.bar=4

~rate = { arg start=60, end=100, step=1, dur=10;
	Tdef(\heartrate, {
		var current=start;
		if (start < end) {
			((end-start)/step).do{
				if (current < end) { current = current + step };
				current.postln;
				t.tempo=current/60;
				(dur/(end-start)*(step)).wait;
			}
		} {
			((start-end)/step).do{
				if (current > end) { current = current - step };
				current.postln;
				t.tempo=current/60;
				(dur/(start-end)*(step)).wait;
			}
		}
	}).play(~t2);
}


a.dict['heart2'] = { PZ_layer2(~perc2, b['perc']['kick'][0], 0.3, 0.01, 0.01, 1, {~out.next}).rhythm([1,0,1]) }; // heartbeat
~out = Pseq([~revbus, ~revbus1], inf).asStream;
a.dict=();
a.routine.play;


// fx
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 300, 10).sum*0.35}).play(0,1);
Ndef(\rev1, {GVerb.ar(In.ar(~revbus1), 300, 10).sum*0.35}).play(1,1);

~rate.(100,20,1,10);
~rate.(100,150,1,10);


~am = ["c3".namecps, "e3".namecps, "a3".namecps, "a4".namecps];
~dm = ["f3".namecps, "a3".namecps, "d3".namecps, "c4".namecps];
~eM = ["e3".namecps, "B3".namecps, "g#3".namecps, "e3".namecps];
~h = Pseq((~am ++ ~am ++ ~dm ++~eM).stutter(1),inf).asStream;
~hb = Pseq((~am ++ ~am ++ ~dm ++~eM).stutter(1),inf).asStream;
~prrr = {|freq, amp=1,at=4,rl=6, rate=0.001, out=0| { amp*SinOsc.ar([freq, freq/2]*LFTri.kr(LFNoise0.kr(rate).range(8,28)).range(1, (14/12))).distort.sum*0.1*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out) };

~prrr.(~am*8, 0.1, 0.1, 10, 0.1);
~prrr.(~am*1, 0.1, 0.1, 20, 0.1);

// v2
z = PZ_machine(s);
~perc2v2 = {|buf, amp, at=0.1, rl=1, rate=1, fs=0, out=0| { amp*FreqShift.ar(PlayBuf.ar(2, buf, rate, loop: 0, doneAction:2), fs).sum *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
t.tempo=99/60
a.ignite
z.beats=8
a.beats
a.dict['cuffs'] = { PZ_layer2(~perc2v2, b['mum'][2], {2.rrand(1.5)}, 0.1, {0.1.rrand(0.4)}, 1, 8999.rrand(89), 0).rhythm([2, 1, 0, 2], 0, [0,2], [4]) };
a.dict['c'] = { PZ_layer(~perc2v2, b['mum'][2], {1.rrand(0.9)}, 0.1, {0.1.rrand(0.4)}, 1, -200.rrand(5630), 0).rhythm(1, 0, 0, 1) };
a.dict['cu'] = { PZ_layer2(~perc2v2, b['mum'][2], {1.rrand(0.86)}, 0.1, {0.1.rrand(0.4)}, 1, 0.rrand(450), 0).rhythm([0,1]) };
a.dict['cuf'] = { PZ_layer(~perc2v2, b['mum'][2], {0.9.rrand(0.66)}, 0.1, {0.1.rrand(0.4)}, 1, 0.rrand(450), 0).rhythm(0,0,[8],0) };
z.dict['cuff'] = { PZ_layer(~perc2v2, b['mum'][2], 1, 0.1, {1.rrand(1.4)}, 1, 0.rrand(10), 0).rhythm(1,1,1,0) };
z.dict['prrr'] = (); //{ PZ_layer(~prrr, {~hb.next*2}, 0.1, 0.1, 10, {2.rrand(24)}, 0).rhythm(0, [0,4], [0,1,0,0],0) };
z.dict['pr'] = { PZ_layer(~prrr, {~h.next*8}, 0.6, 0.1, 0.1, {2.rrand(24)}, 0).rhythm(0, 0, 0,0, 0, [0,4]) };
z.dict=();a.dict=();
t.tempo=49/60
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 100, 99) }).play(0,1);
~harmony = {PlayBuf.ar(2, b['perc']['tanpura'], [1,1.5,1/2, 5/4,3/2,1].choose, loop: 0, doneAction:2).sum * 0.9 * EnvGen.kr(Env.linen(9, 9))}.play(s, outbus: ~revbus);