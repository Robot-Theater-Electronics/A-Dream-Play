// guard

a = PZ_machine(s);
~revbus = Bus.audio(s,1);
~delbus = Bus.audio(s,1);

~harmonyG = {|bufnum, out| { PitchShift.ar(PlayBuf.ar(2, b['guard'][bufnum], 1, loop: 0, doneAction:2),0.2,21/24).sum * EnvGen.kr(Env.linen(4, 9)) }.play(s, outbus: out)};

(
Tdef(\r, {
	loop{
		~harmonyG.(4, ~revbus);
		2.rrand(6).wait;
		~harmonyG.(0.rrand(6), ~revbus);
		2.rrand(6).wait;
	}
}).play;

Tdef(\r, {
	loop{
		~harmonyG.(0.rrand(6), 2);
		2.rrand(2).wait;
	}
}).play
);

// fx
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 50, 19, 0.3, 0.5).sum }).stop(0,1);
Ndef(\del, {CombL.ar(In.ar(~revbus), 0.5, t.tempo/4, 9) }).stop(0,1);

Tdef.all.do{|t| t.stop;}

~perc = {|buf, amp, at=0.1, rl=1, rate=1, out| { amp*PlayBuf.ar(1, buf, rate, loop: 0, doneAction:2) *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~perc.(b['perc']['bells'][0], 1, 0.01, 4, 1, 0);


Ndef(\w, {PinkNoise.ar(0.5)}).play(0,1);