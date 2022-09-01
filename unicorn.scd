// Unicorn

// beat request:

// 30bpm 80Hz

a = PZ_machine(s);
~revbus = Bus.audio(s,2);
~delbus = Bus.audio(s,2);

// rhythmic in 7
~tabla = Pseq([Pseq([0,2,1,3,1,2], 1), Pseq([3,0,1,2,0], 1), Pseq([0,2,1,3,1], 1), Pseq([3,0,1,2,1,0], 1)],inf).asStream;
~ghatam = Pseq([0,1,2,1,2],inf).asStream;
~perc = {|buf, amp, at=0.1, rl=1, rate=1, out| { amp*PlayBuf.ar(1, buf, rate, loop: 0, doneAction:2) *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~perc2 = {|buf, amp, at=0.1, rl=1, rate=1, out=0| { amp*PlayBuf.ar(2, buf, rate, loop: 0, doneAction:2).sum *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
a.ignite;
t.tempo = 30/60; // tempo 60bpm is cool
a.beats=7;
PZ_layer2.bar=7


~f5 = {|amp=1,at=0.1,rl=1, rate=1, out=0| { amp*Saw.ar([LFSaw.kr(rate).range(75, 85)])*0.1*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out); }
~f5.(3, 0.01, 7, 42);

a.dict['bell'] = { PZ_layer2(~perc2, {b['perc']['bells'][0.rrand(1)]},1, 0.1, 4, 1, 0).rhythm([[4,2].choose]) }; // jenny
a.dict['ghatam'] = { PZ_layer2(~perc, {b['perc']['ghatam'][ ~ghatam.next ]}, 0.7, 0.1, 1.4, 1, 0).rhythm([2,4]) }; // alfred
a.dict['dholak'] = { PZ_layer(~perc, {b['perc']['dholak']}, 1, 0.01, 3, 1, ~revbus).rhythm([2],0,0,[2],0,[4],0) }; // jenny
a.dict['tabla'] = { PZ_layer(~perc, {b['perc']['tabla'][ ~tabla.next ] }, 0.6, 0.1, 4, {0.9.rrand(1).round(4/12)}, 0).rhythm(0,0,0,0,0,0,[0.rrand(2),0.rrand(2),0.rrand(2),0.rrand(2),0.rrand(2),0.rrand(2),0.rrand(2),0.rrand(2)]) } // agnes
a.dict['80hz'] = { PZ_layer(~f5, 3, 0.01, 7, 42, 0).rhythm(1,0,0,1,1,1,0) }; // bass
a.dict['80hz1'] = { PZ_layer(~f5, 0.5, 0.01, 3, 42, ~delbus).rhythm(1,0,0,1,1,1,0) }; // bass
a.dict=();
a.dict['tabla'] = ();

a.routine.play

// in 4;
a.beats=4;
PZ_layer2.bar=4
~s5 = {|amp=1,at=0.1,rl=1, rate=1, freq=80, out=0| { amp*Saw.ar(LFSaw.kr(rate).range(freq*5/4, freq)*Line.kr(1,2,1))*0.1*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out); }
~freqs = Pseq(["f3".namecps, "f3".namecps, "g3".namecps, "g4".namecps],inf).asStream;
a.dict['80hz'] = { PZ_layer(~f5, 3, 0.01, 7, 42, 0).rhythm([1]) }; // bass
a.dict['synth'] = { PZ_layer2(~s5, 1.4, 0.01, 5, 12, {~freqs.next}, 0).rhythm([4], 0, 0,0) }; // synth
a.dict['kick'] = { PZ_layer2(~perc2, {b['perc']['kick'][1]},0.5, 0.01, 0.1, 1, 0).rhythm([1,1,0,1], 0, [1,1,0,1], 0) }; // kick
a.dict['clap'] = { PZ_layer2(~perc2, {b['perc']['clap']},0.3, 0.01, 1, 1, 0).rhythm([0, 2.rrand(1), 0, 2.rrand(0)]) }; // kick

a.dict['80hz'] = ();

a.routine.stop

// fx
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 100, 9) }).play(0,1);
Ndef(\del, {CombL.ar(In.ar(~delbus), 0.5, t.tempo/2, 2) }).play(0,1);


// unicorn as transformer
Ndef(\pappa, {FreeVerb.ar(PlayBuf.ar(2, b['unicorn']['dad'], 1, loop: 0, doneAction:2)*0.4, 1, 1).sum}).play(0,1);

Ndef(\mamma, {FreeVerb.ar(PlayBuf.ar(2, b['unicorn']['mamma'], 1, loop: 0, doneAction:2)*1, 1, 1).sum}).play(0,1);

Ndef(\mamma).play;a.routine.play;

Ndef(\viktoria, {FreeVerb.ar(PlayBuf.ar(2, b['unicorn']['viktoria'], 1, loop: 0, doneAction:2)*1, 1, 1).sum}).play(0,1);
Ndef(\viktoria).stop
Ndef(\viktoria).play;a.routine.play;

Ndef(\viktoria, {FreeVerb.ar(PlayBuf.ar(2, b['unicorn']['viktoria_e'], 1, loop: 0, doneAction:2)*1, 1, 1).sum}).play(0,1);



// criminal
Ndef(\agnes, {GVerb.ar(PlayBuf.ar(2, b['unicorn']['criminal'], 1, loop: 0, doneAction:0)*Line.kr(0,1,0.2), 230, 99).sum}).play(0,1);
