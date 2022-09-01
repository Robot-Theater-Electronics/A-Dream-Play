// flower
~revbus = Bus.audio(s,2);

// from dryness -> water drops -> more water -> to the sea crying

// atmos: wind and longing for water
Ndef(\flower, {BPF.ar(WhiteNoise.ar(0.1)ring2:CombN.ar(SinOsc.ar(Demand.kr(Impulse.kr(4), 0, Drand(["c4".namecps, "d3".namecps, "e3".namecps,"f0".namecps], inf)), 0, 0.4), 0.2, 0.2,2), LFNoise1.kr(1).range(100, 2567))*0.6}).play(0,2);

~harmony = {|bufnum=1, out=0, rl=9| { PlayBuf.ar(2, b['flower'][bufnum], 0.2, loop: 0, doneAction:2) * EnvGen.kr(Env.linen(2, rl))}.play(s, outbus: out) };
~harmony.(1, ~revbus, 25);
~harmony.(0, ~revbus, 20);
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 3, 9, 1, 0.6) }).play(0,1); // 100, 80, 60, 30, 10, 0

Ndef(\flower).fadeTime_(4);
Ndef(\flower).stop(10);
Ndef(\flower).clear

// v2
Ndef(\flower, {BPF.ar(WhiteNoise.ar(0.1)ring2:CombN.ar(SinOsc.ar(Demand.kr(Impulse.kr(4), 0, Drand(["c3".namecps, "d3".namecps, "a3".namecps,"f0".namecps], inf)), 0, 0.4), 0.2, 0.2,5), LFNoise1.kr(1).range(100, 2567))*0.6}).play(0,2);


// v3
Ndef(\flower, {BPF.ar(WhiteNoise.ar(0.2)ring2:CombN.ar(SinOsc.ar(Demand.kr(Impulse.kr(4), 0, Drand(["c4".namecps, "d3".namecps, "a3".namecps,"d3".namecps], inf)), 0, 0.4), 0.2, 0.2,3), LFNoise1.kr(1/6).range(100, 3567))*0.6}).play(0,2);


// v4
Ndef(\flower, {BPF.ar(WhiteNoise.ar(0.4)ring2:CombN.ar(SinOsc.ar(Demand.kr(Impulse.kr(4), 0, Drand(["d4".namecps, "d3".namecps, "a3".namecps,"d3".namecps], inf)), 0, 0.4), 0.2, 0.1,2), LFNoise1.kr(1/3).range(100, 3567))*0.6}).play(0,2);

// v5
Ndef(\flower, {BPF.ar(WhiteNoise.ar(0.5)ring2:CombN.ar(SinOsc.ar(Demand.kr(Impulse.kr(4), 0, Drand(["d3".namecps, "d3".namecps, "d3".namecps,"d3".namecps], inf)), 0, 0.4), 0.2, 0.1,2), LFNoise1.kr(1/2).range(100, 8567))*0.6}).play(0,2);