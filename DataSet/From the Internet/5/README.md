# dataset-ssvep-led

## Introduction

This dataset gathers SSVEP-based BCI recordings of 4 subjects focusing on 3 groups of LED blinking at differents frequencies (see update section).


## Related publications:

This dataset is used in the following publications:

-  Emmanuel Kalunga, Karim Djouani, Yskandar Hamam, Sylvain Chevallier, Eric Monacelli. _SSVEP Enhancement Based on Canonical Correlation Analysis to Improve BCI Performances_. IEEE AFRICON, pp. 1-5, Ile Maurice, 2013.


## Experimental setup

The g.Mobilab+ device is used for recording EEG at 256 Hz on 8 channels. For SSVEP stimulation, flash stimulus technique has been chosen. To avoid limitation imposed by refresh rate of computer screens, a microcontroller is set up to  flash stimuli with light emitting diodes (LED) at frequencies F ={13, 17, 21} Hz. The device has been controlled and the LED blinking is precise up to the millisecond. The eight electrodes are placed according to the 10/20 system on Oz, O1, O2, POz, PO3, PO4, PO7 and PO8.  The ground was placed on Fz and the reference was located on the right (or left) hear mastoid.

## Data description

The datasets contains 4 directories, containing recording from 5 male and female subjects aged between 22 and 30 years old. Informed consent was obtained from all subjects, each one has signed a form attesting her or his consent.

The subjects were seated comfortably in a chair facing the computer screen placed at about 60 cm. Three LED arrays are placed on top, left and right sides of the computer screen and are the experimental targets.

In a recording session the subject was requested, in a random order, to look at blinking LED array, hereafter called stimuli. He was prompted to do so by a triangular cue appearing on the computer screen, on the left side to gaze at the left stimulus (i.e. 17 Hz), on the right side to gaze at the right stimulus (i.e. 21 Hz), on top to gaze at the top stimulus (i.e. 13 Hz) and at the center to gaze at the center of the screen where no stimulus is flashed. All LEDs arrays are flashing for the whole recording time. In a session, 10 trials were recorded per flash stimulus, for a total of 40 trials per session. During a trial the subject gazes at the flash stimuli for a period of 5 seconds followed by a 3 second break where
the subject is supposed to look at center of the computer screen (no flash). The subject was advised not to blink nor move eyes while gazing at any of the three flash stimuli. The subject was allowed to blink the eyes during the trial looking at the center of the screen. After a session, the subject was given a 2-minutes break. Four sessions were recorded per subject and a total of 160 trials were recorded for each subject. Since the EEG were recorded for later analysis, no signal processing was done online and no
feedback was provided to the subject.

The recording are saved in GDF format [1], the stimulations code for each class are available as time events. There is between 4 sessions for each user, recorded on different days, by the same operators, on the same hardware and in the same conditions.

The stimulation code used in GDF file are those defined by OpenVibe:


* ExperimentStart: 32769, 0x00008001,
* ExperimentStop: 32770, 0x00008002
* VisualStimulationStart: 32779, 0x0000800b
* VisualStimulationStop: 32780, 0x0000800c
* Label_00: 33024, 0x00008100
* Label_01: 33025, 0x00008101
* Label_02: 33026, 0x00008102
* Label_03: 33027, 0x00008103

The stimulation code are used as follows: *ExperimentStart* and *ExperimentStop* indicate the begining and the end of the session. A trial start with a Label_XX stimulation code indicating the class of the example, there is a 3s pause before the audio cue indicating the stimulus to focus. The audio cue onset is indicated by *VisualStimulationStart*, this is the start of the trial. The end of the trial take place 5s after and is indicated by *VisualStimulationStop*. *Label_00* is for resting class, *Label_01* is for 13Hz stimulation, *Label_02* is for 21Hz stimulation and *Label_03* is for 17Hz stimulation.

## *Update*

Subject 1 was removed from the repository for inconsistency in the stimulation frequencies.

## Bibliography

[1] A. Schlogl, _GDF - A general dataformat for biosignals_, http://arxiv.org/abs/cs/0608052
