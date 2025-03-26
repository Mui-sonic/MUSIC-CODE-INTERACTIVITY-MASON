(
~dirpath = "/Users/masonbell/Documents/GitHub/MUSIC-CODE-INTERACTIVITY/Etudes/WEEK 6/Corpus All/Corpus cut and normalized/*".resolveRelative;
~filepaths = ~dirpath.pathMatch;
~buffers = ~filepaths.collect { |path|  Buffer.read(s, path) };
~buffers = ~filepaths.collect { |path|  Buffer.readChannel(s, path, channels: [0]);};

s.options.maxSynthDefs = 2048;

s.boot;

s.waitForBoot({
  ~np = NodeProxy.audio(s, 2);

  ~np.source = { nil };

  ~np.play;
})
);

(
~np[0] = {
    "Playing slow section...".postln;
    20.do { |i|
		var buf = ~buffers[1..1].choose;

        ~np.add({
            Pan2.ar(
                PlayBuf.ar(buf.numChannels, buf.bufnum,
                    rate: (1..28).choose.midiratio,
                    doneAction: 5) * rrand(-40, 0).dbamp,
                Rand(-1.0, 1.0)
            )
        });
        (buf.duration/4).wait;
    };
}
);
