// Mixer UI + a few functions implemented

import("stdfaust.lib");

//pan

ITD = (0.2/340) * ma.SR;
itdpan(p) = _ <: @((p,ITD) : *), @(((1-p),ITD) : *);

channel(c) = vgroup("channel %c", (audio_source * level * gate * mute) : pan)
with
{
    pan = itdpan(vslider("[0]pan[style:knob]", 0.5, 0, 1, 0.01));
    level = vslider("[1]level", 0.5, 0, 1, 0.01);
    gate = checkbox("[3]gate[style:knob]");
    sourse_select = vslider("[2]source[style:menu{'Noise':0;'Sine':1;'Square':2}]", 0, 0, 2, 1);
    audio_source = hgroup("source", no.noise, os.osc(400), os.square(200)) : ba.selectn(3, sourse_select);
    mute = 1 - checkbox("[4]mute");
};

process = hgroup("mixer", par(i,7,channel(i)), vbargraph("left", 0, 1), vbargraph("right", 0, 1), vslider("master", 0.5, 0, 1, 0.01));
