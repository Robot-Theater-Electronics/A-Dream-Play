// father (matress commercial style)

a = PZ_machine(s);
~revbus = Bus.audio(s,2);
~rev2 = Bus.audio(s,2);
~del = Bus.audio(s,2);

// chords:
~cM = ["c3".namecps, "e3".namecps, "g3".namecps, "c4".namecps];
~fM = ["f3".namecps, "a3".namecps, "c3".namecps, "c4".namecps];
~gM = ["b3".namecps, "d3".namecps, "g3".namecps, "f3".namecps];

~prog = Pseq([Pseq([~cM],4), Pseq([~cM],4), Pseq([~cM, ~cM, ~fM, ~fM]), Pseq([~cM],4*2), Pseq([~gM],4*2)], inf).asStream; // || C | C | C | C _ _ F | C | C | G | G ||
~arp = Pseq([Pseq(~cM*2,10*2), Pseq(~cM++~cM.reverse*2,10+5), Pseq(~fM++~fM.reverse*2,5), Pseq(~cM*2,10*2), Pseq(~gM++~gM.reverse*2,10*2)], inf).asStream;

~bed = {|freq, amp=1,at=4,rl=6, rate=0.001, out=0| { amp*SinOsc.ar(freq*LFTri.kr(rate).range(1, (14/12))).distort.sum*0.1*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out); };
~arpeggio = {|freq, amp=1,at=4,rl=6, rate=0.001, out=0| { amp*SinOsc.ar(freq*LFTri.kr(rate).range(1, 1.5))*0.1*EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, out); };
~relbed = Pseq([2,0.1],inf).asStream;
~atbed = Pseq([1,0.5],inf).asStream;
~hh = Pseq([0,2],inf).asStream;
~hhs = Pseq([~perc2,~perc],inf).asStream;

~perc = {|buf, amp, at=0.1, rl=1, rate=1, out| { amp*PlayBuf.ar(1, buf, rate, loop: 0, doneAction:2) *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
~perc2 = {|buf, amp, at=0.1, rl=1, rate=1, out=0| { amp*PlayBuf.ar(2, buf, rate, loop: 0, doneAction:2).sum *EnvGen.ar(Env.perc(at, rl), doneAction:2) }.play(s, outbus: out); }
a.ignite;
t.tempo = 108/60;
a.beats=4;
PZ_layer2.bar=4
~arp.reset
~bed.reset
//~bed.(~prog.next, 0.2, 4, 6, 0.001, ~revbus);
a.dict['bed'] = { PZ_layer2(~bed, {~prog.next}, 0.35, 0.1, 0.2, 0.001, ~revbus).rhythm(1, 1, [0,1], [0,1]) };
a.dict['arp'] = { PZ_layer2(~arpeggio, {~arp.next}, 1, 0.02, 0.01, t.tempo*9, 0).rhythm([4], 0, [0,2], [0,4]) };
a.dict['hh'] = { PZ_layer2(~perc, {b['perc']['hh'][~hh.next]}, 0.7, 0.1, 1, 1, 0).rhythm(2) };
a.dict['kick'] = { PZ_layer(~perc, b['perc']['kick'][0], 1, 0.01, 1, 1, 0).rhythm(1,0,1,0) };
a.dict['snare'] = { PZ_layer(~perc, b['perc']['rim'], 1.5, 0.01, 1, 1, 0).rhythm(0,1,0,1) };

a.dict=();

a.routine.reset.play;
a.routine.stop

// fx
Ndef(\rev, {GVerb.ar(In.ar(~revbus), 10, 1).sum }).play(0,1);
Ndef(\rev1, {In.ar(~rev2)+GVerb.ar(In.ar(~rev2), 60, 1, mul:0.01).sum }).play(0,1);
Ndef(\del, {CombL.ar(In.ar(~del)*1, 0.25, t.tempo/2, 2) }).play(0,1);

// coins
~coin = {|out=0, max=2600, dur=1| { SinOsc.ar(Line.kr(400, max, dur, doneAction:2), mul:0.3)*LFPulse.kr(9).lag(0.01) }.play(s, outbus: out); }
~coin.(~del,2260,1);

~perc.(b['perc']['dad'],2,0.1,5,2.3,~del);

