{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # EBYS Architecture\
\
---\
\
## High-Level Pipeline\
\
UPLOAD \uc0\u8594  CONVERSION \u8594  STEM SEPARATION \u8594  ANALYSIS \u8594  SPLICING \u8594  ASSEMBLY \u8594  BROADCAST\
\
---\
\
## Modules\
\
### 1. Ingestion\
- user uploads audio\
- files stored in raw_uploads/\
\
---\
\
### 2. Conversion Layer\
- ffmpeg converts to WAV\
- normalization of format\
\
---\
\
### 3. Stem Separation\
- Demucs extracts:\
  - drums\
  - bass\
  - vocals\
  - other\
\
Output stored in stems/\
\
---\
\
### 4. Audio Analysis\
Extracts feature vectors:\
- spectral centroid\
- tonal centroid\
- RMS energy\
- tempo estimation\
- onset density\
\
---\
\
### 5. Splice Engine\
Audio is segmented into:\
- short reusable fragments\
\
Each splice has metadata:\
- timestamp\
- feature vector\
- source stem\
\
---\
\
### 6. Compatibility Engine\
Computes similarity between splices:\
- distance in feature space\
- rhythmic compatibility\
- tonal alignment\
\
---\
\
### 7. Assembly Engine\
Creates sequences using:\
- weighted randomness\
- compatibility constraints\
- BPM normalization (target BPM)\
\
---\
\
### 8. Broadcast Layer\
Generates continuous audio stream:\
- offline assembly\
- scheduled playback\
- radio loop system\
\
---\
\
## Key Design Constraint\
\
The system is NOT real-time live mixing.\
It is:\
- precomputed\
- assembled in background\
- then broadcast\
\
---}