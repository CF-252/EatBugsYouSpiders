{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # Audio Analysis\
\
---\
\
## Purpose\
\
Convert audio into structured feature space for recombination.\
\
---\
\
## Feature Vector\
\
Each audio segment contains:\
\
- spectral centroid\
- chroma / tonal centroid (HPCP)\
- RMS energy\
- spectral flux\
- tempo estimate\
- onset density\
\
---\
\
## Representation\
\
Audio \uc0\u8594  feature vector:\
\
V = [C, T, E, F, B, O]\
\
Where:\
- C = spectral centroid\
- T = tonal centroid\
- E = energy\
- F = flux\
- B = BPM\
- O = onset density\
\
---\
\
## Use in System\
\
Used for:\
- splice compatibility\
- transition scoring\
- BPM alignment\
- selection probability\
\
---\
\
## Key Principle\
\
Audio similarity is defined in feature space, not waveform similarity.}