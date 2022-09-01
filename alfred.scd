// agnes

a = PZ_machine(s);
~revbus = Bus.audio(s,2);
~delbus = Bus.audio(s,2);

// atmos: emmo synth
(Tdef(\r, {
	loop{
		~harmony = { PitchShift.ar(PlayBuf.ar(2, b['perc']['tanpura'], 1, loop: 0, doneAction:2),0.2,21/24) * EnvGen.kr(Env.linen(4, 9)) }.play(s, outbus: ~revbus);
		2.rrand(6).wait
	}
}).stop);

~emoSynth = {|gate=1, rate=4|  Saw.ar(["a1".namecps, "c2".namecps, "e2".namecps], LFTri.kr([2,rate.lag(8)]).range(0.01,0.1)).sum * EnvGen.kr(Env.adsr(8, 0, 1, 9).circle, gate, doneAction:2) }.play(s, ~revbus);
~emoSynth.set(\rate, 4);
~emoSynth.release;

// albert is in Am, mainly
~f5 = {|amp=1,at=0.1,rl=1, rate=1, out=2, notes| { amp*Saw.ar(notes*rate)*0.1*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out); }
(Tdef(\r, {
	loop{
		~f5.(rl:4,rate:1, notes:["a1".namecps, "e2".namecps]);
		4.wait;
}}).stop;)

// rhythmic
~emobass = {|amp=1,at=0.1,rl=1, rate=1, out=2, notes| { amp*Saw.ar(notes*rate)*0.1*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out); }
a.ignite;
t.tempo = 77/60;
a.beats=4;
a.dict['bass'] = { PZ_layer2(~emobass, 1, 0.1, 0.2, {~transposition.next},0, {~notes.next}).rhythm(4) };
a.dict=();

// bass melody
~transposition = Pseq([Pseq([1], 248), Pseq([2,2,1,2], 2)], inf).asStream;
(~notes = Pseq([ Pseq([["f1".namecps, "c2".namecps]],14),
	Pseq([["a1".namecps, "e2".namecps]],2),
	Pseq([["g1".namecps, "d2".namecps]],14),
Pseq([["a1".namecps, "e2".namecps]],2),
Pseq([["b1".namecps, "f2".namecps]],14),
Pseq([["a1".namecps, "e2".namecps]],2),
Pseq([["f1".namecps, "c2".namecps]],14),
Pseq([["c1".namecps, "g2".namecps]],2),
],inf).asStream);

//7 beats
~tabla = Pseq([Pseq([0,2,1,3,1,2], 1), Pseq([3,0,1,2,0], 1), Pseq([0,2,1,3,1], 1), Pseq([3,0,1,2,1,0], 1), 2, Pseq([2,0,2,1,2,3], 1), Pseq([1,2,3,0,1,2], 1)],inf).asStream;
~ghatam = Pseq([0,1,2],inf).asStream;


// hip hop
z = PZ_machine(s);
z.beats=16;
z.ignite;
a.beats=4;
a.ignite;
t.tempo = 78/60;
a.dict['k'] = { PZ_layer2(~perc, b['perc']['dholak'],0.6,0.01,0.5,1,0).rhythm(1,0,2,0) };
a.dict['k2'] = { PZ_layer2(~perc, b['perc']['ghatam'][0],0.8,0.01,0.5,1,0).rhythm(1,0,2,0) };
a.dict['s'] = { PZ_layer2(~perc2, b['perc']['clap'],0.4,0.01,0.3,1,0).rhythm(0,0.rrand(1),0,1) };
a.dict['hh'] = { PZ_layer2(~perc2, {b['perc']['bells'][0.rrand(2)]},1,0.01,0.3,1,0).rhythm([2.rrand(0),0.rrand(1)]) };
a.dict['s1'] = { PZ_layer2(~perc2, {b['agnes'][3]}, 0.3, 0.1, 2, {~s1.next}, ~revbus).rhythm(2,0,0,0) };
z.dict['s2'] = { PZ_layer(~perc2, {b['agnes'][1]}, 1, 0.1, 2, 1, ~delbus).rhythm([2],0,0,0) };
z.dict['s3'] = { PZ_layer2(~perc2, {b['agnes'][[1,2].choose]}, 1, 0.1, {0.4.rrand(0.2)}, [1/4,1/2].choose, 0).rhythm(2) };

z.dict=();
a.dict=();

~s1 = Pseq([1/2, 1, 1/2, 3/2],inf).asStream;

// fx
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 100, 29, 1, 0.6) }).play(2,1);
Ndef(\del, {CombL.ar(In.ar(~delbus), 0.5, t.tempo/2, 2) }).play(2,1);


// core

~f5 = {|amp=0.1,at=0.1,rl=1, rate=1, out=2, notes| { amp*SinOsc.ar(notes*LFPulse.kr(rate).range(1, 2).lag(0.01))*0.1*LFNoise1.kr(1/7).range(0.3, 1)*EnvGen.ar(Env.perc(at, rl).circle, doneAction:2) }.play(s, out); }

// alfred
~f5.(0.5,3,30,23,0,["c1".namecps, "a3".namecps]);
// jenny
~f5.(0.5,3,30,22,0,["c4".namecps, "c3".namecps]);
// agnes
~f5.(0.5,3,30,12,0,["g1".namecps, "f3".namecps]);


// agnes + alfred moments
Ndef.all.do{|n| n.stop(4); };Tdef.all.do{|n| n.stop(4); };a.dict=();
a.ignite;
t.tempo = 69/60;
~emobass = {|amp=1,at=0.1,rl=1, rate=1, out=2, notes| { amp*SinOsc.ar(notes*rate).sum*0.1*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out); }
a.dict['bass'] = { PZ_layer2(~emobass, 1.5, 0.01, 0.4, 1,0, ["e1".namecps, "c2".namecps]).rhythm([4.rrand(0),3.rrand(0)], 0,0,0) };
(Tdef(\r, {
	loop{
		~harmony = {PlayBuf.ar(2, b['perc']['tanpura'], [4/3,1.5,1/2, 5/4,3/2,1,1,1].choose, loop: 0, doneAction:2) * 0.1 * EnvGen.kr(Env.linen(9, 1))}.play(s, outbus: ~revbus);
		0.4.wait;
	}
}).play);
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 290, 49, 0.5, 0.1, 35, 0.1, 1, 1).sum }).play(1,1);

