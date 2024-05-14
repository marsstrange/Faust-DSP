import ("stdfaust.lib");

wavegenerator = hgroup("[0]Wave Generator", no.noise, os.triangle(freq), os.sawtooth(freq), os.square(freq) : ba.selectn(4, wave))
with{
    wave = vslider("[0]Waveform [style:menu{'Noize':0;'Triangle':1;'Sawtooth':2;'Square':3}]", 0, 0, 3, 1);
    freq = hslider("[2]Carrier Frequency[style:knob][multi:0]", 400,50,2000,0.01);
};

filters = seq(i,2,someFilter(i))
with{
  someFilter(i) = vgroup("LFOFreqFilter", fi.resonlp(a,b,c(i)))
  with{
    freq = hslider("LFOFreq [multi:1]",2000,50,10000,0.1);
    //q = hslider("Q[style:knob]%i",5,1,30,0.1);
    lfoFreq = hslider("LFO Frequency[multi:2]",10,0.1,20,0.01);
    lfoDepth = hslider("LFO Depth[multi:3]",500,1,10000,1);

    LFO(ctFreq) = ctFreq + os.osc(lfoFreq) * lfoDepth : max(30);

    a = freq/6 + LFO(freq)*i;
    b = freq/6 + LFO(freq)*i*2;
    c(0) = 0.5;
    c(1) = 1;
  };
};

subtractive = wavegenerator : hgroup("[1]Filter", filters);

envelope = hgroup("[1]Envelope", en.adsr(attack, decay, sustain, release, gate) * gain * 0.3) // multiplication by 0.3 is needed for the artefacts elimination
with{
    attack = hslider("[0]attack[style:knob]", 50, 1, 1000, 1) * 0.001;
    decay = hslider("[1]decay[style:knob]", 50, 1, 1000, 1) * 0.001;
    sustain = hslider("[2]sustain[style:knob]", 0.8, 0.1, 1, 0.01);
    release = hslider("[3]release[style:knob]", 50, 1, 1000, 1) * 0.001;
    gain = hslider("[4]gain[style:knob]", 0.5, 0, 1, 0.01);
    gate = checkbox("[5]gate");
};

process = vgroup("Synth [style:multi]", subtractive * envelope);