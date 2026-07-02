{\rtf1\ansi\ansicpg1252\cocoartf2870
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # EBYS Pipeline\
\
---\
\
## File Flow\
\
raw_uploads/\
\uc0\u8594  ffmpeg conversion\
\uc0\u8594  Demucs separation\
\uc0\u8594  stems/\
\
---\
\
## Processing Flow\
\
1. Upload detected\
2. Convert to WAV\
3. Run stem separation\
4. Store stems\
5. Extract splices\
6. Compute feature vectors\
7. Store metadata\
8. Generate remix graph\
9. Schedule for broadcast\
\
---\
\
## Output Format\
\
Each processed track produces:\
\
- stem files\
- splice dataset\
- metadata JSON\
- compatibility entries\
\
---\
\
## Cleanup Policy\
\
Temporary files:\
- removed after processing\
- no redundant storage of intermediate BPM versions\
\
---\
\
## Design Goal\
\
Avoid duplication:\
- no multiple BPM versions stored\
- transformations happen on demand or during assembly}