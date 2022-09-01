/// incidental sounds

/// Helicopter
~heliIn = Bus.audio(s,1);
SynthDef(\heli, { arg inbus, out=0, lvl=4, rate=0.25, gate=1;
	var in, env;
	in= PanAz.ar(4, In.ar(inbus), LFSaw.kr(rate).range(-1, 1), lvl);
	env = EnvGen.kr(Env.adsr(releaseTime:10), gate, doneAction:2);
	Out.ar(out, in*env);
}).store;

Ndef(\heli, {LPF.ar(WhiteNoise.ar(1)*LFPulse.kr(Line.kr(9, 1/4, 20), width: LFNoise0.kr(1).range(0.15, 0.22)).range(0,1), LFNoise2.kr(1/5).range(100, 90))}).play(~heliIn, 1);

h = Synth(\heli, [\lvl, 10, \inbus, ~heliIn], s, \addToTail);
h.set(\lvl, 38);
h.release;
h.free;

{BPF.ar(PlayBuf.ar(2, b['perc']['tanpura'], [0.8,0.9,0.85], loop: 0, doneAction:2), LFSaw.kr(1).range(1800, 678), 0.1) * EnvGen.kr(Env.linen(4, 9))}.play(s, outbus: ~revbus);
{BPF.ar(PlayBuf.ar(2, b['flower'][2], 1, loop: 1, doneAction:2), LFSaw.kr(1).range(1200, 678), 0.2) * EnvGen.kr(Env.linen(4, 9).circle)}.play(s, outbus: 0);

Ndef(\rev, {GVerb.ar(In.ar(~revbus), 290, 29) }).play(0,2);


/// glass of water
{ BPF.ar(PlayBuf.ar(2, b['flower'][1], 1.rrand(0.8), 1, BufFrames.kr(b['flower'][1])*0.7, loop: 0, doneAction:2), 1567, 0.3) * 10 * EnvGen.kr(Env.linen(4, 9)) }.play(s, outbus: ~revbus);
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 32, 92)*0.4 }).play(0,2);


// some moment
a.dict['toneM'] = { PZ_layer2(~tone, {~dtmf.next*4}, 0.01, 0.4, 0.01, {690.rrand(4230)}, 0).rhythm([2], [0,2], [4], [0,2]) };


// poster print

