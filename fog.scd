// Fog

Ndef(\f, {SinOsc.ar(["g1".namecps, "b2".namecps, "d1".namecps]*3*LFNoise1.kr(1/8).range(0.99, 1.03), mul:0.01)+WhiteNoise.ar(0.01*LFNoise0.kr(1/3).range(0,0.8))}).play(0,1);


Ndef(\f).fadeTime_(6);

Ndef(\f).stop(4);

// fog beat
t.tempo=123/60;
~fog = {arg amp=1, freq=230,rl=0.1; { amp*BPF.ar(WhiteNoise.ar(0.5), freq!2, 0.6) * EnvGen.kr(Env.perc(0.01, rl), doneAction:2) }.play(0) };
a = PZ_machine(s);
a.ignite;

// umbrella 1
a.dict[0] = { PZ_layer2(~fog, 3, {567.rrand(1567)}, 1).rhythm([0.rrand(1)]) };
a.dict[1] = { PZ_layer(~fog, 2, {1567.rrand(4567)}, 0.5.rrand(0.9)).rhythm(0, [0.rrand(2), 0.rrand(2)]) };
a.dict[2] = { PZ_layer(~fog, 2, {2567.rrand(6567)}, 0.5.rrand(0.9)).rhythm(0, 0, [0.rrand(1)], [0.rrand(1)]) };

a.routine.stop;

// umbrella 2
a.routine.play;
a.dict[0] = { PZ_layer2(~fog, 3, 567.rrand(4567), 0.1.rrand(1)).rhythm([0.rrand(2)]) };
a.dict[1] = { PZ_layer(~fog, 2, 1567.rrand(6567), {0.1.rrand(0.7)}).rhythm(0, [0.rrand(2), 0.rrand(2)]) };
a.dict[2] = { PZ_layer(~fog, 2, 2567.rrand(6567), 0.1.rrand(0.3)).rhythm(0, 0, [0.rrand(1)], [0.rrand(1)]) };

// fog publiek inloop
~revbus = Bus.audio(s,1);
~revbus1 = Bus.audio(s,1)

Ndef(\f1, {SinOsc.ar(["g1".namecps, "b2".namecps, "c1".namecps]*4, mul:EnvGen.kr(Env.perc, doneAction:2)).sum ring1: WhiteNoise.ar(0.01*LFNoise0.kr(1/3).range(0,0.8)) }).play([~revbus, ~revbus1].choose, addAction: \addToHead);

Ndef(\rev, {GVerb.ar(In.ar(~revbus), 99, 5).sum*0.2}).play(0,1);
Ndef(\rev1, {GVerb.ar(In.ar(~revbus1), 99, 5).sum*0.2}).play(1,1);