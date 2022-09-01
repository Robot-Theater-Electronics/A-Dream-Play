// agnes

a = PZ_machine(s);
~revbus = Bus.audio(s,2);
~delbus = Bus.audio(s,2);

// atmos
(Tdef(\r, {
	loop{
		~harmony = {PlayBuf.ar(2, b['perc']['tanpura'], [1,1.5,1/2, 5/4,3/2,1,1,1].choose, loop: 0, doneAction:2) * EnvGen.kr(Env.linen(4, 9))}.play(s, outbus: ~revbus);
		2.rrand(6).wait
	}
}).stop);

// harmonious (when she is with other characters, the hamrony grows)
~f5 = {|amp=1,at=0.1,rl=1, rate=2, out=0| { amp*Saw.ar(["f1".namecps, "c2".namecps]*rate)*0.1*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out); }
(Tdef(\r, {
	loop{
		~f5.(rl:4,rate:1);
		3.wait;
}}).play;)

// rhythmic
~pippi = {PlayBuf.ar(2, b['agnes'][0], 1, loop: 1, doneAction:2) }.play(s, outbus: 2);
~perc = {|buf, amp, at=0.1, rl=1, rate=1, out| { amp*PlayBuf.ar(1, buf, rate, loop: 0, doneAction:2) *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~perc2 = {|buf, amp, at=0.1, rl=1, rate=1, out=0| { amp*PlayBuf.ar(2, buf, rate, loop: 0, doneAction:2).sum *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
a.ignite;
t.tempo = 56/60;
a.beats=4;
a.dict['5ths'] = { PZ_layer(~f5, 0.15, 1, 0.2, ~revbus).rhythm([1,0],[0],[0],[1],[0],[1],[0]) }; // agnes
a.dict['ghatam'] = { PZ_layer(~perc, {b['perc']['ghatam'][ ~ghatam.next ]}, 0.7, 0.1, 1, 1, 2).rhythm([2.rrand(1)],[2],[2.rrand(1)],[2]) }; // alfred
a.dict['bell'] = { PZ_layer(~perc2, {b['perc']['bells'][2]},0.3, 0.1, 0.4, 1, 3).rhythm(0,1,0,[1]) }; // jenny
a.dict['dholak'] = { PZ_layer(~perc, {b['perc']['dholak']}, 0.8, 0.1, 1, 1,4).rhythm([0],0,[1],0) }; // jenny
a.dict['tabla'] = { PZ_layer(~perc, {b['perc']['tabla'][ ~tabla.next.postln ]}, 0.6, 0.1, 4, {0.9.rrand(1).round(4/12)}, 1).rhythm([4,2], [4,1], [4,1], [2,4]) } // agnes
a.dict=();
a.dict['5ths'] = ();

// 4 beats
~tabla = Pseq([Pseq([0,2,1,3,1,2], 1), Pseq([3,0,1,2,0], 1), Pseq([0,2,1,3,1], 1), Pseq([3,0,1,2,1,0], 1)],inf).asStream;
~ghatam = Pseq([0,1,2,1],inf).asStream;

//7 beats
~tabla = Pseq([Pseq([0,2,1,3,1,2], 1), Pseq([3,0,1,2,0], 1), Pseq([0,2,1,3,1], 1), Pseq([3,0,1,2,1,0], 1), 2, Pseq([2,0,2,1,2,3], 1), Pseq([1,2,3,0,1,2], 1)],inf).asStream;
~ghatam = Pseq([0,1,2],inf).asStream;


// Jenny hip hop
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
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 100, 99) }).play(0,2);
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 120, 1, 0.1, 0.1).sum }).play(0,2);

Ndef(\del, {CombL.ar(In.ar(~delbus), 0.5, t.tempo/2, 2) }).play(0,2);
