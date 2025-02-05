// Cable Hum Buzz Noise Pulled from Sccode
(
{var levels, times, doneAction, env, a;
	a = {
	var  h, n, m, k, trig;
 		trig = Dust.kr( 7 ** LFNoise1.kr(0.3) );
		h = ToggleFF.kr(CoinGate.kr(0.4,trig)) *
			RLPF.ar(LFPulse.ar(50, 0, 0.5, 1, LFNoise1.kr(2, 0.5, -0.5)), 6000, 0.15);
		n =  Trig.ar(trig, TRand.kr(0, 0.01, CoinGate.kr(0.4,trig))) * WhiteNoise.ar;
		m =  Trig.ar(trig, TRand.kr(0, 0.01, CoinGate.kr(0.4,trig))) * BrownNoise.ar;
		k = Trig.ar(trig, LFNoise1.kr([ 4, 4.2 ], 0.1, 0.11)) *
			LFClipNoise.ar(LFNoise0.kr(7, 30, 40));
		LeakDC.ar(h + n + k + m * 10).distort;
	};

	doneAction = 12;
	levels = [0,1, 5, 8, 9, 11, 7, 5, 3, 2.5, 2 , 1, 0];
	times = [1, 3, 3.5, 4, 0, 3, 2];

	env = Env(levels, times);
	env = env.kr(doneAction);
	env = env.lincurve(0, 1, 0, 10, 3);

	a = a * env;
}.play;
)
