// big eye
~revbus = Bus.audio(s,2);
~del = Bus.audio(s,2);
~del1 = Bus.audio(s,1);
Ndef(\a, {4*FreqShift.ar(PitchShift.ar(PlayBuf.ar(2, b['bigeye'][1], 1, loop: 0, doneAction:2), 0.1, [1, 0.9]), [-223,134,-42]).sum }).play(0,1);
Ndef(\b, {4*FreqShift.ar(PitchShift.ar(PlayBuf.ar(2, b['bigeye'][1], 1, loop: 0, doneAction:2), 0.1, [1.2,1]),-334) }).play(~revbus,2);
Ndef(\c, {4*FreqShift.ar(PitchShift.ar(PlayBuf.ar(2, b['bigeye'][1], 1, loop: 0, doneAction:2), 0.1, [1.1,0.95]), [-76, 8]) }).play(~del,2);


/////// big eye sounds
Ndef(\b).fadeTime_(1);Ndef(\i).fadeTime_(3);Ndef(\g).fadeTime_(5);
Ndef(\b, {4*PitchShift.ar(Compander.ar(PlayBuf.ar(2, b['bigeye'][1], 1, loop: 0, doneAction:2), PlayBuf.ar(2, b['bigeye'][1], 1, loop: 0, doneAction:2), 0.1, 2), 0.1, [1, 5/4])}).play(0,2);
Ndef(\i, {4*PitchShift.ar(Compander.ar(PlayBuf.ar(2, b['bigeye'][2], 1, loop: 0, doneAction:2), PlayBuf.ar(2, b['bigeye'][1], 1, loop: 0, doneAction:2), 0.1, 2), 0.1, [1, 5/4])}).play(0,2);


Tdef(\r, {
	var out = Prand([0, ~revbus, ~del, 0, 0],inf).asStream;
	loop{
		Ndef(\b, {0.5*PitchShift.ar(Compander.ar(PlayBuf.ar(2, b['bigeye'][3.rrand(7)], 1, loop: 0, doneAction:2), PlayBuf.ar(2, b['bigeye'][1], 1, loop: 0, doneAction:2), 0.1, 2), 0.1, [1, 5/4]).sum}).play(out.next,1);
		(9.rrand(6).wait;);
	}
}).play;

Tdef(\r2, {
		var out = Prand([0, ~revbus, ~del, 0],inf).asStream;
	loop{
		Ndef(\i, {0.5*PitchShift.ar(Compander.ar(PlayBuf.ar(2, b['bigeye'][0.rrand(3)], 1, loop: 0, doneAction:2), PlayBuf.ar(2, b['bigeye'][1], 1, loop: 0, doneAction:2), 0.1, 2), 0.1, [1, 3/2]).sum}).play(out.next,1);
		(10.rrand(6).wait;);
	}
}).play;

Tdef(\r3, {
		var out = Prand([0, ~revbus, ~del, 0, 0, 0],inf).asStream;
	loop{
		Ndef(\i, {0.5*PitchShift.ar(Compander.ar(PlayBuf.ar(2, b['bigeye'][0.rrand(7)], 1, loop: 0, doneAction:2), PlayBuf.ar(2, b['bigeye'][1], 1, loop: 0, doneAction:2), 0.1, 2), 0.1, [1, 5/6]).sum}).play(out.next,1);
		(4.rrand(16).wait;);
	}
}).play;a

Tdef(\r0, {
	loop{
		Ndef(\b, {0.5*PitchShift.ar(Compander.ar(PlayBuf.ar(2, b['bigeye'][3.rrand(4)], 1, loop: 0, doneAction:2), PlayBuf.ar(2, b['bigeye'][1], 1, loop: 0, doneAction:2), 0.1, 2), 0.1, [1, 5/4]).sum}).play(0,1);
		(5.rrand(8).wait;);
	}
}).play;


/// harmony:


Ndef(\f, {Formant.ar([Demand.kr(Impulse.kr(1/3), 0, Dseq(["f#1".namecps, "d#2".namecps, "f1".namecps], inf)).lag(1), Demand.kr(Impulse.kr(1/8), 0, Dseq(["c#2".namecps, "c#1".namecps], inf)).lag(1), Demand.kr(Impulse.kr(1/6), 0, Dseq(["g#2".namecps, "a#1".namecps], inf)).lag(1)]*4, LFNoise0.kr(1).range(1499, 2345).lag(2), mul:0.1*LFNoise1.kr(1/2).range(0.1, 0.5)).sum}).play(0,1);


Ndef(\rev, {BPF.ar(GVerb.ar(In.ar(~revbus), 178, 24), 434) }).play(0,1);
Ndef(\del, {BPF.ar(CombN.ar(In.ar(~del), 1, 0.7, 24), 1600) }).play(0,1);

Tdef.all.do{|t| t.stop}
Ndef.all.do{|t| t.stop(6)}

// dialogue
Ndef(\b, {4*FreqShift.ar(PitchShift.ar(PlayBuf.ar(2, b['bigeye']['dialogue'][0], 1, loop: 0, doneAction:2), 0.1, [1, 0.9]), [-223,134,-42]).sum }).play(0,1,group:s, addAction:'addToHead');
Ndef(\bi, {4*FreqShift.ar(PitchShift.ar(PlayBuf.ar(2, b['bigeye']['dialogue'][0], 1, loop: 0, doneAction:2), 0.1, 1), [2]).sum }).play(0,1,group:s, addAction:'addToHead');
Ndef(\big, {1*FreqShift.ar(PitchShift.ar(PlayBuf.ar(2, b['bigeye']['dialogue'][0], 1, loop: 0, doneAction:2), 0.1, [1.2,1]),-334) }).play(~revbus,2,group:s, addAction:'addToHead');
Ndef(\bige, {2*FreqShift.ar(PitchShift.ar(PlayBuf.ar(2, b['bigeye']['dialogue'][0], 1, loop: 0, doneAction:2), 0.1, [1.1,0.95]), [-76, 8]) }).play(~del1,2,group:s, addAction:'addToHead');
Ndef(\rev, {BPF.ar(GVerb.ar(In.ar(~revbus), 178, 24), 434).sum }).play(1,2);
Ndef(\deleye, {BPF.ar(CombN.ar(In.ar(~del1), 1, 0.7, 24), 1600) }).play(3,2);