// poster print make 1 big sound that last 10sec ca. !!!!
a = PZ_machine(s);
a.dict = ();
~perc = {|buf, amp, at=0.1, rl=1, rate=1, out| { amp*PlayBuf.ar(1, buf, rate, loop: 0, doneAction:2) *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~perc2 = {|buf, amp, at=0.1, rl=1, rate=1, out=0| { amp*PlayBuf.ar(2, buf, rate, loop: 0, doneAction:2).sum *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~revbus = Bus.audio(s,1);
~revbus1 = Bus.audio(s,1)

Ndef(\rev, {GVerb.ar(In.ar(~revbus), 300, 10).sum*0.8}).play(1,1);

// bug poster
Tdef(\poster, {
	{
Ndef(\pos, {GVerb.ar(PlayBuf.ar(2, b['poster'][3], 0.7, loop: 0, doneAction:2).sum*EnvGen.kr(Env.linen(4,2,3)), 278, 7)}).play(0);
		2.wait;
Ndef(\post, {GVerb.ar(PlayBuf.ar(2, b['poster'][2], 1, loop: 0, doneAction:2).sum*EnvGen.kr(Env.linen(0,4,0.1)), 278, 27)}).play(0);
Ndef(\poste, {GVerb.ar(PlayBuf.ar(2, b['poster'][2], 0.5, loop: 0, doneAction:2).sum*EnvGen.kr(Env.linen(0,4,0.1)), 278, 27)}).play(0);
		2.wait;
		Ndef(\p, {GVerb.ar(PlayBuf.ar(2, b['poster'][0], 1, loop: 0, doneAction:2).sum*EnvGen.kr(Env.linen(4,2,3)), 278, 7)}).play(0);
Ndef(\po, {GVerb.ar(PlayBuf.ar(2, b['poster'][1], 1, loop: 1, doneAction:2).sum*EnvGen.kr(Env.linen(4,0.1,5), doneAction:0), 278, 7)}).play(0);
}.fork;
}).play;

a.ignite;
a.dict['0'] = { PZ_layer(~perc2, b['poster'][0], 1, 0.1, 14, 0.4, 0).rhythm(1) };
a.dict['1'] = { PZ_layer(~perc, b['poster'][1], 1, 0.1, 14, 0.7, 1).rhythm([2],0,1,0) };
a.dict['2'] = { PZ_layer(~perc2, b['poster'][2], 1, 0.1, 14, 0.7, 2).rhythm([0],0,1,0) };
a.dict['3'] = { PZ_layer(~perc, b['poster'][3], 1, 0.1, 14, 1, 3).rhythm([0],1,0,0) };

a.dict['r'] = { PZ_layer(~perc, b['poster'][2], 1, 0.1, 14, 1, ~revbus).rhythm([0],1,0,0) };

Ndef(\f, {Line.kr(0.1, 3, 10)*Formant.ar([Demand.kr(Impulse.kr(2), 0, Dseq(["g2".namecps, "a2".namecps, "b2".namecps, "c3".namecps]*2, inf)).lag(0.1), Demand.kr(Impulse.kr(1/8), 0, Dseq(["c2".namecps, "d2".namecps], inf)).lag(1), Demand.kr(Impulse.kr(1/6), 0, Dseq(["g2".namecps, "a1".namecps], inf)).lag(1)]*4, LFNoise0.kr(1).range(1499, 2345).lag(2), mul:0.1*LFNoise1.kr(1/2).range(0.1, 0.5)).sum}).play(0,1);

Ndef(\f, {3*Formant.ar(["g2".namecps*4,"d2".namecps*4, "b2".namecps*4], LFNoise0.kr(1).range(1499, 2345).lag(2), mul:0.1*LFNoise1.kr(2).range(0.1, 0.5))}).play(0,1);
Ndef.all.do{|n| n.stop(20); };
a.routine.stop;
// bells

Ndef(\bell0, {GVerb.ar(PlayBuf.ar(2, b['bells'][0], 1, loop: 0, doneAction:2).sum*0.3, 278, 7)}).play(0,1);
Ndef(\bell1, {GVerb.ar(PlayBuf.ar(2, b['bells'][1], 1, loop: 0, doneAction:2).sum*0.8, 78, 1)}).play(1,1);
Ndef(\bell3, {GVerb.ar(PlayBuf.ar(2, b['bells'][2], 1, loop: 0, doneAction:2).sum, 18, 2)}).play(2,1);

Ndef.all.do{|n| n.stop(4); };
Tdef.all.do{|n| n.stop(4); };

// gibber
Ndef(\gibber, {BPF.ar(PlayBuf.ar(2, b['bigeye']['dialogue'][1], 3, loop: 1, doneAction:2).sum, 789, 0.3)*5}).play(0,1);


// helping sound:
~delbus1 = Bus.audio(s,1);
~delbus2 = Bus.audio(s,1);
Ndef(\del, {CombL.ar(In.ar(~delbus1), 0.5, t.tempo/2, 4) }).play(0,1);
Ndef(\del2, {CombL.ar(In.ar(~delbus2), 0.5, t.tempo/2, 4) }).play(1,1);

~f5 = {|amp=1,at=0.1,rl=1, rate=2, freqs, out=0| { amp*Saw.ar(freqs*rate).sum*0.1*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out); }
~int1 = Pseq([Pseq((4..1),1), Pseq([1], inf)], inf).asStream;
~int2 = Pseq([Pseq((5..1),1), Pseq([1], inf)], inf).asStream;
(
Tdef(\r, {
	loop{
				~int1.next.wait;
	 	~f5.(1,0.1,1,4,["f1".namecps, "c2".namecps, "f2".namecps, "d2".namecps],~delbus);
}}).play(quant:0));

(Tdef(\h2, {
	loop{
						~int2.next.wait;
	 	~f5.(1,0.1,1,4,["a1".namecps, "e2".namecps, "a2".namecps, "f2".namecps],~delbus);
}}).play(quant:0);)

Tdef.all.do{|t| t.stop}

// manual
Tdef(\mx, {
	var wa=2.5;
	loop{
		if (wa > 0) {
			wa = wa-(0.3.rrand(0.5));
		} {
			wa = 0;
			Tdef(\mx).stop;Tdef(\h0).play;
		};
~f5.(1,0.1,1,4,["f1".namecps, "c2".namecps, "f2".namecps, "d2".namecps],~delbus1);
		(wa+0.01).wait;
~f5.(1,0.1,1,4,["a1".namecps, "e2".namecps, "a2".namecps, "f2".namecps],~delbus2);
		(wa+0.01).wait;
	}
}).play;


Tdef(\h0, {
~f5.(1,0.3,8,4,["f1".namecps, "c2".namecps, "f2".namecps, "d2".namecps],~delbus1);
~f5.(1,0.3,8,4,["a1".namecps, "e2".namecps, "a2".namecps, "f2".namecps],~delbus2);
});


// Door
(Tdef(\d, {
	loop{
		{PlayBuf.ar(2, b['perc']['tanpura'], [4/3,1.5,1/2, 5/4,3/2,1,1/2,1].choose, loop: 0, doneAction:2) * 0.1 * EnvGen.kr(Env.linen(9, 1))}.play(s, outbus: ~revbus);
		0.3.wait;
	}
}).play);
(Tdef(\do, {
	loop{
		{PlayBuf.ar(2, b['perc']['tanpura'], [4/3,1.5,1/2, 5/4,3/2,1,1,1].choose, loop: 0, doneAction:2) * 0.1 * EnvGen.kr(Env.linen(3, 1))}.play(s, outbus: ~revbus);
		3.wait;
	}
}).play);
(Tdef(\doo, {
	loop{
		{PlayBuf.ar(2, b['perc']['tanpura'], [8/3,3,1, 10/4,6/2,2,2,2].choose, loop: 0, doneAction:2) * 0.1 * EnvGen.kr(Env.linen(9, 1))}.play(s, outbus: ~revbus);
		0.2.wait;
	}
}).play);
(Tdef(\door, {
	loop{
		{PlayBuf.ar(2, b['perc']['tanpura'], [4/3,1.5,1/2, 5/4,3/2,1,1,1].choose, loop: 0, doneAction:2) * 0.1 * EnvGen.kr(Env.linen(9, 1))}.play(s, outbus: ~revbus);
		8.wait;
	}
}).play);
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 290, 49, 0.5, 0.1, 35, 0.1, 1, 1) }).play(0,2);

Tdef.all.do{|t| t.stop}