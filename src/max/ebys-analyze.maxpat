{
    "patcher": {
        "fileversion": 1,
        "appversion": {
            "major": 9,
            "minor": 1,
            "revision": 4,
            "architecture": "x64",
            "modernui": 1
        },
        "classnamespace": "box",
        "rect": [ 36.0, 105.0, 1262.0, 881.0 ],
        "boxes": [
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-194",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2657.746513724327, 54.92957818508148, 113.83333672583103, 20.0 ],
                    "text": "== ANALYSIS =="
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-2",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5593.334489822388, 201.20482671260834, 155.55556797981262, 20.0 ],
                    "text": "== TUI COMMANDS =="
                }
            },
            {
                "box": {
                    "id": "obj-26",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5678.876661658287, 780.7229204177856, 63.0, 22.0 ],
                    "text": "script stop"
                }
            },
            {
                "box": {
                    "id": "obj-187",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 1081.4815678596497, 2091.1112135648727, 67.0, 22.0 ],
                    "text": "delay 1000"
                }
            },
            {
                "box": {
                    "id": "obj-163",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1135.8333062529564, 2019.1357944011688, 31.0, 22.0 ],
                    "text": "play"
                }
            },
            {
                "box": {
                    "id": "obj-164",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1240.8333037495613, 2019.166618525982, 31.0, 22.0 ],
                    "text": "stop"
                }
            },
            {
                "box": {
                    "id": "obj-165",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1170.370463848114, 2019.1357944011688, 67.0, 22.0 ],
                    "text": "0."
                }
            },
            {
                "box": {
                    "id": "obj-172",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "float" ],
                    "patching_rect": [ 1170.370463848114, 1968.5185064077377, 40.0, 22.0 ],
                    "text": "t b b f"
                }
            },
            {
                "box": {
                    "id": "obj-63",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 1590.833295404911, 2091.1112135648727, 67.0, 22.0 ],
                    "text": "delay 1000"
                }
            },
            {
                "box": {
                    "id": "obj-58",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1626.833295404911, 2019.166618525982, 31.0, 22.0 ],
                    "text": "play"
                }
            },
            {
                "box": {
                    "id": "obj-59",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1746.43840777874, 2019.166618525982, 31.0, 22.0 ],
                    "text": "stop"
                }
            },
            {
                "box": {
                    "id": "obj-60",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1659.833295404911, 2019.166618525982, 67.0, 22.0 ],
                    "text": "0."
                }
            },
            {
                "box": {
                    "id": "obj-61",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "float" ],
                    "patching_rect": [ 1676.6666266918182, 1968.5185064077377, 40.0, 22.0 ],
                    "text": "t b b f"
                }
            },
            {
                "box": {
                    "id": "obj-55",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 597.5309119224548, 2019.1357944011688, 31.0, 22.0 ],
                    "text": "play"
                }
            },
            {
                "box": {
                    "id": "obj-56",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 701.2346239089966, 2019.1357944011688, 31.0, 22.0 ],
                    "text": "stop"
                }
            },
            {
                "box": {
                    "id": "obj-57",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 628.3951119184494, 2019.1357944011688, 67.0, 22.0 ],
                    "text": "0."
                }
            },
            {
                "box": {
                    "id": "obj-54",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "float" ],
                    "patching_rect": [ 646.9136319160461, 1968.5185064077377, 40.0, 22.0 ],
                    "text": "t b b f"
                }
            },
            {
                "box": {
                    "id": "obj-53",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 522.2221966981888, 2090.908988714218, 67.0, 22.0 ],
                    "text": "delay 1000"
                }
            },
            {
                "box": {
                    "id": "obj-44",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 116.6666647195816, 2018.5184848308563, 31.0, 22.0 ],
                    "text": "play"
                }
            },
            {
                "box": {
                    "id": "obj-43",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 218.5185148715973, 2018.5184848308563, 31.0, 22.0 ],
                    "text": "stop"
                }
            },
            {
                "box": {
                    "id": "obj-37",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 146.29629385471344, 2018.5184848308563, 67.0, 22.0 ],
                    "text": "0."
                }
            },
            {
                "box": {
                    "id": "obj-28",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 43.33333230018616, 2091.1112135648727, 67.0, 22.0 ],
                    "text": "delay 1000"
                }
            },
            {
                "box": {
                    "id": "obj-25",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "bang", "bang", "float" ],
                    "patching_rect": [ 146.29629385471344, 1968.5184856653214, 40.0, 22.0 ],
                    "text": "t b b f"
                }
            },
            {
                "box": {
                    "id": "obj-23",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1081.4815678596497, 2157.4999485611916, 60.0, 22.0 ],
                    "text": "next bass"
                }
            },
            {
                "box": {
                    "id": "obj-17",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 891.2753591537476, 202.60868901014328, 63.0, 22.0 ],
                    "text": "script stop"
                }
            },
            {
                "box": {
                    "id": "obj-18",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 140.90976876020432, 150.12780612707138, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-7",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 890.4057939648628, 159.130430996418, 64.0, 22.0 ],
                    "text": "script start"
                }
            },
            {
                "box": {
                    "id": "obj-4",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "float" ],
                    "patching_rect": [ 748.666668176651, 116.78946340084076, 29.5, 22.0 ],
                    "text": "t b f"
                }
            },
            {
                "box": {
                    "id": "obj-50",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 812.1449269652367, 116.78946340084076, 55.0, 22.0 ],
                    "text": "reset NA"
                }
            },
            {
                "box": {
                    "id": "obj-158",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4315.641212105751, 2960.5634191036224, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-123",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4352.260930895805, 3229.5775071382523, 336.0, 109.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-124",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 4352.260930895805, 3129.57750582695, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-125",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4610.00741314888, 3171.831027507782, 245.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_melo.mono"
                }
            },
            {
                "box": {
                    "id": "obj-126",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4352.260930895805, 3171.831027507782, 213.0, 22.0 ],
                    "text": "features stem_melo_mfcc.features red"
                }
            },
            {
                "box": {
                    "id": "obj-156",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 4357.894733786583, 3056.3380682468414, 360.17387294769287, 35.0 ],
                    "text": "fluid.bufmfcc~ @source stem_melo.mono @features stem_melo_mfcc.features @numcoeffs 13 @numbands 40"
                }
            },
            {
                "box": {
                    "id": "obj-122",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3762.120078086853, 2960.5634191036224, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-114",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3798.7397968769073, 3229.5775071382523, 336.0, 109.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-116",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3798.7397968769073, 3129.57750582695, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-119",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4052.260926961899, 3171.831027507782, 244.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_bass.mono"
                }
            },
            {
                "box": {
                    "id": "obj-120",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3798.7397968769073, 3171.831027507782, 213.0, 22.0 ],
                    "text": "features stem_bass_mfcc.features red"
                }
            },
            {
                "box": {
                    "id": "obj-121",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3798.7397968769073, 3056.3380682468414, 341.0, 35.0 ],
                    "text": "fluid.bufmfcc~ @source stem_bass.mono @features stem_bass_mfcc.features @numcoeffs 13 @numbands 40"
                }
            },
            {
                "box": {
                    "id": "obj-109",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3136.7679572105408, 2960.5634191036224, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-94",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3183.246831059456, 3229.5775071382523, 336.0, 109.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-98",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3183.246831059456, 3129.57750582695, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-101",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3436.7679611444473, 3171.831027507782, 252.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_drums.mono"
                }
            },
            {
                "box": {
                    "id": "obj-102",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3183.246831059456, 3171.831027507782, 221.0, 22.0 ],
                    "text": "features stem_drums_mfcc.features red"
                }
            },
            {
                "box": {
                    "id": "obj-105",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3188.8806339502335, 3056.3380682468414, 348.56519985198975, 35.0 ],
                    "text": "fluid.bufmfcc~ @source stem_drums.mono @features stem_drums_mfcc.features @numcoeffs 13 @numbands 40"
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-93",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2631.1341477632523, 3229.5775071382523, 336.0, 109.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-86",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 2631.1341477632523, 3129.57750582695, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-87",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2883.2468271255493, 3171.831027507782, 253.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_vocals.mono"
                }
            },
            {
                "box": {
                    "id": "obj-91",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2631.1341477632523, 3171.831027507782, 221.0, 22.0 ],
                    "text": "features stem_vocals_mfcc.features red"
                }
            },
            {
                "box": {
                    "id": "obj-85",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2610.0073869228363, 2960.5634191036224, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-75",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2640.993302822113, 3056.3380682468414, 346.39129734039307, 35.0 ],
                    "text": "fluid.bufmfcc~ @source stem_vocals.mono @features stem_vocals_mfcc.features @numcoeffs 13 @numbands 40"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-74",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4573.387694358826, 666.1971918344498, 187.0, 22.0 ],
                    "text": "buffer~ stem_melo_mfcc.features"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-73",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3957.894728541374, 666.1971918344498, 186.0, 22.0 ],
                    "text": "buffer~ stem_bass_mfcc.features"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-72",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3362.1200728416443, 660.5633889436722, 194.0, 22.0 ],
                    "text": "buffer~ stem_drums_mfcc.features"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-67",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2840.9933054447174, 660.5633889436722, 195.0, 22.0 ],
                    "text": "buffer~ stem_vocals_mfcc.features"
                }
            },
            {
                "box": {
                    "id": "obj-435",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 4410.007410526276, 1071.830999970436, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-430",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3831.1341634988785, 1071.830999970436, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-429",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3219.86654984951, 1071.830999970436, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-426",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 2652.260908603668, 839.4366307258606, 22.0, 22.0 ],
                    "text": "t b"
                }
            },
            {
                "box": {
                    "id": "obj-425",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 4383.246846795082, 2660.563415169716, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-407",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4704.373611569405, 2966.1972219944, 25.0, 20.0 ],
                    "text": "G#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-408",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4679.0214985609055, 2966.1972219944, 19.0, 20.0 ],
                    "text": "G",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-409",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4652.260934829712, 2966.1972219944, 23.0, 20.0 ],
                    "text": "F#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-414",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4619.866568207741, 2966.1972219944, 19.0, 20.0 ],
                    "text": "F",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-415",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4594.514455199242, 2966.1972219944, 19.0, 20.0 ],
                    "text": "E",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-416",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4562.1200885772705, 2966.1972219944, 24.0, 20.0 ],
                    "text": "D#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-417",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4531.134172677994, 2966.1972219944, 19.0, 20.0 ],
                    "text": "D",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-418",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4498.739806056023, 2966.1972219944, 24.0, 20.0 ],
                    "text": "C#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-419",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4473.3876930475235, 2966.1972219944, 19.0, 20.0 ],
                    "text": "C",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-420",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4446.62712931633, 2966.1972219944, 19.0, 20.0 ],
                    "text": "B",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-421",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4415.641213417053, 2966.1972219944, 23.0, 20.0 ],
                    "text": "A#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-422",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4388.88064968586, 2966.1972219944, 19.0, 20.0 ],
                    "text": "A",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "candycane": 12,
                    "ghostbar": 100,
                    "id": "obj-423",
                    "ignoreclick": 1,
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4383.246846795082, 2887.323981523514, 348.0, 77.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1777.3809354305267, 3085.714256286621, 425.0, 156.0 ],
                    "setminmax": [ 0.0, 0.20000000298023224 ],
                    "size": 12
                }
            },
            {
                "box": {
                    "id": "obj-424",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 84.0, 131.0, 421.0, 591.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 233.0, 348.0, 29.5, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 125.5, 468.0, 51.0, 22.0 ],
                                    "text": "zl.group"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 233.0, 398.0, 29.5, 22.0 ],
                                    "text": "int"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 18.0, 262.0, 90.0, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 18.0, 308.0, 234.0, 22.0 ],
                                    "text": "uzi 12"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 228.0, 39.0, 22.0 ],
                                    "text": "round"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 18.0, 108.0, 49.0, 22.0 ],
                                    "text": "t f b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 18.0, 188.0, 49.0, 22.0 ],
                                    "text": "* 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "", "" ],
                                    "patching_rect": [ 48.0, 158.0, 135.0, 22.0 ],
                                    "text": "getattr samps @listen 0"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 106.0, 188.0, 201.0, 22.0 ],
                                    "text": "buffer~ stem_melo_chroma.features"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 233.0, 428.0, 204.0, 22.0 ],
                                    "text": "peek~ stem_melo_chroma.features"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-27",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 18.0, 68.0, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-67",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 8.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-68",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 125.5, 550.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "midpoints": [ 242.5, 458.359375, 135.0, 458.359375 ],
                                    "source": [ "obj-37", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "source": [ "obj-43", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 1 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-55", 0 ],
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-52", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-58", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "source": [ "obj-58", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-58", 0 ],
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 1 ],
                                    "midpoints": [ 98.5, 295.0, 272.0, 295.0, 272.0, 385.0, 253.0, 385.0 ],
                                    "source": [ "obj-59", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "source": [ "obj-60", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 2 ],
                                    "midpoints": [ 253.0, 385.0, 427.5, 385.0 ],
                                    "source": [ "obj-65", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 0 ],
                                    "midpoints": [ 242.5, 373.0, 242.5, 373.0 ],
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 4383.246846795082, 2845.070459842682, 103.0, 22.0 ],
                    "text": "p \"feature lookup\""
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "contdata": 1,
                    "id": "obj-405",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4383.246846795082, 2745.0704585313797, 304.0, 85.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 1.0, 0.792156862745098, 0.0, 1.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-406",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4383.246846795082, 2745.0704585313797, 304.0, 85.0 ]
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-391",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4131.134167432785, 2966.1972219944, 25.0, 20.0 ],
                    "text": "G#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-392",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4104.3736037015915, 2966.1972219944, 19.0, 20.0 ],
                    "text": "G",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-393",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4079.0214906930923, 2966.1972219944, 23.0, 20.0 ],
                    "text": "F#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-394",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4052.260926961899, 2966.1972219944, 19.0, 20.0 ],
                    "text": "F",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-395",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4019.8665603399277, 2966.1972219944, 19.0, 20.0 ],
                    "text": "E",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-396",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3988.880644440651, 2966.1972219944, 24.0, 20.0 ],
                    "text": "D#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-397",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3962.1200807094574, 2966.1972219944, 19.0, 20.0 ],
                    "text": "D",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-398",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3931.1341648101807, 2966.1972219944, 24.0, 20.0 ],
                    "text": "C#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-399",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3898.7397981882095, 2966.1972219944, 19.0, 20.0 ],
                    "text": "C",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-401",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3873.3876851797104, 2966.1972219944, 19.0, 20.0 ],
                    "text": "B",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-402",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3840.9933185577393, 2966.1972219944, 23.0, 20.0 ],
                    "text": "A#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-403",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3815.64120554924, 2966.1972219944, 19.0, 20.0 ],
                    "text": "A",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "candycane": 12,
                    "ghostbar": 100,
                    "id": "obj-404",
                    "ignoreclick": 1,
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3810.0074026584625, 2887.323981523514, 348.0, 77.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 1201.1904647350311, 3085.714256286621, 425.0, 156.0 ],
                    "setminmax": [ 0.0, 0.20000000298023224 ],
                    "size": 12
                }
            },
            {
                "box": {
                    "id": "obj-389",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 84.0, 131.0, 421.0, 591.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 233.0, 348.0, 29.5, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 125.5, 468.0, 51.0, 22.0 ],
                                    "text": "zl.group"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 233.0, 398.0, 29.5, 22.0 ],
                                    "text": "int"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 18.0, 262.0, 90.0, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 18.0, 308.0, 234.0, 22.0 ],
                                    "text": "uzi 12"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 228.0, 39.0, 22.0 ],
                                    "text": "round"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 18.0, 108.0, 49.0, 22.0 ],
                                    "text": "t f b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 18.0, 188.0, 49.0, 22.0 ],
                                    "text": "* 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "", "" ],
                                    "patching_rect": [ 48.0, 158.0, 135.0, 22.0 ],
                                    "text": "getattr samps @listen 0"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 106.0, 188.0, 201.0, 22.0 ],
                                    "text": "buffer~ stem_bass_chroma.features"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 233.0, 428.0, 196.0, 22.0 ],
                                    "text": "peek~ stem_bass_chroma.features"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-27",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 18.0, 68.0, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-67",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 8.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-68",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 125.5, 550.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "midpoints": [ 242.5, 451.0, 135.0, 451.0 ],
                                    "source": [ "obj-37", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "source": [ "obj-43", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 1 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-55", 0 ],
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-52", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-58", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "source": [ "obj-58", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-58", 0 ],
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 1 ],
                                    "midpoints": [ 98.5, 295.0, 272.0, 295.0, 272.0, 385.0, 253.0, 385.0 ],
                                    "source": [ "obj-59", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "source": [ "obj-60", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 2 ],
                                    "midpoints": [ 253.0, 385.0, 419.5, 385.0 ],
                                    "source": [ "obj-65", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 0 ],
                                    "midpoints": [ 242.5, 373.0, 242.5, 373.0 ],
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 3810.0074026584625, 2845.070459842682, 103.0, 22.0 ],
                    "text": "p \"feature lookup\""
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "contdata": 1,
                    "id": "obj-387",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3810.0074026584625, 2745.0704585313797, 304.0, 85.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 1.0, 0.792156862745098, 0.0, 1.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-388",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3810.0074026584625, 2745.0704585313797, 304.0, 85.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-386",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3810.0074026584625, 2660.563415169716, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-373",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3519.8665537834167, 2966.1972219944, 25.0, 20.0 ],
                    "text": "G#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-374",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3494.5144407749176, 2966.1972219944, 19.0, 20.0 ],
                    "text": "G",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-375",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3462.1200741529465, 2966.1972219944, 23.0, 20.0 ],
                    "text": "F#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-376",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3436.7679611444473, 2966.1972219944, 19.0, 20.0 ],
                    "text": "F",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-377",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3410.007397413254, 2966.1972219944, 19.0, 20.0 ],
                    "text": "E",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-378",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3379.021481513977, 2966.1972219944, 24.0, 20.0 ],
                    "text": "D#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-379",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3352.2609177827835, 2966.1972219944, 19.0, 20.0 ],
                    "text": "D",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-380",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3319.8665511608124, 2966.1972219944, 24.0, 20.0 ],
                    "text": "C#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-381",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3288.8806352615356, 2966.1972219944, 19.0, 20.0 ],
                    "text": "C",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-382",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3262.120071530342, 2966.1972219944, 19.0, 20.0 ],
                    "text": "B",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-383",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3231.1341556310654, 2966.1972219944, 23.0, 20.0 ],
                    "text": "A#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-384",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3198.7397890090942, 2966.1972219944, 19.0, 20.0 ],
                    "text": "A",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "candycane": 12,
                    "ghostbar": 100,
                    "id": "obj-385",
                    "ignoreclick": 1,
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3198.7397890090942, 2887.323981523514, 348.0, 77.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 594.0476133823395, 3083.3333039283752, 425.0, 156.0 ],
                    "setminmax": [ 0.0, 0.20000000298023224 ],
                    "size": 12
                }
            },
            {
                "box": {
                    "id": "obj-372",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 84.0, 131.0, 421.0, 591.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 233.0, 348.0, 29.5, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 125.5, 468.0, 51.0, 22.0 ],
                                    "text": "zl.group"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 233.0, 398.0, 29.5, 22.0 ],
                                    "text": "int"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 18.0, 262.0, 90.0, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 18.0, 308.0, 234.0, 22.0 ],
                                    "text": "uzi 12"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 228.0, 39.0, 22.0 ],
                                    "text": "round"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 18.0, 108.0, 49.0, 22.0 ],
                                    "text": "t f b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 18.0, 188.0, 49.0, 22.0 ],
                                    "text": "* 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "", "" ],
                                    "patching_rect": [ 48.0, 158.0, 135.0, 22.0 ],
                                    "text": "getattr samps @listen 0"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 106.0, 188.0, 209.0, 22.0 ],
                                    "text": "buffer~ stem_drums_chroma.features"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 233.0, 428.0, 204.0, 22.0 ],
                                    "text": "peek~ stem_drums_chroma.features"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-27",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 18.0, 68.0, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-67",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 8.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-68",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 125.5, 550.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "midpoints": [ 242.5, 451.0, 135.0, 451.0 ],
                                    "source": [ "obj-37", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "source": [ "obj-43", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 1 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-55", 0 ],
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-52", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-58", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "source": [ "obj-58", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-58", 0 ],
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 1 ],
                                    "midpoints": [ 98.5, 295.0, 272.0, 295.0, 272.0, 385.0, 253.0, 385.0 ],
                                    "source": [ "obj-59", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "source": [ "obj-60", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 2 ],
                                    "midpoints": [ 253.0, 385.0, 427.5, 385.0 ],
                                    "source": [ "obj-65", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 0 ],
                                    "midpoints": [ 242.5, 373.0, 242.5, 373.0 ],
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 3198.7397890090942, 2850.7042627334595, 103.0, 22.0 ],
                    "text": "p \"feature lookup\""
                }
            },
            {
                "box": {
                    "id": "obj-371",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3198.7397890090942, 2660.563415169716, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "contdata": 1,
                    "id": "obj-369",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3198.7397890090942, 2745.0704585313797, 304.0, 85.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 1.0, 0.792156862745098, 0.0, 1.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-370",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3198.7397890090942, 2745.0704585313797, 304.0, 85.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-364",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 2694.5144302845, 1071.830999970436, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-357",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 895.0, 455.0, 799.0, 511.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 133.0, 178.0, 387.0, 22.0 ],
                                    "text": "fluid.bufselect~ @source stem_vocals @destination stem_vocals.mono"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 133.0, 95.0, 45.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 10,
                                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                                    "patching_rect": [ 12.0, 57.0, 113.5, 22.0 ],
                                    "text": "info~ stem_vocals"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 582.0, 229.0, 82.0, 22.0 ],
                                    "text": "clear, size 1 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "bang" ],
                                    "patching_rect": [ 338.0, 178.0, 263.0, 22.0 ],
                                    "text": "t b b"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.423529411764706, 0.513725490196078, 1.0, 1.0 ],
                                    "id": "obj-14",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 582.0, 268.0, 149.0, 22.0 ],
                                    "text": "buffer~ stem_vocals.mono"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 338.0, 229.0, 201.0, 22.0 ],
                                    "text": "startchan 0, bang, startchan 1, bang"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "linecount": 3,
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 338.0, 268.0, 231.0, 49.0 ],
                                    "text": "fluid.bufcompose~ @source stem_vocals @destination stem_vocals.mono @destgain 0.5 @numchans 1"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-2",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 133.0, 371.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-1",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 12.0, 9.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 0 ],
                                    "midpoints": [ 142.5, 120.0, 142.5, 120.0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "midpoints": [ 168.5, 165.0, 347.5, 165.0 ],
                                    "source": [ "obj-13", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-7", 0 ],
                                    "source": [ "obj-4", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 0 ],
                                    "source": [ "obj-7", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-8", 8 ]
                                }
                            }
                        ],
                        "styles": [
                            {
                                "name": "max6box",
                                "default": {
                                    "accentcolor": [ 0.8, 0.839216, 0.709804, 1.0 ],
                                    "bgcolor": [ 1.0, 1.0, 1.0, 0.5 ],
                                    "textcolor_inverse": [ 0.0, 0.0, 0.0, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "max6inlet",
                                "default": {
                                    "color": [ 0.423529, 0.372549, 0.27451, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "max6message",
                                "default": {
                                    "bgfillcolor": {
                                        "angle": 270.0,
                                        "autogradient": 0,
                                        "color": [ 0.290196, 0.309804, 0.301961, 1.0 ],
                                        "color1": [ 0.866667, 0.866667, 0.866667, 1.0 ],
                                        "color2": [ 0.788235, 0.788235, 0.788235, 1.0 ],
                                        "proportion": 0.39,
                                        "type": "gradient"
                                    },
                                    "textcolor_inverse": [ 0.0, 0.0, 0.0, 1.0 ]
                                },
                                "parentstyle": "max6box",
                                "multi": 0
                            },
                            {
                                "name": "max6outlet",
                                "default": {
                                    "color": [ 0.0, 0.454902, 0.498039, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            }
                        ]
                    },
                    "patching_rect": [ 2694.5144302845, 871.8309973478317, 143.0, 22.0 ],
                    "text": "p stereo_to_mono.vocals"
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-359",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2973.3876733779907, 2966.1972219944, 25.0, 20.0 ],
                    "text": "G#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-360",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2946.627109646797, 2966.1972219944, 19.0, 20.0 ],
                    "text": "G",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-361",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2915.6411937475204, 2966.1972219944, 23.0, 20.0 ],
                    "text": "F#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-362",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2888.880630016327, 2966.1972219944, 19.0, 20.0 ],
                    "text": "F",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-77",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2862.1200662851334, 2966.1972219944, 19.0, 20.0 ],
                    "text": "E",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-78",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2825.500347495079, 2966.1972219944, 24.0, 20.0 ],
                    "text": "D#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-79",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2798.7397837638855, 2966.1972219944, 19.0, 20.0 ],
                    "text": "D",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-80",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2767.7538678646088, 2966.1972219944, 24.0, 20.0 ],
                    "text": "C#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-81",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2740.993304133415, 2966.1972219944, 19.0, 20.0 ],
                    "text": "C",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-82",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2710.0073882341385, 2966.1972219944, 19.0, 20.0 ],
                    "text": "B",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-363",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2683.246824502945, 2966.1972219944, 23.0, 20.0 ],
                    "text": "A#",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "bubbleside": 0,
                    "id": "obj-83",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2652.260908603668, 2966.1972219944, 19.0, 20.0 ],
                    "text": "A",
                    "textjustification": 1
                }
            },
            {
                "box": {
                    "color": [ 0.431372549019608, 0.431372549019608, 0.431372549019608, 1.0 ],
                    "id": "obj-358",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2657.894711494446, 529.5774717330933, 149.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "saved_newobj_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "text": "buffer~ stem_vocals.mono"
                }
            },
            {
                "box": {
                    "id": "obj-356",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 2652.260908603668, 2650.704260110855, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-355",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2898.7397850751877, 2692.957781791687, 253.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_vocals.mono"
                }
            },
            {
                "box": {
                    "id": "obj-353",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2652.260908603668, 2692.957781791687, 236.0, 22.0 ],
                    "text": "features stem_vocals_chroma.features red"
                }
            },
            {
                "box": {
                    "candycane": 12,
                    "ghostbar": 100,
                    "id": "obj-84",
                    "ignoreclick": 1,
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2652.260908603668, 2887.323981523514, 348.0, 77.0 ],
                    "presentation": 1,
                    "presentation_rect": [ 49.833344, 47.5, 425.0, 156.0 ],
                    "setminmax": [ 0.0, 0.20000000298023224 ],
                    "size": 12
                }
            },
            {
                "box": {
                    "id": "obj-350",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 84.0, 131.0, 421.0, 591.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 233.0, 348.0, 29.5, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 125.5, 468.0, 51.0, 22.0 ],
                                    "text": "zl.group"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 233.0, 398.0, 29.5, 22.0 ],
                                    "text": "int"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 18.0, 262.0, 90.0, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 18.0, 308.0, 234.0, 22.0 ],
                                    "text": "uzi 12"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 228.0, 39.0, 22.0 ],
                                    "text": "round"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 18.0, 108.0, 49.0, 22.0 ],
                                    "text": "t f b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 18.0, 188.0, 49.0, 22.0 ],
                                    "text": "* 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "", "" ],
                                    "patching_rect": [ 48.0, 158.0, 135.0, 22.0 ],
                                    "text": "getattr samps @listen 0"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 106.0, 188.0, 209.0, 22.0 ],
                                    "text": "buffer~ stem_vocals_chroma.features"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 233.0, 428.0, 215.0, 22.0 ],
                                    "text": "peek~ stem_vocals_chroma.features"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-27",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 18.0, 68.0, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-67",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 8.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-68",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 125.5, 550.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "midpoints": [ 242.5, 451.0, 135.0, 451.0 ],
                                    "source": [ "obj-37", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "source": [ "obj-43", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 1 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-55", 0 ],
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-52", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-58", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "source": [ "obj-58", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-58", 0 ],
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 1 ],
                                    "midpoints": [ 98.5, 295.0, 272.0, 295.0, 272.0, 385.0, 253.0, 385.0 ],
                                    "source": [ "obj-59", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "source": [ "obj-60", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 2 ],
                                    "midpoints": [ 253.0, 385.0, 438.5, 385.0 ],
                                    "source": [ "obj-65", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 0 ],
                                    "midpoints": [ 242.5, 373.0, 242.5, 373.0 ],
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 2652.260908603668, 2850.7042627334595, 103.0, 22.0 ],
                    "text": "p \"feature lookup\""
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "contdata": 1,
                    "id": "obj-351",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2652.260908603668, 2745.0704585313797, 304.0, 85.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 1.0, 0.792156862745098, 0.0, 1.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-352",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2652.260908603668, 2745.0704585313797, 304.0, 85.0 ]
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-348",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2840.9933054447174, 635.211275935173, 209.0, 22.0 ],
                    "text": "buffer~ stem_vocals_chroma.features"
                }
            },
            {
                "box": {
                    "id": "obj-347",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2625.5003448724747, 2545.0704559087753, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-346",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2652.260908603668, 2618.309893488884, 475.0, 22.0 ],
                    "text": "fluid.bufchroma~ @source stem_vocals.mono @features stem_vocals_chroma.features"
                }
            },
            {
                "box": {
                    "id": "obj-341",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 2657.894711494446, 2377.464819908142, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-340",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2919.8665459156036, 2414.0845386981964, 253.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_vocals.mono"
                }
            },
            {
                "box": {
                    "id": "obj-339",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3198.7397890090942, 2377.464819908142, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-338",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3457.8947219848633, 2414.0845386981964, 252.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_drums.mono"
                }
            },
            {
                "box": {
                    "id": "obj-337",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4057.8947298526764, 2414.0845386981964, 244.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_bass.mono"
                }
            },
            {
                "box": {
                    "id": "obj-335",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3810.0074026584625, 2377.464819908142, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-330",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 4388.88064968586, 2360.5634112358093, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-329",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4636.767976880074, 2398.591580748558, 245.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_melo.mono"
                }
            },
            {
                "box": {
                    "id": "obj-327",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2625.5003448724747, 1229.5774809122086, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-325",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 2694.5144302845, 1371.8310039043427, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-323",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3231.1341556310654, 1371.8310039043427, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-322",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3840.9933185577393, 1371.8310039043427, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-321",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 4425.500368475914, 1366.197201013565, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-315",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4388.88064968586, 2398.591580748558, 234.0, 22.0 ],
                    "text": "features stem_melo_pitch.features fuschia"
                }
            },
            {
                "box": {
                    "id": "obj-316",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4357.894733786583, 2260.563409924507, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-317",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4388.88064968586, 2439.4366517066956, 303.53984743356705, 80.53097993135452 ]
                }
            },
            {
                "box": {
                    "id": "obj-318",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 4388.88064968586, 2329.5774953365326, 466.0, 22.0 ],
                    "text": "fluid.bufpitch~ @source stem_melo.mono @features stem_melo_pitch.features"
                }
            },
            {
                "box": {
                    "id": "obj-306",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3810.0074026584625, 2414.0845386981964, 233.0, 22.0 ],
                    "text": "features stem_bass_pitch.features fuschia"
                }
            },
            {
                "box": {
                    "id": "obj-307",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3783.246838927269, 2277.46481859684, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-308",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3810.0074026584625, 2445.070454597473, 303.53984743356705, 80.53097993135452 ]
                }
            },
            {
                "box": {
                    "id": "obj-309",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3810.0074026584625, 2335.21129822731, 464.0, 22.0 ],
                    "text": "fluid.bufpitch~ @source stem_bass.mono @features stem_bass_pitch.features"
                }
            },
            {
                "box": {
                    "id": "obj-302",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3198.7397890090942, 2414.0845386981964, 241.0, 22.0 ],
                    "text": "features stem_drums_pitch.features fuschia"
                }
            },
            {
                "box": {
                    "id": "obj-303",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3167.7538731098175, 2287.3239736557007, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-304",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3198.7397890090942, 2445.070454597473, 303.53984743356705, 80.53097993135452 ]
                }
            },
            {
                "box": {
                    "id": "obj-305",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3198.7397890090942, 2335.21129822731, 480.0, 22.0 ],
                    "text": "fluid.bufpitch~ @source stem_drums.mono @features stem_drums_pitch.features"
                }
            },
            {
                "box": {
                    "id": "obj-301",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2657.894711494446, 2414.0845386981964, 242.0, 22.0 ],
                    "text": "features stem_vocals_pitch.features fuschia"
                }
            },
            {
                "box": {
                    "id": "obj-299",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2625.5003448724747, 2287.3239736557007, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-297",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2657.894711494446, 2445.070454597473, 303.53984743356705, 80.53097993135452 ]
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-295",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4573.387694358826, 614.0845150947571, 187.0, 22.0 ],
                    "text": "buffer~ stem_melo_pitch.features"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-294",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3957.894728541374, 614.0845150947571, 186.0, 22.0 ],
                    "text": "buffer~ stem_bass_pitch.features"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-293",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3362.1200728416443, 614.0845150947571, 194.0, 22.0 ],
                    "text": "buffer~ stem_drums_pitch.features"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-292",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2840.9933054447174, 608.4507122039795, 212.4075037240982, 22.0 ],
                    "text": "buffer~ stem_vocals_pitch.features"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-288",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2840.9933054447174, 587.3239513635635, 190.85577845573425, 22.0 ],
                    "text": "buffer~ stem_vocals_loud.stats"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-287",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2840.9933054447174, 560.56338763237, 208.95922768115997, 22.0 ],
                    "text": "buffer~ stem_vocals_loud.features"
                }
            },
            {
                "box": {
                    "id": "obj-275",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2625.5003448724747, 2066.1972101926804, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-276",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2698.7397824525833, 2235.211296916008, 169.0, 20.0 ],
                    "text": "The median loudness in dBFS"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-277",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2657.894711494446, 2235.211296916008, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-278",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2657.894711494446, 2198.5915781259537, 29.5, 22.0 ],
                    "text": "$6"
                }
            },
            {
                "box": {
                    "id": "obj-279",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "list" ],
                    "patching_rect": [ 2657.894711494446, 2156.3380564451218, 251.0, 22.0 ],
                    "text": "fluid.buf2list @source stem_vocals_loud.stats"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                    "id": "obj-280",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2657.894711494446, 2102.8169289827347, 449.0, 22.0 ],
                    "text": "fluid.bufstats~ @source stem_vocals_loud.features @stats stem_vocals_loud.stats"
                }
            },
            {
                "box": {
                    "id": "obj-281",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 2662.120063662529, 1860.5634046792984, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-283",
                    "linecount": 3,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2662.120063662529, 1908.450729250908, 208.42106008529663, 49.0 ],
                    "text": "addlayer featuresbuffer stem_vocals_loud.features, color stem_vocals_loud.features 1. 1. 0. 1."
                }
            },
            {
                "box": {
                    "id": "obj-284",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2883.2468271255493, 1908.450729250908, 253.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_vocals.mono"
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "id": "obj-285",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2662.120063662529, 1987.3239697217941, 311.0, 90.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 0.949019607843137, 0.670588235294118, 1.0, 1.0 ],
                    "thickness": 4
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-286",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2662.120063662529, 1987.3239697217941, 311.1111259460449, 89.58333760499954 ]
                }
            },
            {
                "box": {
                    "id": "obj-271",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3167.7538731098175, 1235.2112838029861, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-270",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2625.5003448724747, 1735.211290359497, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-258",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3162.12007021904, 2056.3380551338196, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-259",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3252.2609164714813, 2229.5774940252304, 169.0, 20.0 ],
                    "text": "The median loudness in dBFS"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-260",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3198.7397890090942, 2229.5774940252304, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-261",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3198.7397890090942, 2187.3239723443985, 29.5, 22.0 ],
                    "text": "$6"
                }
            },
            {
                "box": {
                    "id": "obj-262",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "list" ],
                    "patching_rect": [ 3198.7397890090942, 2145.0704506635666, 251.0, 22.0 ],
                    "text": "fluid.buf2list @source stem_drums_loud.stats"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                    "id": "obj-263",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3198.7397890090942, 2092.957773923874, 448.0, 22.0 ],
                    "text": "fluid.bufstats~ @source stem_drums_loud.features @stats stem_drums_loud.stats"
                }
            },
            {
                "box": {
                    "id": "obj-264",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3210.0073947906494, 1856.3380525112152, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-265",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3431.1341582536697, 1892.9577713012695, 252.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_drums.mono"
                }
            },
            {
                "box": {
                    "id": "obj-266",
                    "linecount": 3,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3210.0073947906494, 1892.9577713012695, 207.14285516738892, 49.0 ],
                    "text": "addlayer featuresbuffer stem_drums_loud.features, color stem_drums_loud.features 1. 1. 0. 1."
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "id": "obj-268",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3210.0073947906494, 1977.4648146629333, 311.0, 90.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 0.949019607843137, 0.670588235294118, 1.0, 1.0 ],
                    "thickness": 4
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-269",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3210.0073947906494, 1977.4648146629333, 311.1111259460449, 89.58333760499954 ]
                }
            },
            {
                "box": {
                    "id": "obj-254",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3167.7538731098175, 1729.5774874687195, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-253",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 3167.7538731098175, 845.0704336166382, 22.0, 22.0 ],
                    "text": "t b"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-252",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3362.1200728416443, 587.3239513635635, 173.0, 22.0 ],
                    "text": "buffer~ stem_drums_loud.stats"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-251",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3362.1200728416443, 560.56338763237, 191.0, 22.0 ],
                    "text": "buffer~ stem_drums_loud.features"
                }
            },
            {
                "box": {
                    "id": "obj-250",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3779.021486759186, 1235.2112838029861, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-249",
                    "linecount": 2,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2657.894711494446, 418.3098646402359, 507.0, 35.0 ],
                    "text": "read \"/Users/alexandregagne/Documents/EBYS/EBYS_INFRA/stems/htdemucs/DREPTO CE3o/DREPTO CE3o_vocals.wav\""
                }
            },
            {
                "box": {
                    "id": "obj-248",
                    "linecount": 2,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3204.373591899872, 418.3098646402359, 502.0, 35.0 ],
                    "text": "read \"/Users/alexandregagne/Documents/EBYS/EBYS_INFRA/stems/htdemucs/DREPTO CE3o/DREPTO CE3o_drums.wav\""
                }
            },
            {
                "box": {
                    "id": "obj-247",
                    "linecount": 2,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4373.387691736221, 418.3098646402359, 499.0, 35.0 ],
                    "text": "read \"/Users/alexandregagne/Documents/EBYS/EBYS_INFRA/stems/htdemucs/DREPTO CE3o/DREPTO CE3o_other.wav\""
                }
            },
            {
                "box": {
                    "id": "obj-245",
                    "linecount": 2,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3783.246838927269, 418.3098646402359, 489.0, 35.0 ],
                    "text": "read \"/Users/alexandregagne/Documents/EBYS/EBYS_INFRA/stems/htdemucs/DREPTO CE3o/DREPTO CE3o_bass.wav\""
                }
            },
            {
                "box": {
                    "id": "obj-243",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3773.387683868408, 1729.5774874687195, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-227",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3773.387683868408, 2045.0704493522644, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-228",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3862.120079398155, 2214.084536075592, 169.0, 20.0 ],
                    "text": "The median loudness in dBFS"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-229",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3810.0074026584625, 2214.084536075592, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-230",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3810.0074026584625, 2177.4648172855377, 29.5, 22.0 ],
                    "text": "$6"
                }
            },
            {
                "box": {
                    "id": "obj-237",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "list" ],
                    "patching_rect": [ 3810.0074026584625, 2129.577492713928, 243.0, 22.0 ],
                    "text": "fluid.buf2list @source stem_bass_loud.stats"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                    "id": "obj-238",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3810.0074026584625, 2077.4648159742355, 432.0, 22.0 ],
                    "text": "fluid.bufstats~ @source stem_bass_loud.features @stats stem_bass_loud.stats"
                }
            },
            {
                "box": {
                    "id": "obj-226",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 3757.89472591877, 845.0704336166382, 22.0, 22.0 ],
                    "text": "t b"
                }
            },
            {
                "box": {
                    "id": "obj-220",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 3810.0074026584625, 1839.4366438388824, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-222",
                    "linecount": 5,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3810.0074026584625, 1877.4648133516312, 139.18917989730835, 76.0 ],
                    "text": "addlayer featuresbuffer stem_bass_loud.features, color stem_bass_loud.features 1. 1. 0. 1."
                }
            },
            {
                "box": {
                    "id": "obj-223",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3957.894728541374, 1877.4648133516312, 244.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_bass.mono"
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "id": "obj-224",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3810.0074026584625, 1966.1972088813782, 311.0, 90.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 0.949019607843137, 0.670588235294118, 1.0, 1.0 ],
                    "thickness": 4
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-225",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3810.0074026584625, 1966.1972088813782, 311.1111259460449, 89.58333760499954 ]
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-219",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3957.894728541374, 587.3239513635635, 165.0, 22.0 ],
                    "text": "buffer~ stem_bass_loud.stats"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-218",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3957.894728541374, 560.56338763237, 183.0, 22.0 ],
                    "text": "buffer~ stem_bass_loud.features"
                }
            },
            {
                "box": {
                    "id": "obj-217",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 4383.246846795082, 1829.5774887800217, 32.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-216",
                    "linecount": 2,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4725.500372409821, 1871.8310104608536, 153.0, 35.0 ],
                    "text": "clear, addlayer audiobuffer stem_melo.mono"
                }
            },
            {
                "box": {
                    "id": "obj-208",
                    "linecount": 2,
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4398.7398047447205, 1871.8310104608536, 306.0, 35.0 ],
                    "text": "addlayer featuresbuffer stem_melo_loud.features, color stem_melo_loud.features 1. 1. 0. 1."
                }
            },
            {
                "box": {
                    "id": "obj-202",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 4379.021494626999, 845.0704336166382, 22.0, 22.0 ],
                    "text": "t b"
                }
            },
            {
                "box": {
                    "id": "obj-192",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4357.894733786583, 1729.5774874687195, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-189",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4357.894733786583, 1229.5774809122086, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-182",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4567.753891468048, 560.56338763237, 184.0, 22.0 ],
                    "text": "buffer~ stem_melo_loud.features"
                }
            },
            {
                "box": {
                    "id": "obj-181",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4352.260930895805, 2035.2112942934036, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-166",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4931.1341779232025, 2208.4507331848145, 173.0, 20.0 ],
                    "text": "The maximum true-peak"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-167",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4873.387698292732, 2208.4507331848145, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-168",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4873.387698292732, 2171.83101439476, 29.5, 22.0 ],
                    "text": "$7"
                }
            },
            {
                "box": {
                    "id": "obj-6",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "list" ],
                    "patching_rect": [ 4873.387698292732, 2135.211295604706, 247.0, 35.0 ],
                    "text": "fluid.buf2list @source stem_melo_loud.stats @startchan 1"
                }
            },
            {
                "box": {
                    "id": "obj-169",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4667.75389277935, 2208.4507331848145, 173.0, 20.0 ],
                    "text": "The average loudness in dBFS"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-170",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4615.641216039658, 2208.4507331848145, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-171",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4615.641216039658, 2171.83101439476, 29.5, 22.0 ],
                    "text": "$1"
                }
            },
            {
                "box": {
                    "id": "obj-173",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4436.767974257469, 2208.4507331848145, 169.0, 20.0 ],
                    "text": "The median loudness in dBFS"
                }
            },
            {
                "box": {
                    "format": 6,
                    "id": "obj-175",
                    "maxclass": "flonum",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4383.246846795082, 2208.4507331848145, 50.0, 22.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-176",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4383.246846795082, 2171.83101439476, 29.5, 22.0 ],
                    "text": "$6"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-24",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4567.753891468048, 581.690148472786, 166.0, 22.0 ],
                    "text": "buffer~ stem_melo_loud.stats"
                }
            },
            {
                "box": {
                    "id": "obj-177",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "list" ],
                    "patching_rect": [ 4383.246846795082, 2135.211295604706, 243.0, 22.0 ],
                    "text": "fluid.buf2list @source stem_melo_loud.stats"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                    "id": "obj-179",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 4383.246846795082, 2077.4648159742355, 433.0, 22.0 ],
                    "text": "fluid.bufstats~ @source stem_melo_loud.features @stats stem_melo_loud.stats"
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "id": "obj-157",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4398.7398047447205, 1939.4366451501846, 311.0, 90.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 0.949019607843137, 0.670588235294118, 1.0, 1.0 ],
                    "thickness": 4
                }
            },
            {
                "box": {
                    "id": "obj-154",
                    "maxclass": "dict.view",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4388.88064968586, 1587.3239644765854, 170.0, 150.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-155",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "dictionary" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 341.0, 132.0, 515.0, 725.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 81.5, 476.0, 130.0, 22.0 ],
                                    "text": "loadmess 0 0 0 0 0 0 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 8,
                                    "outlettype": [ "", "", "", "", "", "", "", "" ],
                                    "patching_rect": [ 28.5, 517.0, 113.20833333333337, 22.0 ],
                                    "text": "unjoin 7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "linecount": 8,
                                    "maxclass": "newobj",
                                    "numinlets": 8,
                                    "numoutlets": 1,
                                    "outlettype": [ "dictionary" ],
                                    "patching_rect": [ 29.0, 552.0, 99.0, 116.0 ],
                                    "text": "dict.pack centroid(Hz): spread(Hz): skewness(ratio): kurtosis(ratio): rolloff(Hz): flatness(dB): crest(dB):"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 93.5, 349.0, 29.5, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 28.5, 476.0, 51.0, 22.0 ],
                                    "text": "zl.group"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 93.5, 390.0, 81.5, 22.0 ],
                                    "text": "int"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 18.0, 262.0, 90.0, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 18.0, 308.0, 40.0, 22.0 ],
                                    "text": "uzi 7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 228.0, 39.0, 22.0 ],
                                    "text": "round"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 18.0, 108.0, 49.0, 22.0 ],
                                    "text": "t f b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 18.0, 188.0, 49.0, 22.0 ],
                                    "text": "* 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "", "" ],
                                    "patching_rect": [ 48.0, 158.0, 135.0, 22.0 ],
                                    "text": "getattr samps @listen 0"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 106.0, 188.0, 203.0, 22.0 ],
                                    "text": "buffer~ stem_melo_spectral.features"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 93.5, 420.0, 199.0, 22.0 ],
                                    "text": "peek~ stem_melo_spectral.features"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-27",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 18.0, 68.0, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-67",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 8.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-68",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 29.0, 681.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 91.0, 501.0, 39.0, 501.0, 39.0, 513.0, 38.0, 513.0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 6 ],
                                    "source": [ "obj-2", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 5 ],
                                    "source": [ "obj-2", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 4 ],
                                    "source": [ "obj-2", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 3 ],
                                    "source": [ "obj-2", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 2 ],
                                    "source": [ "obj-2", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 1 ],
                                    "source": [ "obj-2", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 0 ],
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-25", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "midpoints": [ 103.0, 458.0, 38.0, 458.0 ],
                                    "source": [ "obj-37", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "source": [ "obj-43", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 1 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-55", 0 ],
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-52", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-58", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "midpoints": [ 48.5, 339.0, 103.0, 339.0 ],
                                    "source": [ "obj-58", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-58", 0 ],
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 1 ],
                                    "midpoints": [ 98.5, 336.5, 165.5, 336.5 ],
                                    "source": [ "obj-59", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "source": [ "obj-60", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 2 ],
                                    "midpoints": [ 113.5, 372.0, 283.0, 372.0 ],
                                    "source": [ "obj-65", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 0 ],
                                    "midpoints": [ 103.0, 375.0, 103.0, 375.0 ],
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            }
                        ],
                        "styles": [
                            {
                                "name": "max6box",
                                "default": {
                                    "accentcolor": [ 0.8, 0.839216, 0.709804, 1.0 ],
                                    "bgcolor": [ 1.0, 1.0, 1.0, 0.5 ],
                                    "textcolor_inverse": [ 0.0, 0.0, 0.0, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "max6inlet",
                                "default": {
                                    "color": [ 0.423529, 0.372549, 0.27451, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "max6message",
                                "default": {
                                    "bgfillcolor": {
                                        "angle": 270.0,
                                        "autogradient": 0,
                                        "color": [ 0.290196, 0.309804, 0.301961, 1.0 ],
                                        "color1": [ 0.866667, 0.866667, 0.866667, 1.0 ],
                                        "color2": [ 0.788235, 0.788235, 0.788235, 1.0 ],
                                        "proportion": 0.39,
                                        "type": "gradient"
                                    },
                                    "textcolor_inverse": [ 0.0, 0.0, 0.0, 1.0 ]
                                },
                                "parentstyle": "max6box",
                                "multi": 0
                            },
                            {
                                "name": "max6outlet",
                                "default": {
                                    "color": [ 0.0, 0.454902, 0.498039, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            }
                        ]
                    },
                    "patching_rect": [ 4388.88064968586, 1550.704245686531, 111.0, 22.0 ],
                    "text": "p \"feature lookup\""
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "contdata": 1,
                    "id": "obj-152",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4388.88064968586, 1429.577483534813, 310.0, 90.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 0.254901960784314, 0.905882352941176, 0.450980392156863, 1.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-153",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4388.88064968586, 1429.577483534813, 311.1111259460449, 89.58333760499954 ]
                }
            },
            {
                "box": {
                    "id": "obj-150",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4598.739807367325, 1398.5915676355362, 230.0, 22.0 ],
                    "text": "features stem_melo_spectral.features red"
                }
            },
            {
                "box": {
                    "id": "obj-151",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4388.88064968586, 1398.5915676355362, 227.0, 22.0 ],
                    "text": "clear, waveform stem_melo.mono source"
                }
            },
            {
                "box": {
                    "id": "obj-148",
                    "maxclass": "dict.view",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3810.0074026584625, 1587.3239644765854, 170.0, 150.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-149",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "dictionary" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 341.0, 132.0, 515.0, 725.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 81.5, 476.0, 130.0, 22.0 ],
                                    "text": "loadmess 0 0 0 0 0 0 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 8,
                                    "outlettype": [ "", "", "", "", "", "", "", "" ],
                                    "patching_rect": [ 28.5, 517.0, 113.20833333333337, 22.0 ],
                                    "text": "unjoin 7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "linecount": 8,
                                    "maxclass": "newobj",
                                    "numinlets": 8,
                                    "numoutlets": 1,
                                    "outlettype": [ "dictionary" ],
                                    "patching_rect": [ 29.0, 552.0, 99.0, 116.0 ],
                                    "text": "dict.pack centroid(Hz): spread(Hz): skewness(ratio): kurtosis(ratio): rolloff(Hz): flatness(dB): crest(dB):"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 93.5, 349.0, 29.5, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 28.5, 476.0, 51.0, 22.0 ],
                                    "text": "zl.group"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 93.5, 390.0, 81.5, 22.0 ],
                                    "text": "int"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 18.0, 262.0, 90.0, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 18.0, 308.0, 40.0, 22.0 ],
                                    "text": "uzi 7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 228.0, 39.0, 22.0 ],
                                    "text": "round"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 18.0, 108.0, 49.0, 22.0 ],
                                    "text": "t f b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 18.0, 188.0, 49.0, 22.0 ],
                                    "text": "* 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "", "" ],
                                    "patching_rect": [ 48.0, 158.0, 135.0, 22.0 ],
                                    "text": "getattr samps @listen 0"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 106.0, 188.0, 203.0, 22.0 ],
                                    "text": "buffer~ stem_bass_spectral.features"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 93.5, 420.0, 198.0, 22.0 ],
                                    "text": "peek~ stem_bass_spectral.features"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-27",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 18.0, 68.0, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-67",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 8.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-68",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 29.0, 681.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 91.0, 501.0, 39.0, 501.0, 39.0, 513.0, 38.0, 513.0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 6 ],
                                    "source": [ "obj-2", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 5 ],
                                    "source": [ "obj-2", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 4 ],
                                    "source": [ "obj-2", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 3 ],
                                    "source": [ "obj-2", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 2 ],
                                    "source": [ "obj-2", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 1 ],
                                    "source": [ "obj-2", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 0 ],
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-25", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "midpoints": [ 103.0, 458.0, 38.0, 458.0 ],
                                    "source": [ "obj-37", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "source": [ "obj-43", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 1 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-55", 0 ],
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-52", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-58", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "midpoints": [ 48.5, 339.0, 103.0, 339.0 ],
                                    "source": [ "obj-58", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-58", 0 ],
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 1 ],
                                    "midpoints": [ 98.5, 336.5, 165.5, 336.5 ],
                                    "source": [ "obj-59", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "source": [ "obj-60", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 2 ],
                                    "midpoints": [ 113.5, 372.0, 282.0, 372.0 ],
                                    "source": [ "obj-65", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 0 ],
                                    "midpoints": [ 103.0, 375.0, 103.0, 375.0 ],
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            }
                        ],
                        "styles": [
                            {
                                "name": "max6box",
                                "default": {
                                    "accentcolor": [ 0.8, 0.839216, 0.709804, 1.0 ],
                                    "bgcolor": [ 1.0, 1.0, 1.0, 0.5 ],
                                    "textcolor_inverse": [ 0.0, 0.0, 0.0, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "max6inlet",
                                "default": {
                                    "color": [ 0.423529, 0.372549, 0.27451, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "max6message",
                                "default": {
                                    "bgfillcolor": {
                                        "angle": 270.0,
                                        "autogradient": 0,
                                        "color": [ 0.290196, 0.309804, 0.301961, 1.0 ],
                                        "color1": [ 0.866667, 0.866667, 0.866667, 1.0 ],
                                        "color2": [ 0.788235, 0.788235, 0.788235, 1.0 ],
                                        "proportion": 0.39,
                                        "type": "gradient"
                                    },
                                    "textcolor_inverse": [ 0.0, 0.0, 0.0, 1.0 ]
                                },
                                "parentstyle": "max6box",
                                "multi": 0
                            },
                            {
                                "name": "max6outlet",
                                "default": {
                                    "color": [ 0.0, 0.454902, 0.498039, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            }
                        ]
                    },
                    "patching_rect": [ 3810.0074026584625, 1550.704245686531, 111.0, 22.0 ],
                    "text": "p \"feature lookup\""
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "contdata": 1,
                    "id": "obj-146",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3810.0074026584625, 1445.0704414844513, 310.0, 90.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 0.254901960784314, 0.905882352941176, 0.450980392156863, 1.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-147",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3810.0074026584625, 1445.0704414844513, 311.1111259460449, 89.58333760499954 ]
                }
            },
            {
                "box": {
                    "id": "obj-144",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4019.8665603399277, 1408.450722694397, 229.0, 22.0 ],
                    "text": "features stem_bass_spectral.features red"
                }
            },
            {
                "box": {
                    "id": "obj-145",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3810.0074026584625, 1408.450722694397, 227.0, 22.0 ],
                    "text": "clear, waveform stem_bass.mono source"
                }
            },
            {
                "box": {
                    "id": "obj-142",
                    "maxclass": "dict.view",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3204.373591899872, 1587.3239644765854, 170.0, 150.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-143",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "dictionary" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 341.0, 132.0, 515.0, 725.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 81.5, 476.0, 130.0, 22.0 ],
                                    "text": "loadmess 0 0 0 0 0 0 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 8,
                                    "outlettype": [ "", "", "", "", "", "", "", "" ],
                                    "patching_rect": [ 28.5, 517.0, 113.20833333333337, 22.0 ],
                                    "text": "unjoin 7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "linecount": 8,
                                    "maxclass": "newobj",
                                    "numinlets": 8,
                                    "numoutlets": 1,
                                    "outlettype": [ "dictionary" ],
                                    "patching_rect": [ 29.0, 552.0, 99.0, 116.0 ],
                                    "text": "dict.pack centroid(Hz): spread(Hz): skewness(ratio): kurtosis(ratio): rolloff(Hz): flatness(dB): crest(dB):"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 93.5, 349.0, 29.5, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 28.5, 476.0, 51.0, 22.0 ],
                                    "text": "zl.group"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 93.5, 390.0, 81.5, 22.0 ],
                                    "text": "int"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 18.0, 262.0, 90.0, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 18.0, 308.0, 40.0, 22.0 ],
                                    "text": "uzi 7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 228.0, 39.0, 22.0 ],
                                    "text": "round"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 18.0, 108.0, 49.0, 22.0 ],
                                    "text": "t f b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 18.0, 188.0, 49.0, 22.0 ],
                                    "text": "* 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "", "" ],
                                    "patching_rect": [ 48.0, 158.0, 135.0, 22.0 ],
                                    "text": "getattr samps @listen 0"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 106.0, 188.0, 211.0, 22.0 ],
                                    "text": "buffer~ stem_drums_spectral.features"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 93.5, 420.0, 206.0, 22.0 ],
                                    "text": "peek~ stem_drums_spectral.features"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-27",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 18.0, 68.0, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-67",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 8.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-68",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 29.0, 681.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 91.0, 501.0, 39.0, 501.0, 39.0, 513.0, 38.0, 513.0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 6 ],
                                    "source": [ "obj-2", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 5 ],
                                    "source": [ "obj-2", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 4 ],
                                    "source": [ "obj-2", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 3 ],
                                    "source": [ "obj-2", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 2 ],
                                    "source": [ "obj-2", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 1 ],
                                    "source": [ "obj-2", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 0 ],
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-25", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "midpoints": [ 103.0, 458.0, 38.0, 458.0 ],
                                    "source": [ "obj-37", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "source": [ "obj-43", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 1 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-55", 0 ],
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-52", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-58", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "midpoints": [ 48.5, 339.0, 103.0, 339.0 ],
                                    "source": [ "obj-58", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-58", 0 ],
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 1 ],
                                    "midpoints": [ 98.5, 336.5, 165.5, 336.5 ],
                                    "source": [ "obj-59", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "source": [ "obj-60", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 2 ],
                                    "midpoints": [ 113.5, 372.0, 290.0, 372.0 ],
                                    "source": [ "obj-65", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 0 ],
                                    "midpoints": [ 103.0, 375.0, 103.0, 375.0 ],
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            }
                        ],
                        "styles": [
                            {
                                "name": "max6box",
                                "default": {
                                    "accentcolor": [ 0.8, 0.839216, 0.709804, 1.0 ],
                                    "bgcolor": [ 1.0, 1.0, 1.0, 0.5 ],
                                    "textcolor_inverse": [ 0.0, 0.0, 0.0, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "max6inlet",
                                "default": {
                                    "color": [ 0.423529, 0.372549, 0.27451, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "max6message",
                                "default": {
                                    "bgfillcolor": {
                                        "angle": 270.0,
                                        "autogradient": 0,
                                        "color": [ 0.290196, 0.309804, 0.301961, 1.0 ],
                                        "color1": [ 0.866667, 0.866667, 0.866667, 1.0 ],
                                        "color2": [ 0.788235, 0.788235, 0.788235, 1.0 ],
                                        "proportion": 0.39,
                                        "type": "gradient"
                                    },
                                    "textcolor_inverse": [ 0.0, 0.0, 0.0, 1.0 ]
                                },
                                "parentstyle": "max6box",
                                "multi": 0
                            },
                            {
                                "name": "max6outlet",
                                "default": {
                                    "color": [ 0.0, 0.454902, 0.498039, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            }
                        ]
                    },
                    "patching_rect": [ 3204.373591899872, 1550.704245686531, 111.0, 22.0 ],
                    "text": "p \"feature lookup\""
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "contdata": 1,
                    "id": "obj-140",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3204.373591899872, 1445.0704414844513, 310.0, 90.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 0.254901960784314, 0.905882352941176, 0.450980392156863, 1.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-141",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3198.7397890090942, 1445.0704414844513, 311.1111259460449, 89.58333760499954 ]
                }
            },
            {
                "box": {
                    "id": "obj-138",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3415.6412003040314, 1408.450722694397, 242.10527181625366, 22.0 ],
                    "text": "features stem_drums_spectral.features red"
                }
            },
            {
                "box": {
                    "id": "obj-139",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3198.7397890090942, 1408.450722694397, 235.0, 22.0 ],
                    "text": "clear, waveform stem_drums.mono source"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-137",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4567.753891468048, 535.2112746238708, 203.0, 22.0 ],
                    "text": "buffer~ stem_melo_spectral.features"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-130",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3957.894728541374, 535.2112746238708, 203.0, 22.0 ],
                    "text": "buffer~ stem_bass_spectral.features"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-129",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3362.1200728416443, 535.2112746238708, 211.0, 22.0 ],
                    "text": "buffer~ stem_drums_spectral.features"
                }
            },
            {
                "box": {
                    "id": "obj-128",
                    "maxclass": "dict.view",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2667.7538665533066, 1587.3239644765854, 170.0, 150.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-69",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "dictionary" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 341.0, 132.0, 515.0, 725.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-1",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 81.5, 476.0, 130.0, 22.0 ],
                                    "text": "loadmess 0 0 0 0 0 0 0"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-2",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 8,
                                    "outlettype": [ "", "", "", "", "", "", "", "" ],
                                    "patching_rect": [ 28.5, 517.0, 113.20833333333337, 22.0 ],
                                    "text": "unjoin 7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-25",
                                    "linecount": 8,
                                    "maxclass": "newobj",
                                    "numinlets": 8,
                                    "numoutlets": 1,
                                    "outlettype": [ "dictionary" ],
                                    "patching_rect": [ 29.0, 552.0, 99.0, 116.0 ],
                                    "text": "dict.pack centroid(Hz): spread(Hz): skewness(ratio): kurtosis(ratio): rolloff(Hz): flatness(dB): crest(dB):"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-65",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 93.5, 349.0, 29.5, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-61",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 28.5, 476.0, 51.0, 22.0 ],
                                    "text": "zl.group"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-60",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "int" ],
                                    "patching_rect": [ 93.5, 390.0, 81.5, 22.0 ],
                                    "text": "int"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-59",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "int" ],
                                    "patching_rect": [ 18.0, 262.0, 90.0, 22.0 ],
                                    "text": "t b i"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-58",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 3,
                                    "outlettype": [ "bang", "bang", "int" ],
                                    "patching_rect": [ 18.0, 308.0, 40.0, 22.0 ],
                                    "text": "uzi 7"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-55",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 228.0, 39.0, 22.0 ],
                                    "text": "round"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-52",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 18.0, 108.0, 49.0, 22.0 ],
                                    "text": "t f b"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-51",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 18.0, 188.0, 49.0, 22.0 ],
                                    "text": "* 1."
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-43",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 3,
                                    "outlettype": [ "", "", "" ],
                                    "patching_rect": [ 48.0, 158.0, 135.0, 22.0 ],
                                    "text": "getattr samps @listen 0"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 1.0, 0.43921568627451, 0.662745098039216, 1.0 ],
                                    "id": "obj-42",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 106.0, 188.0, 211.0, 22.0 ],
                                    "text": "buffer~ stem_vocals_spectral.features"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-37",
                                    "maxclass": "newobj",
                                    "numinlets": 3,
                                    "numoutlets": 1,
                                    "outlettype": [ "float" ],
                                    "patching_rect": [ 93.5, 420.0, 207.0, 22.0 ],
                                    "text": "peek~ stem_vocals_spectral.features"
                                }
                            },
                            {
                                "box": {
                                    "format": 6,
                                    "id": "obj-27",
                                    "maxclass": "flonum",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "bang" ],
                                    "parameter_enable": 0,
                                    "patching_rect": [ 18.0, 68.0, 50.0, 22.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-67",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 18.0, 8.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-68",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 29.0, 681.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "midpoints": [ 91.0, 501.0, 39.0, 501.0, 39.0, 513.0, 38.0, 513.0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 6 ],
                                    "source": [ "obj-2", 6 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 5 ],
                                    "source": [ "obj-2", 5 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 4 ],
                                    "source": [ "obj-2", 4 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 3 ],
                                    "source": [ "obj-2", 3 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 2 ],
                                    "source": [ "obj-2", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 1 ],
                                    "source": [ "obj-2", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-25", 0 ],
                                    "source": [ "obj-2", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-68", 0 ],
                                    "source": [ "obj-25", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-52", 0 ],
                                    "source": [ "obj-27", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "midpoints": [ 103.0, 458.0, 38.0, 458.0 ],
                                    "source": [ "obj-37", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-42", 0 ],
                                    "source": [ "obj-43", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 1 ],
                                    "source": [ "obj-43", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-55", 0 ],
                                    "source": [ "obj-51", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-43", 0 ],
                                    "source": [ "obj-52", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-51", 0 ],
                                    "source": [ "obj-52", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-59", 0 ],
                                    "source": [ "obj-55", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-61", 0 ],
                                    "source": [ "obj-58", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-65", 0 ],
                                    "midpoints": [ 48.5, 339.0, 103.0, 339.0 ],
                                    "source": [ "obj-58", 2 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-58", 0 ],
                                    "source": [ "obj-59", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 1 ],
                                    "midpoints": [ 98.5, 336.5, 165.5, 336.5 ],
                                    "source": [ "obj-59", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 0 ],
                                    "source": [ "obj-60", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-61", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-37", 2 ],
                                    "midpoints": [ 113.5, 372.0, 291.0, 372.0 ],
                                    "source": [ "obj-65", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-60", 0 ],
                                    "midpoints": [ 103.0, 375.0, 103.0, 375.0 ],
                                    "source": [ "obj-65", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-27", 0 ],
                                    "source": [ "obj-67", 0 ]
                                }
                            }
                        ],
                        "styles": [
                            {
                                "name": "max6box",
                                "default": {
                                    "accentcolor": [ 0.8, 0.839216, 0.709804, 1.0 ],
                                    "bgcolor": [ 1.0, 1.0, 1.0, 0.5 ],
                                    "textcolor_inverse": [ 0.0, 0.0, 0.0, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "max6inlet",
                                "default": {
                                    "color": [ 0.423529, 0.372549, 0.27451, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            },
                            {
                                "name": "max6message",
                                "default": {
                                    "bgfillcolor": {
                                        "angle": 270.0,
                                        "autogradient": 0,
                                        "color": [ 0.290196, 0.309804, 0.301961, 1.0 ],
                                        "color1": [ 0.866667, 0.866667, 0.866667, 1.0 ],
                                        "color2": [ 0.788235, 0.788235, 0.788235, 1.0 ],
                                        "proportion": 0.39,
                                        "type": "gradient"
                                    },
                                    "textcolor_inverse": [ 0.0, 0.0, 0.0, 1.0 ]
                                },
                                "parentstyle": "max6box",
                                "multi": 0
                            },
                            {
                                "name": "max6outlet",
                                "default": {
                                    "color": [ 0.0, 0.454902, 0.498039, 1.0 ]
                                },
                                "parentstyle": "",
                                "multi": 0
                            }
                        ]
                    },
                    "patching_rect": [ 2667.7538665533066, 1556.3380485773087, 111.0, 22.0 ],
                    "text": "p \"feature lookup\""
                }
            },
            {
                "box": {
                    "bgcolor": [ 0.2, 0.2, 0.2, 0.0 ],
                    "contdata": 1,
                    "id": "obj-118",
                    "maxclass": "multislider",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "orientation": 0,
                    "outlettype": [ "", "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2667.7538665533066, 1450.7042443752289, 310.0, 90.0 ],
                    "setminmax": [ 0.0, 1.0 ],
                    "slidercolor": [ 0.254901960784314, 0.905882352941176, 0.450980392156863, 1.0 ]
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-127",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2662.120063662529, 1450.7042443752289, 311.1111259460449, 89.58333760499954 ]
                }
            },
            {
                "box": {
                    "id": "obj-117",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2667.7538665533066, 1408.450722694397, 238.0, 22.0 ],
                    "text": "features stem_vocals_spectral.features red"
                }
            },
            {
                "box": {
                    "id": "obj-115",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2925.500348806381, 1408.450722694397, 196.0, 22.0 ],
                    "text": "clear, waveform stem_vocals.mono"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-108",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2840.9933054447174, 529.5774717330933, 227.92474591732025, 22.0 ],
                    "text": "buffer~ stem_vocals_spectral.features"
                }
            },
            {
                "box": {
                    "id": "obj-106",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3204.373591899872, 1098.5915637016296, 244.0, 22.0 ],
                    "text": "slices stem_drums.slices stem_drums.mono"
                }
            },
            {
                "box": {
                    "id": "obj-107",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3457.8947219848633, 1098.5915637016296, 195.0, 22.0 ],
                    "text": "clear, waveform stem_drums.mono"
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-104",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3210.0073947906494, 1150.7042404413223, 296.3414704799652, 101.88230270147324 ]
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-103",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3362.1200728416443, 508.4507108926773, 149.0, 22.0 ],
                    "text": "buffer~ stem_drums.slices"
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-99",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3819.8665577173233, 1150.7042404413223, 296.3414704799652, 101.88230270147324 ]
                }
            },
            {
                "box": {
                    "id": "obj-96",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3819.8665577173233, 1098.5915637016296, 228.0, 22.0 ],
                    "text": "slices stem_bass.slices stem_bass.mono"
                }
            },
            {
                "box": {
                    "id": "obj-97",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4057.8947298526764, 1098.5915637016296, 187.0, 22.0 ],
                    "text": "clear, waveform stem_bass.mono"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-95",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3962.1200807094574, 508.4507108926773, 141.0, 22.0 ],
                    "text": "buffer~ stem_bass.slices"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-92",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4573.387694358826, 508.4507108926773, 141.0, 22.0 ],
                    "text": "buffer~ stem_melo.slices"
                }
            },
            {
                "box": {
                    "id": "obj-89",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4394.514452576637, 1108.4507187604904, 229.0, 22.0 ],
                    "text": "slices stem_melo.slices stem_melo.mono"
                }
            },
            {
                "box": {
                    "id": "obj-90",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4631.134173989296, 1108.4507187604904, 188.0, 22.0 ],
                    "text": "clear, waveform stem_melo.mono"
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-88",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4394.514452576637, 1145.0704375505447, 296.3414704799652, 101.88230270147324 ]
                }
            },
            {
                "box": {
                    "id": "obj-71",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2667.7538665533066, 1098.5915637016296, 245.0, 22.0 ],
                    "text": "slices stem_vocals.slices stem_vocals.mono"
                }
            },
            {
                "box": {
                    "id": "obj-70",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2915.6411937475204, 1098.5915637016296, 196.0, 22.0 ],
                    "text": "clear, waveform stem_vocals.mono"
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-22",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 2667.7538665533066, 1150.7042404413223, 309.04251365661617, 99.99999642372131 ]
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-68",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2840.9933054447174, 508.4507108926773, 163.10000336170197, 22.0 ],
                    "text": "buffer~ stem_vocals.slices"
                }
            },
            {
                "box": {
                    "id": "obj-4002",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 212.19049763679504, 774.60103058815, 155.0, 22.0 ],
                    "text": "prepend set_track_name"
                }
            },
            {
                "box": {
                    "id": "obj-41",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 748.666668176651, 159.99999618530273, 29.5, 22.0 ],
                    "text": "4."
                }
            },
            {
                "box": {
                    "id": "obj-39",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "patching_rect": [ 748.666668176651, 202.60868901014328, 29.5, 22.0 ],
                    "text": "+ 1"
                }
            },
            {
                "box": {
                    "id": "obj-38",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 812.1449269652367, 159.130430996418, 45.0, 22.0 ],
                    "text": "reset 1"
                }
            },
            {
                "box": {
                    "id": "obj-36",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 812.1449269652367, 202.60868901014328, 29.5, 22.0 ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-33",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 738.1956276297569, 244.36088055372238, 29.5, 22.0 ],
                    "text": "5"
                }
            },
            {
                "box": {
                    "id": "obj-11",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 9.774435222148895, 189.47366738319397, 39.0, 22.0 ],
                    "text": "query"
                }
            },
            {
                "box": {
                    "id": "obj-8",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 4,
                    "outlettype": [ "bang", "bang", "bang", "bang" ],
                    "patching_rect": [ 63.909768760204315, 151.12780612707138, 52.0, 22.0 ],
                    "text": "t b b b b"
                }
            },
            {
                "box": {
                    "id": "obj-5",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 9.774435222148895, 243.6090009212494, 44.0, 22.0 ],
                    "text": "line $1"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-1",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 9.774435222148895, 43.37349557876587, 258.0, 20.0 ],
                    "text": "EBYS — OFFLINE ANALYZER + PLAYBACK"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-9",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 63.82743775844574, 85.41666340827942, 101.0, 20.0 ],
                    "text": "== LOADING =="
                }
            },
            {
                "box": {
                    "id": "obj-10",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 9.774435222148895, 114.78946340084076, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-13",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 72.8474588394165, 115.78946340084076, 113.0, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "streamWatcher.js",
                        "parameter_enable": 0
                    },
                    "text": "js streamWatcher.js"
                }
            },
            {
                "box": {
                    "id": "obj-14",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 63.909768760204315, 190.22554701566696, 398.58156859874725, 22.0 ],
                    "text": "read /Users/alexandregagne/Documents/EBYS/EBYS_INFRA/stream.txt"
                }
            },
            {
                "box": {
                    "id": "obj-15",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 3,
                    "outlettype": [ "", "bang", "int" ],
                    "patching_rect": [ 63.909768760204315, 244.36088055372238, 80.0, 22.0 ],
                    "text": "text"
                }
            },
            {
                "box": {
                    "id": "obj-16",
                    "maxclass": "newobj",
                    "numinlets": 5,
                    "numoutlets": 4,
                    "outlettype": [ "int", "", "", "int" ],
                    "patching_rect": [ 608.6666715145111, 159.99999618530273, 79.3370310664177, 22.0 ],
                    "text": "counter 1 4"
                }
            },
            {
                "box": {
                    "id": "obj-27",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "", "", "", "", "" ],
                    "patching_rect": [ 63.909768760204315, 285.71426033973694, 87.78540849685669, 22.0 ],
                    "saved_object_attributes": {
                        "legacyoutputorder": 0
                    },
                    "text": "regexp (/.+)"
                }
            },
            {
                "box": {
                    "id": "obj-30",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "", "", "", "", "" ],
                    "patching_rect": [ 212.19049763679504, 744.8137967586517, 92.9116638302803, 22.0 ],
                    "saved_object_attributes": {
                        "legacyoutputorder": 0
                    },
                    "text": "regexp [^/]+$"
                }
            },
            {
                "box": {
                    "color": [ 0.431372549019608, 0.431372549019608, 0.431372549019608, 1.0 ],
                    "id": "obj-100",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2657.894711494446, 508.4507108926773, 152.43855858445164, 22.0 ],
                    "saved_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "saved_newobj_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "text": "buffer~ stem_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-190",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2657.894711494446, 487.32395005226135, 100.0, 20.0 ],
                    "text": "vocals"
                }
            },
            {
                "box": {
                    "color": [ 0.431372549019608, 0.431372549019608, 0.431372549019608, 1.0 ],
                    "id": "obj-200",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4379.021494626999, 508.4507108926773, 138.4, 22.0 ],
                    "saved_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "saved_newobj_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "text": "buffer~ stem_melo"
                }
            },
            {
                "box": {
                    "id": "obj-290",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4373.387691736221, 487.32395005226135, 100.0, 20.0 ],
                    "text": "melody"
                }
            },
            {
                "box": {
                    "color": [ 0.431372549019608, 0.431372549019608, 0.431372549019608, 1.0 ],
                    "id": "obj-300",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3762.120078086853, 508.4507108926773, 138.4, 22.0 ],
                    "saved_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "saved_newobj_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "text": "buffer~ stem_bass"
                }
            },
            {
                "box": {
                    "id": "obj-390",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3757.89472591877, 481.69014716148376, 100.0, 20.0 ],
                    "text": "bass"
                }
            },
            {
                "box": {
                    "color": [ 0.431372549019608, 0.431372549019608, 0.431372549019608, 1.0 ],
                    "id": "obj-400",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3167.7538731098175, 508.4507108926773, 115.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "saved_newobj_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "text": "buffer~ stem_drums"
                }
            },
            {
                "box": {
                    "id": "obj-490",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3167.7538731098175, 487.32395005226135, 100.0, 20.0 ],
                    "text": "drums"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-35",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2657.894711494446, 460.5633863210678, 164.0, 20.0 ],
                    "text": "== OFFLINE ANALYSIS =="
                }
            },
            {
                "box": {
                    "id": "obj-110",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                    "patching_rect": [ 2652.260908603668, 787.3239539861679, 138.4, 22.0 ],
                    "text": "info~ stem_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-112",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2873.3876720666885, 760.5633902549744, 138.34445520639417, 22.0 ],
                    "text": "prepend vocals"
                }
            },
            {
                "box": {
                    "id": "obj-113",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2873.3876720666885, 787.3239539861679, 138.0, 22.0 ],
                    "text": "prepend setStemDurMs"
                }
            },
            {
                "box": {
                    "id": "obj-131",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2667.7538665533066, 977.4648015499115, 100.0, 20.0 ],
                    "text": "Analyze"
                }
            },
            {
                "box": {
                    "id": "obj-132",
                    "linecount": 4,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2662.120063662529, 1002.8169145584106, 383.5454465150833, 62.0 ],
                    "text": "fluid.bufampslice~ @source stem_vocals.mono @indices stem_vocals.slices @highpassfreq 150 @floor -55 @fastrampup 3 @fastrampdown 383 @slowrampup 2205 @slowrampdown 2205 @minslicelength 11025 @onthreshold 20 @offthreshold 8"
                }
            },
            {
                "box": {
                    "id": "obj-133",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2662.120063662529, 1318.3098764419556, 478.0, 22.0 ],
                    "text": "fluid.bufspectralshape~ @source stem_vocals @features stem_vocals_spectral.features"
                }
            },
            {
                "box": {
                    "id": "obj-134",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2662.120063662529, 1798.591572880745, 432.0, 22.0 ],
                    "text": "fluid.bufloudness~ @source stem_vocals @features stem_vocals_loud.features"
                }
            },
            {
                "box": {
                    "id": "obj-135",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2657.894711494446, 2339.4366503953934, 445.0, 22.0 ],
                    "text": "fluid.bufpitch~ @source stem_vocals.mono @features stem_vocals_pitch.features"
                }
            },
            {
                "box": {
                    "id": "obj-136",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2631.1341477632523, 3356.338072180748, 86.0, 22.0 ],
                    "text": "readVocals"
                }
            },
            {
                "box": {
                    "id": "obj-210",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                    "patching_rect": [ 4379.021494626999, 787.3239539861679, 124.0, 22.0 ],
                    "text": "info~ stem_melo"
                }
            },
            {
                "box": {
                    "id": "obj-212",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4573.387694358826, 760.5633902549744, 103.49650454521179, 22.0 ],
                    "text": "prepend melody"
                }
            },
            {
                "box": {
                    "id": "obj-213",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4573.387694358826, 787.3239539861679, 146.8531483411789, 22.0 ],
                    "text": "prepend setStemDurMs"
                }
            },
            {
                "box": {
                    "id": "obj-231",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 4394.514452576637, 971.8309986591339, 100.0, 20.0 ],
                    "text": "Analyze"
                }
            },
            {
                "box": {
                    "id": "obj-232",
                    "linecount": 4,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 4394.514452576637, 998.5915623903275, 409.52380561828613, 62.0 ],
                    "text": "fluid.bufampslice~ @source stem_melo.mono @indices stem_melo.slices @highpassfreq 150 @floor -55 @fastrampup 3 @fastrampdown 383 @slowrampup 2205 @slowrampdown 2205 @minslicelength 8820 @onthreshold 16 @offthreshold 7"
                }
            },
            {
                "box": {
                    "id": "obj-233",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 4394.514452576637, 1318.3098764419556, 495.0, 22.0 ],
                    "text": "fluid.bufspectralshape~ @source stem_melo.mono @features stem_melo_spectral.features"
                }
            },
            {
                "box": {
                    "id": "obj-234",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 4383.246846795082, 1792.9577699899673, 486.0, 22.0 ],
                    "text": "fluid.bufloudness~ @source stem_melo.mono @features stem_melo_loud.features"
                }
            },
            {
                "box": {
                    "id": "obj-236",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4357.894733786583, 3356.338072180748, 71.6, 22.0 ],
                    "text": "readMelo"
                }
            },
            {
                "box": {
                    "id": "obj-310",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                    "patching_rect": [ 3757.89472591877, 787.3239539861679, 124.0, 22.0 ],
                    "text": "info~ stem_bass"
                }
            },
            {
                "box": {
                    "id": "obj-312",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3957.894728541374, 760.5633902549744, 88.11188900470734, 22.0 ],
                    "text": "prepend bass"
                }
            },
            {
                "box": {
                    "id": "obj-313",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3957.894728541374, 787.3239539861679, 143.35664480924606, 22.0 ],
                    "text": "prepend setStemDurMs"
                }
            },
            {
                "box": {
                    "id": "obj-331",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3815.64120554924, 971.8309986591339, 100.0, 20.0 ],
                    "text": "Analyze"
                }
            },
            {
                "box": {
                    "id": "obj-332",
                    "linecount": 4,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3815.64120554924, 998.5915623903275, 422.6190435886383, 62.0 ],
                    "text": "fluid.bufampslice~ @source stem_bass.mono @indices stem_bass.slices @highpassfreq 40 @floor -55 @fastrampup 3 @fastrampdown 383 @slowrampup 2205 @slowrampdown 2205 @minslicelength 8820 @onthreshold 10 @offthreshold 5"
                }
            },
            {
                "box": {
                    "id": "obj-333",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3815.64120554924, 1329.5774822235107, 494.0, 22.0 ],
                    "text": "fluid.bufspectralshape~ @source stem_bass.mono @features stem_bass_spectral.features"
                }
            },
            {
                "box": {
                    "id": "obj-334",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3810.0074026584625, 1792.9577699899673, 448.0, 22.0 ],
                    "text": "fluid.bufloudness~ @source stem_bass.mono @features stem_bass_loud.features"
                }
            },
            {
                "box": {
                    "id": "obj-336",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3798.7397968769073, 3356.338072180748, 71.6, 22.0 ],
                    "text": "readBass"
                }
            },
            {
                "box": {
                    "id": "obj-410",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                    "patching_rect": [ 3173.387676000595, 787.3239539861679, 113.5, 22.0 ],
                    "text": "info~ stem_drums"
                }
            },
            {
                "box": {
                    "id": "obj-412",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3362.1200728416443, 760.5633902549744, 96.50349748134613, 22.0 ],
                    "text": "prepend drums"
                }
            },
            {
                "box": {
                    "id": "obj-413",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3362.1200728416443, 787.3239539861679, 141.95804339647293, 22.0 ],
                    "text": "prepend setStemDurMs"
                }
            },
            {
                "box": {
                    "id": "obj-431",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3204.373591899872, 971.8309986591339, 100.0, 20.0 ],
                    "text": "Analyze"
                }
            },
            {
                "box": {
                    "id": "obj-432",
                    "linecount": 4,
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3204.373591899872, 1002.8169145584106, 389.2857105731964, 62.0 ],
                    "text": "fluid.bufampslice~ @source stem_drums.mono @indices stem_drums.slices @highpassfreq 200 @floor -55 @fastrampup 3 @fastrampdown 383 @slowrampup 2205 @slowrampdown 2205 @minslicelength 4410 @onthreshold 14 @offthreshold 7"
                }
            },
            {
                "box": {
                    "id": "obj-433",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3204.373591899872, 1318.3098764419556, 510.0, 22.0 ],
                    "text": "fluid.bufspectralshape~ @source stem_drums.mono @features stem_drums_spectral.features"
                }
            },
            {
                "box": {
                    "id": "obj-434",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3210.0073947906494, 1798.591572880745, 464.0, 22.0 ],
                    "text": "fluid.bufloudness~ @source stem_drums.mono @features stem_drums_loud.features"
                }
            },
            {
                "box": {
                    "id": "obj-436",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3183.246831059456, 3356.338072180748, 68.0, 22.0 ],
                    "text": "readDrums"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-3",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 37.722413778305054, 710.7712438106537, 157.0, 20.0 ],
                    "text": "== ANALYSIS ENGINE =="
                }
            },
            {
                "box": {
                    "id": "obj-500",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 9,
                    "outlettype": [ "", "", "", "", "", "", "", "", "" ],
                    "patching_rect": [ 39.85007333755493, 744.8137967586517, 158.92856991291046, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "analyze_reader.js",
                        "parameter_enable": 0
                    },
                    "text": "js analyze_reader.js"
                }
            },
            {
                "box": {
                    "id": "obj-501",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 4,
                    "outlettype": [ "", "", "", "" ],
                    "patching_rect": [ 39.85007333755493, 804.3882644176483, 109.68053948879242, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "slice_writer.js",
                        "parameter_enable": 0
                    },
                    "text": "js slice_writer.js"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-540",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 39.85007333755493, 1255.4520909786224, 143.0, 20.0 ],
                    "text": "== SLICER ENGINE =="
                }
            },
            {
                "box": {
                    "id": "obj-544",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5593.334489822388, 868.6747308969498, 60.0, 22.0 ],
                    "text": "start"
                }
            },
            {
                "box": {
                    "id": "obj-546",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5666.828468441963, 868.6747308969498, 60.0, 22.0 ],
                    "text": "stop"
                }
            },
            {
                "box": {
                    "id": "obj-551",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 6,
                    "outlettype": [ "", "", "", "", "", "" ],
                    "patching_rect": [ 44.10539245605469, 1298.00528216362, 102.4, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "slicer.js",
                        "parameter_enable": 0
                    },
                    "text": "js slicer.js"
                }
            },
            {
                "box": {
                    "id": "obj-552",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 58.99900937080383, 1357.5797498226166, 102.4, 22.0 ],
                    "text": "print slicer"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-590",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 37.96296536922455, 1644.444416999817, 109.0, 20.0 ],
                    "text": "== PLAYBACK =="
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-700",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 62.22222447395325, 1924.4185358285904, 100.0, 20.0 ],
                    "text": "— vocals —"
                }
            },
            {
                "box": {
                    "id": "obj-709",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 43.33333230018616, 2157.4999485611916, 76.11463540792465, 22.0 ],
                    "text": "next vocals"
                }
            },
            {
                "box": {
                    "id": "obj-710",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "list" ],
                    "patching_rect": [ 146.29629385471344, 2053.7036694288254, 119.0, 22.0 ],
                    "text": "karma~ ring_0_voc"
                }
            },
            {
                "box": {
                    "id": "obj-711",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 146.29629385471344, 2591.0, 80.0, 22.0 ],
                    "text": "*~ 0.7"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-730",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 528.5309119224548, 1924.4185358285904, 100.0, 20.0 ],
                    "text": "— drums —"
                }
            },
            {
                "box": {
                    "id": "obj-739",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 522.2221966981888, 2157.5756521224976, 68.0, 22.0 ],
                    "text": "next drums"
                }
            },
            {
                "box": {
                    "id": "obj-740",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "list" ],
                    "patching_rect": [ 661.7284479141235, 2053.7036694288254, 118.0, 22.0 ],
                    "text": "karma~ ring_0_drm"
                }
            },
            {
                "box": {
                    "id": "obj-741",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 791.919153213501, 2591.0, 80.0, 22.0 ],
                    "text": "*~ 0.7"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-760",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1064.9815678596497, 1927.9069077968597, 100.0, 20.0 ],
                    "text": "— bass —"
                }
            },
            {
                "box": {
                    "id": "obj-770",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "list" ],
                    "patching_rect": [ 1170.370463848114, 2053.7036694288254, 113.0, 22.0 ],
                    "text": "karma~ ring_0_bss"
                }
            },
            {
                "box": {
                    "id": "obj-771",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1289.3333386182785, 2591.0, 80.0, 22.0 ],
                    "text": "*~ 0.7"
                }
            },
            {
                "box": {
                    "fontface": 1,
                    "id": "obj-790",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 1574.333295404911, 1927.9069077968597, 100.0, 20.0 ],
                    "text": "— melo —"
                }
            },
            {
                "box": {
                    "id": "obj-799",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1590.833295404911, 2157.4999485611916, 73.0, 22.0 ],
                    "text": "next melody"
                }
            },
            {
                "box": {
                    "id": "obj-800",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "signal", "list" ],
                    "patching_rect": [ 1704.93840777874, 2053.7036694288254, 114.0, 22.0 ],
                    "text": "karma~ ring_0_mel"
                }
            },
            {
                "box": {
                    "id": "obj-801",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1828.125, 2591.0, 80.0, 22.0 ],
                    "text": "*~ 0.7"
                }
            },
            {
                "box": {
                    "filename": "fluid.waveform~",
                    "id": "obj-198",
                    "maxclass": "jsui",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4398.7398047447205, 1939.4366451501846, 311.1111259460449, 89.58333760499954 ]
                }
            },
            {
                "box": {
                    "id": "obj-fluerr",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 3031.134153008461, 2998.591588616371, 120.0, 22.0 ],
                    "text": "print flucoma_error"
                }
            },
            {
                "box": {
                    "id": "obj-4003",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 895.0, 455.0, 799.0, 511.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 133.0, 178.0, 387.0, 22.0 ],
                                    "text": "fluid.bufselect~ @source stem_drums @destination stem_drums.mono"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 133.0, 95.0, 45.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 10,
                                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                                    "patching_rect": [ 12.0, 57.0, 113.5, 22.0 ],
                                    "text": "info~ stem_drums"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 582.0, 229.0, 82.0, 22.0 ],
                                    "text": "clear, size 1 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "bang" ],
                                    "patching_rect": [ 338.0, 178.0, 263.0, 22.0 ],
                                    "text": "t b b"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.423529411764706, 0.513725490196078, 1.0, 1.0 ],
                                    "id": "obj-14",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 582.0, 268.0, 149.0, 22.0 ],
                                    "text": "buffer~ stem_drums.mono"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 338.0, 229.0, 201.0, 22.0 ],
                                    "text": "startchan 0, bang, startchan 1, bang"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "linecount": 3,
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 338.0, 268.0, 231.0, 49.0 ],
                                    "text": "fluid.bufcompose~ @source stem_drums @destination stem_drums.mono @destgain 0.5 @numchans 1"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-2",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 133.0, 371.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-1",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 12.0, 9.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 0 ],
                                    "midpoints": [ 142.5, 120.0, 142.5, 120.0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "midpoints": [ 168.5, 165.0, 347.5, 165.0 ],
                                    "source": [ "obj-13", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-7", 0 ],
                                    "source": [ "obj-4", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 0 ],
                                    "source": [ "obj-7", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-8", 8 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 3215.641197681427, 871.8309973478317, 143.0, 22.0 ],
                    "text": "p stereo_to_mono.drums"
                }
            },
            {
                "box": {
                    "color": [ 0.431372549019608, 0.431372549019608, 0.431372549019608, 1.0 ],
                    "id": "obj-4004",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3173.387676000595, 535.2112746238708, 149.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "saved_newobj_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "text": "buffer~ stem_drums.mono"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-4005",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3362.1200728416443, 639.4366281032562, 209.0, 22.0 ],
                    "text": "buffer~ stem_drums_chroma.features"
                }
            },
            {
                "box": {
                    "id": "obj-4006",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3198.7397890090942, 2618.309893488884, 475.0, 22.0 ],
                    "text": "fluid.bufchroma~ @source stem_drums.mono @features stem_drums_chroma.features"
                }
            },
            {
                "box": {
                    "id": "obj-4007",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3198.7397890090942, 2692.957781791687, 236.0, 22.0 ],
                    "text": "features stem_drums_chroma.features red"
                }
            },
            {
                "box": {
                    "id": "obj-4008",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3452.2609190940857, 2692.957781791687, 253.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_drums.mono"
                }
            },
            {
                "box": {
                    "id": "obj-4009",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3162.12007021904, 2550.704258799553, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-4010",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 895.0, 455.0, 799.0, 511.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 133.0, 178.0, 387.0, 22.0 ],
                                    "text": "fluid.bufselect~ @source stem_bass @destination stem_bass.mono"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 133.0, 95.0, 45.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 10,
                                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                                    "patching_rect": [ 12.0, 57.0, 113.5, 22.0 ],
                                    "text": "info~ stem_bass"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 582.0, 229.0, 82.0, 22.0 ],
                                    "text": "clear, size 1 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "bang" ],
                                    "patching_rect": [ 338.0, 178.0, 263.0, 22.0 ],
                                    "text": "t b b"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.423529411764706, 0.513725490196078, 1.0, 1.0 ],
                                    "id": "obj-14",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 582.0, 268.0, 149.0, 22.0 ],
                                    "text": "buffer~ stem_bass.mono"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 338.0, 229.0, 201.0, 22.0 ],
                                    "text": "startchan 0, bang, startchan 1, bang"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "linecount": 3,
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 338.0, 268.0, 231.0, 49.0 ],
                                    "text": "fluid.bufcompose~ @source stem_bass @destination stem_bass.mono @destgain 0.5 @numchans 1"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-2",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 133.0, 371.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-1",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 12.0, 9.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 0 ],
                                    "midpoints": [ 142.5, 120.0, 142.5, 120.0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "midpoints": [ 168.5, 165.0, 347.5, 165.0 ],
                                    "source": [ "obj-13", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-7", 0 ],
                                    "source": [ "obj-4", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 0 ],
                                    "source": [ "obj-7", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-8", 8 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 3840.9933185577393, 871.8309973478317, 143.0, 22.0 ],
                    "text": "p stereo_to_mono.bass"
                }
            },
            {
                "box": {
                    "color": [ 0.431372549019608, 0.431372549019608, 0.431372549019608, 1.0 ],
                    "id": "obj-4011",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3762.120078086853, 535.2112746238708, 149.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "saved_newobj_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "text": "buffer~ stem_bass.mono"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-4012",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3957.894728541374, 639.4366281032562, 201.0, 22.0 ],
                    "text": "buffer~ stem_bass_chroma.features"
                }
            },
            {
                "box": {
                    "id": "obj-4013",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3810.0074026584625, 2618.309893488884, 475.0, 22.0 ],
                    "text": "fluid.bufchroma~ @source stem_bass.mono @features stem_bass_chroma.features"
                }
            },
            {
                "box": {
                    "id": "obj-4014",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3810.0074026584625, 2692.957781791687, 236.0, 22.0 ],
                    "text": "features stem_bass_chroma.features red"
                }
            },
            {
                "box": {
                    "id": "obj-4015",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4062.1200820207596, 2692.957781791687, 253.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_bass.mono"
                }
            },
            {
                "box": {
                    "id": "obj-4016",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 3762.120078086853, 2550.704258799553, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-4017",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patcher": {
                        "fileversion": 1,
                        "appversion": {
                            "major": 9,
                            "minor": 1,
                            "revision": 4,
                            "architecture": "x64",
                            "modernui": 1
                        },
                        "classnamespace": "box",
                        "rect": [ 895.0, 455.0, 799.0, 511.0 ],
                        "boxes": [
                            {
                                "box": {
                                    "id": "obj-16",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 133.0, 178.0, 387.0, 22.0 ],
                                    "text": "fluid.bufselect~ @source stem_melo @destination stem_melo.mono"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-13",
                                    "maxclass": "newobj",
                                    "numinlets": 2,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "" ],
                                    "patching_rect": [ 133.0, 95.0, 45.0, 22.0 ],
                                    "text": "sel 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-8",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 10,
                                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                                    "patching_rect": [ 12.0, 57.0, 113.5, 22.0 ],
                                    "text": "info~ stem_melo"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-7",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 582.0, 229.0, 82.0, 22.0 ],
                                    "text": "clear, size 1 1"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-4",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "bang", "bang" ],
                                    "patching_rect": [ 338.0, 178.0, 263.0, 22.0 ],
                                    "text": "t b b"
                                }
                            },
                            {
                                "box": {
                                    "color": [ 0.423529411764706, 0.513725490196078, 1.0, 1.0 ],
                                    "id": "obj-14",
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "float", "bang" ],
                                    "patching_rect": [ 582.0, 268.0, 149.0, 22.0 ],
                                    "text": "buffer~ stem_melo.mono"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-5",
                                    "maxclass": "message",
                                    "numinlets": 2,
                                    "numoutlets": 1,
                                    "outlettype": [ "" ],
                                    "patching_rect": [ 338.0, 229.0, 201.0, 22.0 ],
                                    "text": "startchan 0, bang, startchan 1, bang"
                                }
                            },
                            {
                                "box": {
                                    "id": "obj-3",
                                    "linecount": 3,
                                    "maxclass": "newobj",
                                    "numinlets": 1,
                                    "numoutlets": 2,
                                    "outlettype": [ "", "" ],
                                    "patching_rect": [ 338.0, 268.0, 231.0, 49.0 ],
                                    "text": "fluid.bufcompose~ @source stem_melo @destination stem_melo.mono @destgain 0.5 @numchans 1"
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-2",
                                    "index": 1,
                                    "maxclass": "outlet",
                                    "numinlets": 1,
                                    "numoutlets": 0,
                                    "patching_rect": [ 133.0, 371.0, 30.0, 30.0 ]
                                }
                            },
                            {
                                "box": {
                                    "comment": "",
                                    "id": "obj-1",
                                    "index": 1,
                                    "maxclass": "inlet",
                                    "numinlets": 0,
                                    "numoutlets": 1,
                                    "outlettype": [ "bang" ],
                                    "patching_rect": [ 12.0, 9.0, 30.0, 30.0 ]
                                }
                            }
                        ],
                        "lines": [
                            {
                                "patchline": {
                                    "destination": [ "obj-8", 0 ],
                                    "source": [ "obj-1", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-16", 0 ],
                                    "midpoints": [ 142.5, 120.0, 142.5, 120.0 ],
                                    "source": [ "obj-13", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-4", 0 ],
                                    "midpoints": [ 168.5, 165.0, 347.5, 165.0 ],
                                    "source": [ "obj-13", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-16", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-2", 0 ],
                                    "source": [ "obj-3", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-5", 0 ],
                                    "source": [ "obj-4", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-7", 0 ],
                                    "source": [ "obj-4", 1 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-3", 0 ],
                                    "source": [ "obj-5", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-14", 0 ],
                                    "source": [ "obj-7", 0 ]
                                }
                            },
                            {
                                "patchline": {
                                    "destination": [ "obj-13", 0 ],
                                    "source": [ "obj-8", 8 ]
                                }
                            }
                        ]
                    },
                    "patching_rect": [ 4431.134171366692, 871.8309973478317, 143.0, 22.0 ],
                    "text": "p stereo_to_mono.melo"
                }
            },
            {
                "box": {
                    "color": [ 0.431372549019608, 0.431372549019608, 0.431372549019608, 1.0 ],
                    "id": "obj-4018",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4379.021494626999, 535.2112746238708, 149.0, 22.0 ],
                    "saved_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "saved_newobj_attribute_attributes": {
                        "color": {
                            "expression": "themecolor.live_surface_frame_focus"
                        }
                    },
                    "text": "buffer~ stem_melo.mono"
                }
            },
            {
                "box": {
                    "color": [ 1.0, 0.0, 0.0, 1.0 ],
                    "id": "obj-4019",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4573.387694358826, 639.4366281032562, 201.0, 22.0 ],
                    "text": "buffer~ stem_melo_chroma.features"
                }
            },
            {
                "box": {
                    "id": "obj-4020",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 4383.246846795082, 2618.309893488884, 475.0, 22.0 ],
                    "text": "fluid.bufchroma~ @source stem_melo.mono @features stem_melo_chroma.features"
                }
            },
            {
                "box": {
                    "id": "obj-4021",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4383.246846795082, 2692.957781791687, 236.0, 22.0 ],
                    "text": "features stem_melo_chroma.features red"
                }
            },
            {
                "box": {
                    "id": "obj-4022",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4636.767976880074, 2692.957781791687, 253.0, 22.0 ],
                    "text": "clear, addlayer audiobuffer stem_melo.mono"
                }
            },
            {
                "box": {
                    "id": "obj-4023",
                    "maxclass": "button",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "parameter_enable": 0,
                    "patching_rect": [ 4340.99332511425, 2550.704258799553, 24.0, 24.0 ]
                }
            },
            {
                "box": {
                    "id": "obj-4030",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 5598.153767108917, 827.7108739614487, 209.0, 22.0 ],
                    "saved_object_attributes": {
                        "autostart": 0,
                        "defer": 0,
                        "node_bin_path": "",
                        "npm_bin_path": "",
                        "watch": 0
                    },
                    "text": "node.script ws_server.js @autostart 1",
                    "textfile": {
                        "filename": "ws_server.js",
                        "flags": 0,
                        "embed": 0,
                        "autowatch": 1
                    }
                }
            },
            {
                "box": {
                    "id": "obj-4031",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5793.334497213364, 868.6747308969498, 80.0, 22.0 ],
                    "text": "print ws"
                }
            },
            {
                "box": {
                    "id": "obj-4032",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5593.334489822388, 901.2048525810242, 56.59332287311554, 22.0 ],
                    "text": "state 1"
                }
            },
            {
                "box": {
                    "id": "obj-4033",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5666.828468441963, 901.2048525810242, 56.59332287311554, 22.0 ],
                    "text": "state 0"
                }
            },
            {
                "box": {
                    "id": "obj-4038",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 5598.153767108917, 740.9638828039169, 75.0, 22.0 ],
                    "text": "delay 500"
                }
            },
            {
                "box": {
                    "id": "obj-4039",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5598.153767108917, 780.7229204177856, 64.0, 22.0 ],
                    "text": "script start"
                }
            },
            {
                "box": {
                    "id": "obj-4041",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 25,
                    "numoutlets": 25,
                    "outlettype": [ "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" ],
                    "patching_rect": [ 5593.334489822388, 944.57834815979, 800.0, 35.0 ],
                    "text": "route buildIndex start stop selectSegment setSegmentBars setStayProb setQuantize setFallbackBPM setWeight setMatchProb setDirPref setDirWeight setTrackWeight nextNearest reset info loop unloop unloopAll setGlobalBPM setMaxSlices resetMemory pitchShift followStem"
                }
            },
            {
                "box": {
                    "id": "obj-4042",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5593.334489822388, 1007.2289528846741, 130.0, 22.0 ],
                    "text": "prepend buildIndex"
                }
            },
            {
                "box": {
                    "id": "obj-4043",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5630.683888792992, 1044.578351855278, 95.0, 22.0 ],
                    "text": "prepend start"
                }
            },
            {
                "box": {
                    "id": "obj-4044",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5672.852565050125, 1080.7229315042496, 88.0, 22.0 ],
                    "text": "prepend stop"
                }
            },
            {
                "box": {
                    "id": "obj-4045",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5713.816421985626, 1122.891607761383, 151.0, 22.0 ],
                    "text": "prepend selectSegment"
                }
            },
            {
                "box": {
                    "id": "obj-4046",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5755.98509824276, 1007.2289528846741, 158.0, 22.0 ],
                    "text": "prepend setSegmentBars"
                }
            },
            {
                "box": {
                    "id": "obj-4047",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5798.153774499893, 1038.554255247116, 137.0, 22.0 ],
                    "text": "prepend setStayProb"
                }
            },
            {
                "box": {
                    "id": "obj-4048",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5830.683896183968, 1075.90365421772, 137.0, 22.0 ],
                    "text": "prepend setQuantize"
                }
            },
            {
                "box": {
                    "id": "obj-4049",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5877.671849727631, 1118.0723304748535, 158.0, 22.0 ],
                    "text": "prepend setFallbackBPM"
                }
            },
            {
                "box": {
                    "id": "obj-4050",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5940.322454452515, 1007.2289528846741, 123.0, 22.0 ],
                    "text": "prepend setWeight"
                }
            },
            {
                "box": {
                    "id": "obj-4051",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5982.491130709648, 1038.554255247116, 144.0, 22.0 ],
                    "text": "prepend setMatchProb"
                }
            },
            {
                "box": {
                    "id": "obj-4052",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6140.322461843491, 1007.2289528846741, 130.0, 22.0 ],
                    "text": "prepend setDirPref"
                }
            },
            {
                "box": {
                    "id": "obj-4053",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6035.503180861473, 1075.90365421772, 144.0, 22.0 ],
                    "text": "prepend setDirWeight"
                }
            },
            {
                "box": {
                    "id": "obj-4054",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6072.852579832077, 1118.0723304748535, 158.0, 22.0 ],
                    "text": "prepend setTrackWeight"
                }
            },
            {
                "box": {
                    "id": "obj-4055",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6177.6718608140945, 1038.554255247116, 137.0, 22.0 ],
                    "text": "prepend nextNearest"
                }
            },
            {
                "box": {
                    "id": "obj-4056",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6224.659814357758, 1075.90365421772, 95.0, 22.0 ],
                    "text": "prepend reset"
                }
            },
            {
                "box": {
                    "id": "obj-4057",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6266.828490614891, 1118.0723304748535, 88.0, 22.0 ],
                    "text": "prepend info"
                }
            },
            {
                "box": {
                    "id": "obj-4058",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6298.153792977333, 1007.2289528846741, 88.0, 22.0 ],
                    "text": "prepend loop"
                }
            },
            {
                "box": {
                    "id": "obj-4059",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6346.3465658426285, 1038.554255247116, 102.0, 22.0 ],
                    "text": "prepend unloop"
                }
            },
            {
                "box": {
                    "id": "obj-4060",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6377.6718682050705, 1075.90365421772, 123.0, 22.0 ],
                    "text": "prepend unloopAll"
                }
            },
            {
                "box": {
                    "id": "obj-4061",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6519.840548157692, 1038.554255247116, 158.0, 22.0 ],
                    "text": "prepend setGlobalBPM"
                }
            },
            {
                "box": {
                    "id": "obj-4064",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "" ],
                    "patching_rect": [ 3330.985959172249, 112.67605781555176, 150.0, 22.0 ],
                    "text": "select need_stemDurs"
                }
            },
            {
                "box": {
                    "id": "obj-4065",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 4,
                    "outlettype": [ "bang", "bang", "bang", "bang" ],
                    "patching_rect": [ 3330.985959172249, 143.6619737148285, 80.0, 22.0 ],
                    "text": "t b b b b"
                }
            },
            {
                "box": {
                    "id": "obj-4066",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6404.177893280983, 1122.891607761383, 140.0, 22.0 ],
                    "text": "prepend setMaxSlices"
                }
            },
            {
                "box": {
                    "id": "obj-5000",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1105.0, 3329.0, 35.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-5001",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1105.0, 3374.0, 35.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-5002",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1105.0, 3419.0, 35.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-5003",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 1105.0, 3468.0, 98.33333098888397, 22.0 ],
                    "text": "fluid.loudness~"
                }
            },
            {
                "box": {
                    "id": "obj-5004",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 1182.0, 3525.0, 65.0, 22.0 ],
                    "text": "metro 100"
                }
            },
            {
                "box": {
                    "id": "obj-5005",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 1182.0, 3572.0, 80.0, 22.0 ],
                    "text": "snapshot~"
                }
            },
            {
                "box": {
                    "id": "obj-5006",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 1282.0, 3572.0, 80.0, 22.0 ],
                    "text": "snapshot~"
                }
            },
            {
                "box": {
                    "id": "obj-5007",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1182.0, 3624.0, 70.0, 22.0 ],
                    "text": "pak 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-5008",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1182.0, 3667.0, 95.0, 22.0 ],
                    "text": "prepend lufs"
                }
            },
            {
                "box": {
                    "id": "obj-9902",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 212.19049763679504, 834.1754982471466, 174.0, 22.0 ],
                    "text": "read analysis_library.json"
                }
            },
            {
                "box": {
                    "id": "obj-9903",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 5,
                    "outlettype": [ "dictionary", "", "", "", "" ],
                    "patching_rect": [ 39.85007333755493, 889.4946467876434, 98.0, 22.0 ],
                    "saved_object_attributes": {
                        "legacy": 0,
                        "parameter_enable": 0,
                        "parameter_mappable": 0
                    },
                    "text": "dict analysisLib"
                }
            },
            {
                "box": {
                    "id": "obj-9910",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 892.1449243426323, 116.78946340084076, 90.0, 22.0 ],
                    "text": "wipe memory"
                }
            },
            {
                "box": {
                    "id": "obj-9911",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "bang" ],
                    "patching_rect": [ 407.9351770877838, 821.4095408916473, 36.0, 22.0 ],
                    "text": "t b b"
                }
            },
            {
                "box": {
                    "id": "obj-9912",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 422.82879400253296, 855.4520938396454, 38.0, 22.0 ],
                    "text": "clear"
                }
            },
            {
                "box": {
                    "id": "obj-9913",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 407.9351770877838, 893.7499659061432, 184.0, 22.0 ],
                    "text": "export analysis_library.json"
                }
            },
            {
                "box": {
                    "id": "obj-4067",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6482.491149187088, 1007.2289528846741, 130.0, 22.0 ],
                    "text": "prepend resetMemory"
                }
            },
            {
                "box": {
                    "id": "obj-9920",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 300.7518529891968, 286.7469985485077, 80.0, 22.0 ],
                    "text": "startStem $1"
                }
            },
            {
                "box": {
                    "id": "obj-9921",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 171.42855620384216, 286.46613997220993, 110.0, 22.0 ],
                    "text": "startAnalysis"
                }
            },
            {
                "box": {
                    "id": "obj-5011",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 1182.0, 3329.0, 95.0, 22.0 ],
                    "text": "route ws_ready"
                }
            },
            {
                "box": {
                    "id": "obj-6001",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "" ],
                    "patching_rect": [ 39.85007333755493, 774.60103058815, 100.0, 22.0 ],
                    "text": "sel all_done"
                }
            },
            {
                "box": {
                    "id": "obj-6002",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 39.85007333755493, 834.1754982471466, 140.0, 22.0 ],
                    "text": "prepend analysisDone"
                }
            },
            {
                "box": {
                    "id": "obj-9922",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 230.0, 152.0, 150.0, 22.0 ],
                    "text": "prepend streamUpdated"
                }
            },
            {
                "box": {
                    "id": "obj-9960",
                    "maxclass": "comment",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 2657.746513724327, 85.91549408435822, 200.0, 20.0 ],
                    "text": "── track loader ──"
                }
            },
            {
                "box": {
                    "id": "obj-9961",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 18,
                    "outlettype": [ "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" ],
                    "patching_rect": [ 2657.746513724327, 226.7605663537979, 130.0, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "buffer_manager.js",
                        "parameter_enable": 0
                    },
                    "text": "js buffer_manager.js"
                }
            },
            {
                "box": {
                    "id": "obj-9970",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2657.894711494446, 571.8309934139252, 152.0, 22.0 ],
                    "text": "buffer~ src_0_voc"
                }
            },
            {
                "box": {
                    "id": "obj-9971",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3173.387676000595, 571.8309934139252, 138.0, 22.0 ],
                    "text": "buffer~ src_0_drm"
                }
            },
            {
                "box": {
                    "id": "obj-9972",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3762.120078086853, 571.8309934139252, 138.0, 22.0 ],
                    "text": "buffer~ src_0_bss"
                }
            },
            {
                "box": {
                    "id": "obj-9973",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4379.021494626999, 571.8309934139252, 138.0, 22.0 ],
                    "text": "buffer~ src_0_mel"
                }
            },
            {
                "box": {
                    "id": "obj-9974",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                    "patching_rect": [ 2657.894711494446, 760.5633902549744, 138.0, 22.0 ],
                    "text": "info~ src_0_voc"
                }
            },
            {
                "box": {
                    "id": "obj-9975",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                    "patching_rect": [ 3167.7538731098175, 760.5633902549744, 114.0, 22.0 ],
                    "text": "info~ src_0_drm"
                }
            },
            {
                "box": {
                    "id": "obj-9976",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                    "patching_rect": [ 3757.89472591877, 760.5633902549744, 124.0, 22.0 ],
                    "text": "info~ src_0_bss"
                }
            },
            {
                "box": {
                    "id": "obj-9977",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 10,
                    "outlettype": [ "float", "list", "float", "float", "float", "float", "float", "", "int", "" ],
                    "patching_rect": [ 4379.021494626999, 760.5633902549744, 124.0, 22.0 ],
                    "text": "info~ src_0_mel"
                }
            },
            {
                "box": {
                    "id": "obj-9978",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2657.894711494446, 598.5915571451187, 150.0, 22.0 ],
                    "text": "buffer~ src_1_voc"
                }
            },
            {
                "box": {
                    "id": "obj-9979",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3167.7538731098175, 598.5915571451187, 150.0, 22.0 ],
                    "text": "buffer~ src_1_drm"
                }
            },
            {
                "box": {
                    "id": "obj-9980",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3762.120078086853, 598.5915571451187, 150.0, 22.0 ],
                    "text": "buffer~ src_1_bss"
                }
            },
            {
                "box": {
                    "id": "obj-9981",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4379.021494626999, 598.5915571451187, 150.0, 22.0 ],
                    "text": "buffer~ src_1_mel"
                }
            },
            {
                "box": {
                    "id": "obj-9982",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 20,
                    "outlettype": [ "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" ],
                    "patching_rect": [ 47.22222447395325, 1692.5925643444061, 130.0, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "slot_router.js",
                        "parameter_enable": 0
                    },
                    "text": "js slot_router.js"
                }
            },
            {
                "box": {
                    "id": "obj-9983",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2657.894711494446, 639.4366281032562, 150.0, 22.0 ],
                    "text": "buffer~ ring_0_voc"
                }
            },
            {
                "box": {
                    "id": "obj-9984",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2657.894711494446, 660.5633889436722, 150.0, 22.0 ],
                    "text": "buffer~ ring_1_voc"
                }
            },
            {
                "box": {
                    "id": "obj-9985",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3167.7538731098175, 639.4366281032562, 150.0, 22.0 ],
                    "text": "buffer~ ring_0_drm"
                }
            },
            {
                "box": {
                    "id": "obj-9986",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3167.7538731098175, 660.5633889436722, 150.0, 22.0 ],
                    "text": "buffer~ ring_1_drm"
                }
            },
            {
                "box": {
                    "id": "obj-9987",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3762.120078086853, 639.4366281032562, 150.0, 22.0 ],
                    "text": "buffer~ ring_0_bss"
                }
            },
            {
                "box": {
                    "id": "obj-9988",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3762.120078086853, 666.1971918344498, 150.0, 22.0 ],
                    "text": "buffer~ ring_1_bss"
                }
            },
            {
                "box": {
                    "id": "obj-9989",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4379.021494626999, 639.4366281032562, 150.0, 22.0 ],
                    "text": "buffer~ ring_0_mel"
                }
            },
            {
                "box": {
                    "id": "obj-9990",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4379.021494626999, 666.1971918344498, 150.0, 22.0 ],
                    "text": "buffer~ ring_1_mel"
                }
            },
            {
                "box": {
                    "id": "obj-9992",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2867.753869175911, 839.4366307258606, 130.0, 22.0 ],
                    "text": "fluid.bufcompose~"
                }
            },
            {
                "box": {
                    "id": "obj-9993",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 3394.5144394636154, 839.4366307258606, 130.0, 22.0 ],
                    "text": "fluid.bufcompose~"
                }
            },
            {
                "box": {
                    "id": "obj-9994",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 4019.8665603399277, 845.0704336166382, 130.0, 22.0 ],
                    "text": "fluid.bufcompose~"
                }
            },
            {
                "box": {
                    "id": "obj-9995",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 4610.00741314888, 845.0704336166382, 130.0, 22.0 ],
                    "text": "fluid.bufcompose~"
                }
            },
            {
                "box": {
                    "id": "obj-9997",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2657.746513724327, 118.30986070632935, 140.0, 22.0 ],
                    "text": "prepend src_done voc 0"
                }
            },
            {
                "box": {
                    "id": "obj-9998",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2657.746513724327, 143.6619737148285, 140.0, 22.0 ],
                    "text": "prepend src_done voc 1"
                }
            },
            {
                "box": {
                    "id": "obj-9999",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2830.985952615738, 118.30986070632935, 140.0, 22.0 ],
                    "text": "prepend src_done drm 0"
                }
            },
            {
                "box": {
                    "id": "obj-10000",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2830.985952615738, 143.6619737148285, 140.0, 22.0 ],
                    "text": "prepend src_done drm 1"
                }
            },
            {
                "box": {
                    "id": "obj-10001",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2990.140884280205, 118.30986070632935, 140.0, 22.0 ],
                    "text": "prepend src_done bss 0"
                }
            },
            {
                "box": {
                    "id": "obj-10002",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2990.140884280205, 143.6619737148285, 140.0, 22.0 ],
                    "text": "prepend src_done bss 1"
                }
            },
            {
                "box": {
                    "id": "obj-10003",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3157.746520280838, 118.30986070632935, 140.0, 22.0 ],
                    "text": "prepend src_done mel 0"
                }
            },
            {
                "box": {
                    "id": "obj-10004",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3157.746520280838, 143.6619737148285, 140.0, 22.0 ],
                    "text": "prepend src_done mel 1"
                }
            },
            {
                "box": {
                    "id": "obj-10005",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2867.753869175911, 871.8309973478317, 131.0, 22.0 ],
                    "text": "prepend ring_done voc"
                }
            },
            {
                "box": {
                    "id": "obj-10006",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 3394.5144394636154, 871.8309973478317, 133.0, 22.0 ],
                    "text": "prepend ring_done drm"
                }
            },
            {
                "box": {
                    "id": "obj-10007",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4019.8665603399277, 871.8309973478317, 131.0, 22.0 ],
                    "text": "prepend ring_done bss"
                }
            },
            {
                "box": {
                    "id": "obj-10008",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 4610.00741314888, 871.8309973478317, 132.0, 22.0 ],
                    "text": "prepend ring_done mel"
                }
            },
            {
                "box": {
                    "id": "obj-4068",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6555.9851278066635, 1075.90365421772, 120.0, 22.0 ],
                    "text": "prepend pitchShift"
                }
            },
            {
                "box": {
                    "id": "obj-4069",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 6577.671875596046, 1122.891607761383, 120.0, 22.0 ],
                    "text": "prepend followStem"
                }
            },
            {
                "box": {
                    "id": "obj-5100",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 191.4375, 2091.1112135648727, 200.0, 22.0 ],
                    "text": "pfft~ ebys-pitch.maxpat 1024 4"
                }
            },
            {
                "box": {
                    "id": "obj-5101",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 709.9791656434536, 2090.3124485611916, 200.0, 22.0 ],
                    "text": "pfft~ ebys-pitch.maxpat 1024 4"
                }
            },
            {
                "box": {
                    "id": "obj-5102",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1229.3333386182785, 2091.1112135648727, 200.0, 22.0 ],
                    "text": "pfft~ ebys-pitch.maxpat 1024 4"
                }
            },
            {
                "box": {
                    "id": "obj-5103",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1761.0, 2091.8749485611916, 200.0, 22.0 ],
                    "text": "pfft~ ebys-pitch.maxpat 1024 4"
                }
            },
            {
                "box": {
                    "id": "obj-10009",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 2657.894711494446, 708.4507135152817, 150.0, 22.0 ],
                    "text": "buffer~ snap_voc"
                }
            },
            {
                "box": {
                    "id": "obj-10010",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3167.7538731098175, 714.0845164060593, 150.0, 22.0 ],
                    "text": "buffer~ snap_drm"
                }
            },
            {
                "box": {
                    "id": "obj-10011",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 3757.89472591877, 714.0845164060593, 150.0, 22.0 ],
                    "text": "buffer~ snap_bss"
                }
            },
            {
                "box": {
                    "id": "obj-10012",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "float", "bang" ],
                    "patching_rect": [ 4379.021494626999, 714.0845164060593, 150.0, 22.0 ],
                    "text": "buffer~ snap_mel"
                }
            },
            {
                "box": {
                    "id": "obj-10013",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2821.126797556877, 226.7605663537979, 130.0, 22.0 ],
                    "text": "fluid.bufcompose~"
                }
            },
            {
                "box": {
                    "id": "obj-10014",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2821.126797556877, 257.74648225307465, 130.0, 22.0 ],
                    "text": "fluid.bufcompose~"
                }
            },
            {
                "box": {
                    "id": "obj-10015",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2963.3803205490112, 226.7605663537979, 130.0, 22.0 ],
                    "text": "fluid.bufcompose~"
                }
            },
            {
                "box": {
                    "id": "obj-10016",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 2963.3803205490112, 257.74648225307465, 130.0, 22.0 ],
                    "text": "fluid.bufcompose~"
                }
            },
            {
                "box": {
                    "id": "obj-10017",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2821.126797556877, 290.1408488750458, 137.0, 22.0 ],
                    "text": "prepend bake_done voc"
                }
            },
            {
                "box": {
                    "id": "obj-10018",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2821.126797556877, 321.1267647743225, 139.0, 22.0 ],
                    "text": "prepend bake_done drm"
                }
            },
            {
                "box": {
                    "id": "obj-10019",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2963.3803205490112, 290.1408488750458, 137.0, 22.0 ],
                    "text": "prepend bake_done bss"
                }
            },
            {
                "box": {
                    "id": "obj-10020",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 2963.3803205490112, 321.1267647743225, 138.0, 22.0 ],
                    "text": "prepend bake_done mel"
                }
            },
            {
                "box": {
                    "id": "obj-437",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 5598.153767108917, 702.4096645116806, 58.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-9930",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 160.0, 889.0, 100.0, 22.0 ],
                    "text": "loadRegistry"
                }
            },
            {
                "box": {
                    "id": "obj-7001",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 12.121211528778076, 3387.5858557224274, 110.0, 22.0 ],
                    "text": "peakamp~ 4096"
                }
            },
            {
                "box": {
                    "id": "obj-7002",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 656.0, 2988.521738767624, 110.0, 22.0 ],
                    "text": "peakamp~ 4096"
                }
            },
            {
                "box": {
                    "id": "obj-7003",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 1163.2463810443878, 2988.521738767624, 110.0, 22.0 ],
                    "text": "peakamp~ 4096"
                }
            },
            {
                "box": {
                    "id": "obj-7004",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 1682.086965084076, 2988.521738767624, 110.0, 22.0 ],
                    "text": "peakamp~ 4096"
                }
            },
            {
                "box": {
                    "id": "obj-7005",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "float" ],
                    "patching_rect": [ 966.0, 3468.0, 110.0, 22.0 ],
                    "text": "peakamp~ 4096"
                }
            },
            {
                "box": {
                    "id": "obj-7008",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 12.121211528778076, 3431.020197033882, 145.0, 22.0 ],
                    "text": "prepend meter vocals"
                }
            },
            {
                "box": {
                    "id": "obj-7009",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 656.0, 3032.0, 130.0, 22.0 ],
                    "text": "prepend meter drums"
                }
            },
            {
                "box": {
                    "id": "obj-7010",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1163.2463810443878, 3032.0, 125.0, 22.0 ],
                    "text": "prepend meter bass"
                }
            },
            {
                "box": {
                    "id": "obj-7011",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1682.086965084076, 3032.0, 135.0, 22.0 ],
                    "text": "prepend meter melody"
                }
            },
            {
                "box": {
                    "id": "obj-7012",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 966.0, 3525.0, 140.0, 22.0 ],
                    "text": "prepend meter master"
                }
            },
            {
                "box": {
                    "id": "obj-7013",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 966.0, 3667.0, 45.0, 22.0 ],
                    "text": "gate 1"
                }
            },
            {
                "box": {
                    "id": "obj-7014",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 2,
                    "outlettype": [ "bang", "" ],
                    "patching_rect": [ 966.0, 3329.0, 100.0, 22.0 ],
                    "text": "sel ws_ready"
                }
            },
            {
                "box": {
                    "id": "obj-7015",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 966.0, 3622.0, 32.0, 22.0 ],
                    "text": "1"
                }
            },
            {
                "box": {
                    "id": "obj-20008",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 187.29629385471344, 2646.4645171165466, 94.0, 22.0 ],
                    "text": "delay~ 512 7"
                }
            },
            {
                "box": {
                    "id": "obj-20009",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 187.29629385471344, 2747.8261098861694, 60.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-20010",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 228.29629385471344, 2684.0, 144.0, 22.0 ],
                    "text": "receive width_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-20011",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 309.0, 2718.8406023979187, 60.0, 22.0 ],
                    "text": "*~ -1"
                }
            },
            {
                "box": {
                    "id": "obj-20012",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 146.29629385471344, 2810.1449509859085, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-20013",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 268.0, 2810.1449509859085, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-20014",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 121.53536069393158, 2905.797125697136, 60.0, 22.0 ],
                    "text": "*~ 0.5"
                }
            },
            {
                "box": {
                    "id": "obj-20015",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 268.0, 2905.797125697136, 60.0, 22.0 ],
                    "text": "*~ 0.5"
                }
            },
            {
                "box": {
                    "id": "obj-20016",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 162.53536069393158, 2847.8261107206345, 80.5529203414917, 35.0 ],
                    "text": "receive panL_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-20017",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 309.0, 2847.8261107206345, 79.16666477918625, 35.0 ],
                    "text": "receive panR_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-20018",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 702.7284479141235, 2646.4645171165466, 94.0, 22.0 ],
                    "text": "delay~ 512 7"
                }
            },
            {
                "box": {
                    "id": "obj-20019",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 702.7284479141235, 2747.8261098861694, 60.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-20020",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 743.7284479141235, 2684.0, 144.0, 22.0 ],
                    "text": "receive width_drums"
                }
            },
            {
                "box": {
                    "id": "obj-20021",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 828.9910680055618, 2718.8406023979187, 60.0, 22.0 ],
                    "text": "*~ -1"
                }
            },
            {
                "box": {
                    "id": "obj-20022",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 661.7284479141235, 2810.1449509859085, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-20023",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 787.9910680055618, 2810.1449509859085, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-20024",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 661.7284479141235, 2905.797125697136, 60.0, 22.0 ],
                    "text": "*~ 0.5"
                }
            },
            {
                "box": {
                    "id": "obj-20025",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 787.9910680055618, 2905.797125697136, 60.0, 22.0 ],
                    "text": "*~ 0.5"
                }
            },
            {
                "box": {
                    "id": "obj-20026",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 702.7284479141235, 2847.8261107206345, 82.49999803304672, 35.0 ],
                    "text": "receive panL_drums"
                }
            },
            {
                "box": {
                    "id": "obj-20027",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 823.0, 2847.8261107206345, 85.8333312869072, 35.0 ],
                    "text": "receive panR_drums"
                }
            },
            {
                "box": {
                    "id": "obj-20028",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1205.2753669023514, 2646.4645171165466, 94.0, 22.0 ],
                    "text": "delay~ 512 7"
                }
            },
            {
                "box": {
                    "id": "obj-20029",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1205.2753669023514, 2747.8261098861694, 60.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-20030",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1246.2753669023514, 2684.0, 130.0, 22.0 ],
                    "text": "receive width_bass"
                }
            },
            {
                "box": {
                    "id": "obj-20031",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1334.2608752250671, 2718.8406023979187, 60.0, 22.0 ],
                    "text": "*~ -1"
                }
            },
            {
                "box": {
                    "id": "obj-20032",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1163.2463810443878, 2810.1449509859085, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-20033",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1289.3333386182785, 2810.1449509859085, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-20034",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1163.2463810443878, 2905.797125697136, 60.0, 22.0 ],
                    "text": "*~ 0.5"
                }
            },
            {
                "box": {
                    "id": "obj-20035",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1289.3333386182785, 2905.797125697136, 60.0, 22.0 ],
                    "text": "*~ 0.5"
                }
            },
            {
                "box": {
                    "id": "obj-20036",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1205.2753669023514, 2847.8261107206345, 69.32111406326294, 35.0 ],
                    "text": "receive panL_bass"
                }
            },
            {
                "box": {
                    "id": "obj-20037",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1330.3333386182785, 2847.8261107206345, 74.16666489839554, 35.0 ],
                    "text": "receive panR_bass"
                }
            },
            {
                "box": {
                    "id": "obj-20038",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1730.0, 2646.4645171165466, 94.0, 22.0 ],
                    "text": "delay~ 512 7"
                }
            },
            {
                "box": {
                    "id": "obj-20039",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1730.0, 2747.8261098861694, 60.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-20040",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1771.0, 2684.0, 137.0, 22.0 ],
                    "text": "receive width_melody"
                }
            },
            {
                "box": {
                    "id": "obj-20041",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1869.125, 2718.8406023979187, 60.0, 22.0 ],
                    "text": "*~ -1"
                }
            },
            {
                "box": {
                    "id": "obj-20042",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1689.0, 2810.1449509859085, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-20043",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1828.125, 2810.1449509859085, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-20044",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1689.0, 2905.797125697136, 60.0, 22.0 ],
                    "text": "*~ 0.5"
                }
            },
            {
                "box": {
                    "id": "obj-20045",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1828.125, 2905.797125697136, 60.0, 22.0 ],
                    "text": "*~ 0.5"
                }
            },
            {
                "box": {
                    "id": "obj-20046",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1730.0, 2847.8261107206345, 81.0, 35.0 ],
                    "text": "receive panL_melody"
                }
            },
            {
                "box": {
                    "id": "obj-20047",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1869.125, 2847.8261107206345, 83.33333134651184, 35.0 ],
                    "text": "receive panR_melody"
                }
            },
            {
                "box": {
                    "id": "obj-20100",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 5592.771291017532, 537.3494174480438, 140.0, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "ms_router.js",
                        "parameter_enable": 0
                    },
                    "text": "js ms_router.js"
                }
            },
            {
                "box": {
                    "id": "obj-20101",
                    "maxclass": "newobj",
                    "numinlets": 21,
                    "numoutlets": 21,
                    "outlettype": [ "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" ],
                    "patching_rect": [ 5592.771291017532, 577.1084550619125, 1408.0, 22.0 ],
                    "text": "route width_vocals panL_vocals panR_vocals width_melody panL_melody panR_melody width_bass panL_bass panR_bass width_drums panL_drums panR_drums fxsend1 fxreturn1 fxstereo master_gain fxsend_vocals fxsend_drums fxsend_bass fxsend_melody"
                }
            },
            {
                "box": {
                    "id": "obj-20102",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5592.771291017532, 620.4819506406784, 107.0, 22.0 ],
                    "text": "send width_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-20103",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5683.132740139961, 653.0120723247528, 128.0, 22.0 ],
                    "text": "send panL_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-20104",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5771.084550619125, 620.4819506406784, 128.0, 22.0 ],
                    "text": "send panR_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-20105",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5861.445999741554, 653.0120723247528, 135.0, 22.0 ],
                    "text": "send width_melody"
                }
            },
            {
                "box": {
                    "id": "obj-20106",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5951.807448863983, 620.4819506406784, 128.0, 22.0 ],
                    "text": "send panL_melody"
                }
            },
            {
                "box": {
                    "id": "obj-20107",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6040.96407866478, 653.0120723247528, 128.0, 22.0 ],
                    "text": "send panR_melody"
                }
            },
            {
                "box": {
                    "id": "obj-20108",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6130.120708465576, 620.4819506406784, 121.0, 22.0 ],
                    "text": "send width_bass"
                }
            },
            {
                "box": {
                    "id": "obj-20109",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6220.482157588005, 653.0120723247528, 114.0, 22.0 ],
                    "text": "send panL_bass"
                }
            },
            {
                "box": {
                    "id": "obj-20110",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6314.458064675331, 620.4819506406784, 114.0, 22.0 ],
                    "text": "send panR_bass"
                }
            },
            {
                "box": {
                    "id": "obj-20111",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6397.590597867966, 653.0120723247528, 128.0, 22.0 ],
                    "text": "send width_drums"
                }
            },
            {
                "box": {
                    "id": "obj-20112",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6492.771324276924, 620.4819506406784, 121.0, 22.0 ],
                    "text": "send panL_drums"
                }
            },
            {
                "box": {
                    "id": "obj-20113",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6583.132773399353, 653.0120723247528, 121.0, 22.0 ],
                    "text": "send panR_drums"
                }
            },
            {
                "box": {
                    "id": "obj-20114",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6672.2894032001495, 620.4819506406784, 100.0, 22.0 ],
                    "text": "send fxsend1"
                }
            },
            {
                "box": {
                    "id": "obj-20115",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6761.446033000946, 653.0120723247528, 114.0, 22.0 ],
                    "text": "send fxreturn1"
                }
            },
            {
                "box": {
                    "id": "obj-21000",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 204.04039406776428, 3253.242427945137, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21001",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 204.04039406776428, 3292.6363654136658, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21002",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 204.04039406776428, 3329.0, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21003",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 298.9898843765259, 3253.242427945137, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21004",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 298.9898843765259, 3292.6363654136658, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21005",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 298.9898843765259, 3329.0, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21030",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 205.0504950284958, 3869.404013991356, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21031",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 302.0201872587204, 3869.404013991356, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21032",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 245.45453345775604, 3927.9898697137833, 76.0, 22.0 ],
                    "text": "dac~ 1 2"
                }
            },
            {
                "box": {
                    "id": "obj-21050",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 477.7777544260025, 3250.5251092910767, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21051",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 477.7777544260025, 3289.96172952652, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21052",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 477.7777544260025, 3327.9898990392685, 60.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-21053",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 477.7777544260025, 3372.434341311455, 62.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-21054",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 602.8169093132019, 3329.0, 125.0, 22.0 ],
                    "text": "receive fxsend1"
                }
            },
            {
                "box": {
                    "id": "obj-21055",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 435.35351407527924, 3598.696956515312, 62.0, 22.0 ],
                    "text": "dac~ 3 4"
                }
            },
            {
                "box": {
                    "id": "obj-21060",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 354.5454372167587, 3636.070692062378, 62.0, 22.0 ],
                    "text": "adc~ 3"
                }
            },
            {
                "box": {
                    "id": "obj-21061",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 246.46463441848755, 3766.3737159967422, 62.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-21062",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 378.7878602743149, 3692.6363458633423, 125.0, 22.0 ],
                    "text": "receive fxreturn1"
                }
            },
            {
                "box": {
                    "id": "obj-21070",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 204.04039406776428, 3327.9898990392685, 60.0, 22.0 ],
                    "text": "*~ 1"
                }
            },
            {
                "box": {
                    "id": "obj-21071",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 354.5454372167587, 3431.020197033882, 60.0, 22.0 ],
                    "text": "*~ 1"
                }
            },
            {
                "box": {
                    "id": "obj-21072",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "patching_rect": [ 394.949475646019, 3372.434341311455, 60.0, 22.0 ],
                    "text": "!- 1"
                }
            },
            {
                "box": {
                    "id": "obj-21080",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 204.04039406776428, 3372.434341311455, 60.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-21081",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 298.9898843765259, 3372.434341311455, 60.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-21082",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 309.09089398384094, 3540.111100792885, 111.0, 22.0 ],
                    "text": "selector~ 2 1"
                }
            },
            {
                "box": {
                    "id": "obj-21083",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 477.7777544260025, 3540.111100792885, 111.0, 22.0 ],
                    "text": "selector~ 2 1"
                }
            },
            {
                "box": {
                    "id": "obj-21090",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 435.35351407527924, 3636.070692062378, 62.0, 22.0 ],
                    "text": "adc~ 4"
                }
            },
            {
                "box": {
                    "id": "obj-21091",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 435.35351407527924, 3766.3737159967422, 60.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-21092",
                    "maxclass": "newobj",
                    "numinlets": 3,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 343.43432664871216, 3815.868663072586, 111.0, 22.0 ],
                    "text": "selector~ 2 1"
                }
            },
            {
                "box": {
                    "id": "obj-21085",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 204.04039406776428, 3431.020197033882, 132.0, 22.0 ],
                    "text": "receive fxstereo"
                }
            },
            {
                "box": {
                    "id": "obj-21086",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "int" ],
                    "patching_rect": [ 204.04039406776428, 3485.5656489133835, 60.0, 22.0 ],
                    "text": "+ 1"
                }
            },
            {
                "box": {
                    "id": "obj-21087",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6799.9999351501465, 620.4819506406784, 111.0, 22.0 ],
                    "text": "send fxstereo"
                }
            },
            {
                "box": {
                    "id": "obj-22000",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 5593.334489822388, 240.96386432647705, 140.0, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "eq_router.js",
                        "parameter_enable": 0
                    },
                    "text": "js eq_router.js"
                }
            },
            {
                "box": {
                    "id": "obj-22001",
                    "linecount": 2,
                    "maxclass": "newobj",
                    "numinlets": 21,
                    "numoutlets": 21,
                    "outlettype": [ "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" ],
                    "patching_rect": [ 5593.334489822388, 326.5060361623764, 954.0, 35.0 ],
                    "text": "route trim_vocals trim_drums trim_bass trim_melody eq_low_coef_vocals eq_low_coef_drums eq_low_coef_bass eq_low_coef_melody eq_mid_coef_vocals eq_mid_coef_drums eq_mid_coef_bass eq_mid_coef_melody eq_high_coef_vocals eq_high_coef_drums eq_high_coef_bass eq_high_coef_melody gain_vocals gain_drums gain_bass gain_melody"
                }
            },
            {
                "box": {
                    "id": "obj-22002",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5684.931093454361, 416.8674852848053, 140.0, 22.0 ],
                    "text": "send trim_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-22003",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5806.617844939232, 385.5421829223633, 140.0, 22.0 ],
                    "text": "send trim_drums"
                }
            },
            {
                "box": {
                    "id": "obj-22004",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5927.09977710247, 416.8674852848053, 140.0, 22.0 ],
                    "text": "send trim_bass"
                }
            },
            {
                "box": {
                    "id": "obj-22005",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6046.3768899440765, 385.5421829223633, 140.0, 22.0 ],
                    "text": "send trim_melody"
                }
            },
            {
                "box": {
                    "id": "obj-22006",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6166.858822107315, 416.8674852848053, 146.0, 22.0 ],
                    "text": "send eq_low_coef_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-22007",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6289.750392913818, 385.5421829223633, 145.0, 22.0 ],
                    "text": "send eq_low_coef_drums"
                }
            },
            {
                "box": {
                    "id": "obj-22008",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6406.61786711216, 416.8674852848053, 140.0, 22.0 ],
                    "text": "send eq_low_coef_bass"
                }
            },
            {
                "box": {
                    "id": "obj-22009",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6528.304618597031, 385.5421829223633, 151.0, 22.0 ],
                    "text": "send eq_low_coef_melody"
                }
            },
            {
                "box": {
                    "id": "obj-22010",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5597.612273812294, 450.0, 147.0, 22.0 ],
                    "text": "send eq_mid_coef_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-22011",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5715.816421985626, 479.51809000968933, 147.0, 22.0 ],
                    "text": "send eq_mid_coef_drums"
                }
            },
            {
                "box": {
                    "id": "obj-22012",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5834.939974665642, 450.0, 140.0, 22.0 ],
                    "text": "send eq_mid_coef_bass"
                }
            },
            {
                "box": {
                    "id": "obj-22013",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5952.3706476688385, 479.51809000968933, 152.0, 22.0 ],
                    "text": "send eq_mid_coef_melody"
                }
            },
            {
                "box": {
                    "id": "obj-22014",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6076.352579832077, 450.0, 151.0, 22.0 ],
                    "text": "send eq_high_coef_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-22015",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6192.77131319046, 479.51809000968933, 150.0, 22.0 ],
                    "text": "send eq_high_coef_drums"
                }
            },
            {
                "box": {
                    "id": "obj-22016",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6315.0212634801865, 450.0, 142.0, 22.0 ],
                    "text": "send eq_high_coef_bass"
                }
            },
            {
                "box": {
                    "id": "obj-22017",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6434.93999683857, 479.51809000968933, 155.0, 22.0 ],
                    "text": "send eq_high_coef_melody"
                }
            },
            {
                "box": {
                    "id": "obj-22018",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 191.4375, 2157.5756521224976, 50.0, 22.0 ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-22019",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 268.0, 2157.5756521224976, 140.0, 22.0 ],
                    "text": "receive trim_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-22020",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 146.29629385471344, 2344.9275557994843, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22021",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 274.20326602458954, 2246.0903500318527, 180.0, 22.0 ],
                    "text": "receive eq_low_coef_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-22022",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 274.20326602458954, 2280.974069714546, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22023",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 146.29629385471344, 2437.950808286667, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22024",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 274.20326602458954, 2344.9275557994843, 180.0, 22.0 ],
                    "text": "receive eq_mid_coef_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-22025",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 274.20326602458954, 2384.462438106537, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22026",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 146.29629385471344, 2533.299642086029, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22027",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 274.20326602458954, 2437.950808286667, 180.0, 22.0 ],
                    "text": "receive eq_high_coef_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-22028",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 274.20326602458954, 2473.99731862545, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22029",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 709.9791656434536, 2157.4999485611916, 50.0, 22.0 ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-22030",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 795.9166656434536, 2157.4999485611916, 140.0, 22.0 ],
                    "text": "receive trim_drums"
                }
            },
            {
                "box": {
                    "id": "obj-22031",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 791.919153213501, 2344.9275557994843, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22032",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 923.2322781085968, 2245.4544357061386, 180.0, 22.0 ],
                    "text": "receive eq_low_coef_drums"
                }
            },
            {
                "box": {
                    "id": "obj-22033",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 923.2322781085968, 2280.8079693317413, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22034",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 791.919153213501, 2438.3837192058563, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22035",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 923.2322781085968, 2344.9275557994843, 180.0, 22.0 ],
                    "text": "receive eq_mid_coef_drums"
                }
            },
            {
                "box": {
                    "id": "obj-22036",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 923.2322781085968, 2384.8483682870865, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22037",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 791.919153213501, 2534.0, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22038",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 923.2322781085968, 2438.3837192058563, 180.0, 22.0 ],
                    "text": "receive eq_high_coef_drums"
                }
            },
            {
                "box": {
                    "id": "obj-22039",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 923.2322781085968, 2473.737252831459, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22040",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1231.3333037495613, 2157.4999485611916, 50.0, 22.0 ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-22041",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1312.2318893671036, 2157.4999485611916, 140.0, 22.0 ],
                    "text": "receive trim_bass"
                }
            },
            {
                "box": {
                    "id": "obj-22042",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1292.2318893671036, 2344.9275557994843, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22043",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1395.1304409503937, 2245.4544357061386, 180.0, 22.0 ],
                    "text": "receive eq_low_coef_bass"
                }
            },
            {
                "box": {
                    "id": "obj-22044",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 1395.1304409503937, 2280.8079693317413, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22045",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1292.2318893671036, 2438.3837192058563, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22046",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1395.1304409503937, 2344.9275557994843, 180.0, 22.0 ],
                    "text": "receive eq_mid_coef_bass"
                }
            },
            {
                "box": {
                    "id": "obj-22047",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 1395.1304409503937, 2384.8483682870865, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22048",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1289.3333386182785, 2528.2827047109604, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22049",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1395.1304409503937, 2438.3837192058563, 180.0, 22.0 ],
                    "text": "receive eq_high_coef_bass"
                }
            },
            {
                "box": {
                    "id": "obj-22050",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 1395.1304409503937, 2473.737252831459, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22051",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1761.0, 2157.4999485611916, 50.0, 22.0 ],
                    "text": "*~"
                }
            },
            {
                "box": {
                    "id": "obj-22052",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1884.4375, 2157.4999485611916, 140.0, 22.0 ],
                    "text": "receive trim_melody"
                }
            },
            {
                "box": {
                    "id": "obj-22053",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1828.0, 2344.9275557994843, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22054",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1965.625, 2245.4544357061386, 180.0, 22.0 ],
                    "text": "receive eq_low_coef_melody"
                }
            },
            {
                "box": {
                    "id": "obj-22055",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 1965.625, 2280.8079693317413, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22056",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1828.0, 2438.3837192058563, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22057",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1965.625, 2344.9275557994843, 180.0, 22.0 ],
                    "text": "receive eq_mid_coef_melody"
                }
            },
            {
                "box": {
                    "id": "obj-22058",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 1965.625, 2384.8483682870865, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22059",
                    "maxclass": "newobj",
                    "numinlets": 6,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1828.125, 2528.2827047109604, 80.0, 22.0 ],
                    "text": "biquad~"
                }
            },
            {
                "box": {
                    "id": "obj-22060",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1965.625, 2438.3837192058563, 180.0, 22.0 ],
                    "text": "receive eq_high_coef_melody"
                }
            },
            {
                "box": {
                    "id": "obj-22061",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 5,
                    "outlettype": [ "float", "float", "float", "float", "float" ],
                    "patching_rect": [ 1965.625, 2473.737252831459, 180.0, 22.0 ],
                    "text": "unpack 0. 0. 0. 0. 0."
                }
            },
            {
                "box": {
                    "id": "obj-22062",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 1,
                    "outlettype": [ "bang" ],
                    "patching_rect": [ 5593.334489822388, 286.7469985485077, 70.0, 22.0 ],
                    "text": "loadbang"
                }
            },
            {
                "box": {
                    "id": "obj-22063",
                    "maxclass": "message",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 5677.671842336655, 286.7469985485077, 60.0, 22.0 ],
                    "text": "resend"
                }
            },
            {
                "box": {
                    "id": "obj-22064",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 110.0, 3927.9898697137833, 100.0, 22.0 ],
                    "text": "sfrecord~ 2"
                }
            },
            {
                "box": {
                    "id": "obj-22065",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 110.0, 3815.868663072586, 160.0, 22.0 ],
                    "text": "receive record_cmd"
                }
            },
            {
                "box": {
                    "id": "obj-23000",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 256.3, 2628.0, 180.0, 22.0 ],
                    "text": "receive gain_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23001",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 146.3, 2628.0, 52.0, 22.0 ],
                    "text": "*~ 1"
                }
            },
            {
                "box": {
                    "id": "obj-23002",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 901.9, 2628.0, 180.0, 22.0 ],
                    "text": "receive gain_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23003",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 791.9, 2628.0, 52.0, 22.0 ],
                    "text": "*~ 1"
                }
            },
            {
                "box": {
                    "id": "obj-23004",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1399.3, 2628.0, 180.0, 22.0 ],
                    "text": "receive gain_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23005",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1289.3, 2628.0, 52.0, 22.0 ],
                    "text": "*~ 1"
                }
            },
            {
                "box": {
                    "id": "obj-23006",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1938.1, 2628.0, 180.0, 22.0 ],
                    "text": "receive gain_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23007",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1828.1, 2628.0, 52.0, 22.0 ],
                    "text": "*~ 1"
                }
            },
            {
                "box": {
                    "id": "obj-23008",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 614.0, 3914.0, 180.0, 22.0 ],
                    "text": "receive fxsend_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23009",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 671.0, 3962.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-230010",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 804.0, 3914.0, 180.0, 22.0 ],
                    "text": "receive fxsend_drums"
                }
            },
            {
                "box": {
                    "id": "obj-230011",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 771.0, 3962.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-230012",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1004.0, 3914.0, 180.0, 22.0 ],
                    "text": "receive fxsend_bass"
                }
            },
            {
                "box": {
                    "id": "obj-230013",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1068.0, 3962.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-230014",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1201.0, 3914.0, 180.0, 22.0 ],
                    "text": "receive fxsend_melody"
                }
            },
            {
                "box": {
                    "id": "obj-230015",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1168.0, 3962.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23016",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 711.0, 4002.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23017",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 711.0, 4032.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23018",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 711.0, 4062.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23019",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 12.121211528778076, 3301.0, 180.0, 22.0 ],
                    "text": "receive master_gain"
                }
            },
            {
                "box": {
                    "id": "obj-23020",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5598.0, 515.0, 180.0, 22.0 ],
                    "text": "send gain_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23021",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5725.0, 540.0, 180.0, 22.0 ],
                    "text": "send gain_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23022",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5850.0, 515.0, 180.0, 22.0 ],
                    "text": "send gain_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23023",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 5975.0, 540.0, 180.0, 22.0 ],
                    "text": "send gain_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23024",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6680.0, 620.0, 180.0, 22.0 ],
                    "text": "send master_gain"
                }
            },
            {
                "box": {
                    "id": "obj-23025",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6680.0, 655.0, 180.0, 22.0 ],
                    "text": "send fxsend_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23026",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6800.0, 620.0, 180.0, 22.0 ],
                    "text": "send fxsend_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23027",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6800.0, 655.0, 180.0, 22.0 ],
                    "text": "send fxsend_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23028",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 6920.0, 620.0, 180.0, 22.0 ],
                    "text": "send fxsend_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23029",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 2,
                    "outlettype": [ "", "" ],
                    "patching_rect": [ 7100.0, 240.0, 160.0, 22.0 ],
                    "saved_object_attributes": {
                        "filename": "spatial_router.js",
                        "parameter_enable": 0
                    },
                    "text": "js spatial_router.js"
                }
            },
            {
                "box": {
                    "id": "obj-23030",
                    "maxclass": "newobj",
                    "numinlets": 17,
                    "numoutlets": 17,
                    "outlettype": [ "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "" ],
                    "patching_rect": [ 7100.0, 280.0, 1500.0, 22.0 ],
                    "text": "route gain_FL_vocals gain_FR_vocals gain_RL_vocals gain_RR_vocals gain_FL_drums gain_FR_drums gain_RL_drums gain_RR_drums gain_FL_bass gain_FR_bass gain_RL_bass gain_RR_bass gain_FL_melody gain_FR_melody gain_RL_melody gain_RR_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23031",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 7100.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_FL_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23032",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 7195.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_FR_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23033",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 7290.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_RL_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23034",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 7385.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_RR_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23035",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 7480.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_FL_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23036",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 7575.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_FR_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23037",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 7670.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_RL_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23038",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 7765.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_RR_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23039",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 7860.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_FL_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23040",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 7955.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_FR_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23041",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 8050.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_RL_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23042",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 8145.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_RR_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23043",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 8240.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_FL_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23044",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 8335.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_FR_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23045",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 8430.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_RL_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23046",
                    "maxclass": "newobj",
                    "numinlets": 1,
                    "numoutlets": 0,
                    "patching_rect": [ 8525.0, 340.0, 180.0, 22.0 ],
                    "text": "send gain_RR_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23047",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 633.0, 4200.0, 180.0, 22.0 ],
                    "text": "receive gain_FL_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23048",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 600.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23049",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 711.0, 4174.0, 180.0, 22.0 ],
                    "text": "receive gain_FR_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23050",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 678.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23051",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 789.0, 4150.0, 180.0, 22.0 ],
                    "text": "receive gain_RL_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23052",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 756.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23053",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 867.0, 4200.0, 180.0, 22.0 ],
                    "text": "receive gain_RR_vocals"
                }
            },
            {
                "box": {
                    "id": "obj-23054",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 834.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23055",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 945.0, 4174.0, 180.0, 22.0 ],
                    "text": "receive gain_FL_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23056",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 912.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23057",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1023.0, 4146.0, 180.0, 22.0 ],
                    "text": "receive gain_FR_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23058",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 990.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23059",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1101.0, 4200.0, 180.0, 22.0 ],
                    "text": "receive gain_RL_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23060",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1068.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23061",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1179.0, 4174.0, 180.0, 22.0 ],
                    "text": "receive gain_RR_drums"
                }
            },
            {
                "box": {
                    "id": "obj-23062",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1146.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23063",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1257.0, 4146.0, 180.0, 22.0 ],
                    "text": "receive gain_FL_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23064",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1224.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23065",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1335.0, 4200.0, 180.0, 22.0 ],
                    "text": "receive gain_FR_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23066",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1302.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23067",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1413.0, 4174.0, 180.0, 22.0 ],
                    "text": "receive gain_RL_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23068",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1380.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23069",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1491.0, 4146.0, 180.0, 22.0 ],
                    "text": "receive gain_RR_bass"
                }
            },
            {
                "box": {
                    "id": "obj-23070",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1458.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23071",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1569.0, 4200.0, 180.0, 22.0 ],
                    "text": "receive gain_FL_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23072",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1536.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23073",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1647.0, 4174.0, 180.0, 22.0 ],
                    "text": "receive gain_FR_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23074",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1614.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23075",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1725.0, 4146.0, 180.0, 22.0 ],
                    "text": "receive gain_RL_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23076",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1692.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23077",
                    "maxclass": "newobj",
                    "numinlets": 0,
                    "numoutlets": 1,
                    "outlettype": [ "" ],
                    "patching_rect": [ 1803.0, 4200.0, 180.0, 22.0 ],
                    "text": "receive gain_RR_melody"
                }
            },
            {
                "box": {
                    "id": "obj-23078",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1770.0, 4245.0, 52.0, 22.0 ],
                    "text": "*~ 0"
                }
            },
            {
                "box": {
                    "id": "obj-23079",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 717.0, 4310.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23080",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 717.0, 4355.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23081",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 717.0, 4400.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23082",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1029.0, 4310.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23083",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1029.0, 4355.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23084",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1029.0, 4400.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23085",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1341.0, 4310.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23086",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1341.0, 4355.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23087",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1341.0, 4400.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23088",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1653.0, 4310.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23089",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1653.0, 4355.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23090",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 1,
                    "outlettype": [ "signal" ],
                    "patching_rect": [ 1653.0, 4400.0, 40.0, 22.0 ],
                    "text": "+~"
                }
            },
            {
                "box": {
                    "id": "obj-23091",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 717.0, 4460.0, 80.0, 22.0 ],
                    "text": "dac~ 5 6"
                }
            },
            {
                "box": {
                    "id": "obj-23092",
                    "maxclass": "newobj",
                    "numinlets": 2,
                    "numoutlets": 0,
                    "patching_rect": [ 1341.0, 4460.0, 80.0, 22.0 ],
                    "text": "dac~ 7 8"
                }
            }
        ],
        "lines": [
            {
                "patchline": {
                    "destination": [ "obj-4038", 0 ],
                    "order": 0,
                    "source": [ "obj-10", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 0 ],
                    "order": 1,
                    "source": [ "obj-10", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-110", 0 ],
                    "order": 1,
                    "source": [ "obj-100", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-426", 0 ],
                    "order": 0,
                    "source": [ "obj-100", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10000", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10002", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10004", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10006", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10008", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10017", 0 ],
                    "source": [ "obj-10013", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10018", 0 ],
                    "source": [ "obj-10014", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10019", 0 ],
                    "source": [ "obj-10015", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10020", 0 ],
                    "source": [ "obj-10016", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10017", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10018", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10019", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-10020", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "source": [ "obj-101", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-94", 0 ],
                    "source": [ "obj-102", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-436", 0 ],
                    "order": 0,
                    "source": [ "obj-105", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-98", 0 ],
                    "order": 1,
                    "source": [ "obj-105", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-104", 0 ],
                    "source": [ "obj-106", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-104", 0 ],
                    "source": [ "obj-107", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-105", 0 ],
                    "source": [ "obj-109", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-15", 0 ],
                    "source": [ "obj-11", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-113", 0 ],
                    "source": [ "obj-112", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-113", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-127", 0 ],
                    "source": [ "obj-115", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-119", 0 ],
                    "source": [ "obj-116", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-120", 0 ],
                    "source": [ "obj-116", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-127", 0 ],
                    "source": [ "obj-117", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-69", 0 ],
                    "source": [ "obj-118", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-114", 0 ],
                    "source": [ "obj-119", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-114", 0 ],
                    "source": [ "obj-120", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-116", 0 ],
                    "order": 1,
                    "source": [ "obj-121", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-336", 0 ],
                    "order": 0,
                    "source": [ "obj-121", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-121", 0 ],
                    "source": [ "obj-122", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-125", 0 ],
                    "source": [ "obj-124", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-126", 0 ],
                    "source": [ "obj-124", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-123", 0 ],
                    "source": [ "obj-125", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-123", 0 ],
                    "source": [ "obj-126", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-18", 0 ],
                    "order": 1,
                    "source": [ "obj-13", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-8", 0 ],
                    "order": 2,
                    "source": [ "obj-13", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9922", 0 ],
                    "order": 0,
                    "source": [ "obj-13", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-327", 0 ],
                    "order": 1,
                    "source": [ "obj-132", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-364", 0 ],
                    "order": 0,
                    "source": [ "obj-132", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-132", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-270", 0 ],
                    "order": 1,
                    "source": [ "obj-133", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-325", 0 ],
                    "order": 0,
                    "source": [ "obj-133", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-133", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-275", 0 ],
                    "order": 2,
                    "source": [ "obj-134", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-281", 0 ],
                    "order": 0,
                    "source": [ "obj-134", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-299", 0 ],
                    "order": 1,
                    "source": [ "obj-134", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-134", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-341", 0 ],
                    "order": 0,
                    "source": [ "obj-135", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-347", 0 ],
                    "order": 1,
                    "source": [ "obj-135", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-135", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-500", 0 ],
                    "source": [ "obj-136", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-141", 0 ],
                    "source": [ "obj-138", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-141", 0 ],
                    "source": [ "obj-139", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-15", 0 ],
                    "source": [ "obj-14", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-143", 0 ],
                    "source": [ "obj-140", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-142", 0 ],
                    "source": [ "obj-143", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-147", 0 ],
                    "source": [ "obj-144", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-147", 0 ],
                    "source": [ "obj-145", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-149", 0 ],
                    "source": [ "obj-146", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-148", 0 ],
                    "source": [ "obj-149", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-27", 0 ],
                    "source": [ "obj-15", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-153", 0 ],
                    "source": [ "obj-150", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-153", 0 ],
                    "source": [ "obj-151", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-155", 0 ],
                    "source": [ "obj-152", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-154", 0 ],
                    "source": [ "obj-155", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-124", 0 ],
                    "order": 1,
                    "source": [ "obj-156", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-236", 0 ],
                    "order": 0,
                    "source": [ "obj-156", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-156", 0 ],
                    "source": [ "obj-158", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5", 0 ],
                    "order": 1,
                    "source": [ "obj-16", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9920", 0 ],
                    "order": 0,
                    "source": [ "obj-16", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-770", 0 ],
                    "source": [ "obj-163", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-770", 0 ],
                    "source": [ "obj-164", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-770", 0 ],
                    "source": [ "obj-165", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-167", 0 ],
                    "source": [ "obj-168", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-26", 0 ],
                    "source": [ "obj-17", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-170", 0 ],
                    "source": [ "obj-171", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-163", 0 ],
                    "order": 0,
                    "source": [ "obj-172", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-165", 1 ],
                    "source": [ "obj-172", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-165", 0 ],
                    "source": [ "obj-172", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-187", 0 ],
                    "order": 1,
                    "source": [ "obj-172", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-175", 0 ],
                    "source": [ "obj-176", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-171", 0 ],
                    "midpoints": [ 4392.746846795082, 2168.6778732538223, 4625.141216039658, 2168.6778732538223 ],
                    "order": 0,
                    "source": [ "obj-177", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-176", 0 ],
                    "order": 1,
                    "source": [ "obj-177", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-177", 0 ],
                    "midpoints": [ 4392.746846795082, 2105.6778732538223, 4392.746846795082, 2105.6778732538223 ],
                    "order": 1,
                    "source": [ "obj-179", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6", 0 ],
                    "midpoints": [ 4392.746846795082, 2120.6778732538223, 4882.887698292732, 2120.6778732538223 ],
                    "order": 0,
                    "source": [ "obj-179", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-179", 0 ],
                    "source": [ "obj-181", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23", 0 ],
                    "source": [ "obj-187", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-233", 0 ],
                    "source": [ "obj-189", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-234", 0 ],
                    "source": [ "obj-192", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-202", 0 ],
                    "order": 0,
                    "source": [ "obj-200", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-210", 0 ],
                    "order": 1,
                    "source": [ "obj-200", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20009", 0 ],
                    "source": [ "obj-20008", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20011", 0 ],
                    "order": 0,
                    "source": [ "obj-20009", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20012", 1 ],
                    "order": 1,
                    "source": [ "obj-20009", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20009", 1 ],
                    "source": [ "obj-20010", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20013", 1 ],
                    "source": [ "obj-20011", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20014", 0 ],
                    "source": [ "obj-20012", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20015", 0 ],
                    "source": [ "obj-20013", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21000", 0 ],
                    "source": [ "obj-20014", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21003", 0 ],
                    "source": [ "obj-20015", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20014", 1 ],
                    "source": [ "obj-20016", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20015", 1 ],
                    "source": [ "obj-20017", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20019", 0 ],
                    "source": [ "obj-20018", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20021", 0 ],
                    "order": 0,
                    "source": [ "obj-20019", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20022", 1 ],
                    "order": 1,
                    "source": [ "obj-20019", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20019", 1 ],
                    "source": [ "obj-20020", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20023", 1 ],
                    "source": [ "obj-20021", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20024", 0 ],
                    "source": [ "obj-20022", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20025", 0 ],
                    "source": [ "obj-20023", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21000", 1 ],
                    "source": [ "obj-20024", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21003", 1 ],
                    "source": [ "obj-20025", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20024", 1 ],
                    "source": [ "obj-20026", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20025", 1 ],
                    "source": [ "obj-20027", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20029", 0 ],
                    "source": [ "obj-20028", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20031", 0 ],
                    "order": 0,
                    "source": [ "obj-20029", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20032", 1 ],
                    "order": 1,
                    "source": [ "obj-20029", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20029", 1 ],
                    "source": [ "obj-20030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20033", 1 ],
                    "source": [ "obj-20031", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20034", 0 ],
                    "source": [ "obj-20032", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20035", 0 ],
                    "source": [ "obj-20033", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21001", 1 ],
                    "source": [ "obj-20034", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21004", 1 ],
                    "source": [ "obj-20035", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20034", 1 ],
                    "source": [ "obj-20036", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20035", 1 ],
                    "source": [ "obj-20037", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20039", 0 ],
                    "source": [ "obj-20038", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20041", 0 ],
                    "order": 0,
                    "source": [ "obj-20039", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20042", 1 ],
                    "order": 1,
                    "source": [ "obj-20039", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20039", 1 ],
                    "source": [ "obj-20040", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20043", 1 ],
                    "source": [ "obj-20041", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20044", 0 ],
                    "source": [ "obj-20042", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20045", 0 ],
                    "source": [ "obj-20043", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21002", 1 ],
                    "source": [ "obj-20044", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21005", 1 ],
                    "source": [ "obj-20045", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20044", 1 ],
                    "source": [ "obj-20046", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20045", 1 ],
                    "source": [ "obj-20047", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20101", 0 ],
                    "source": [ "obj-20100", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20102", 0 ],
                    "source": [ "obj-20101", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20103", 0 ],
                    "source": [ "obj-20101", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20104", 0 ],
                    "source": [ "obj-20101", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20105", 0 ],
                    "source": [ "obj-20101", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20106", 0 ],
                    "source": [ "obj-20101", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20107", 0 ],
                    "source": [ "obj-20101", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20108", 0 ],
                    "source": [ "obj-20101", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20109", 0 ],
                    "source": [ "obj-20101", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20110", 0 ],
                    "source": [ "obj-20101", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20111", 0 ],
                    "source": [ "obj-20101", 9 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20112", 0 ],
                    "source": [ "obj-20101", 10 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20113", 0 ],
                    "source": [ "obj-20101", 11 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20114", 0 ],
                    "source": [ "obj-20101", 12 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20115", 0 ],
                    "source": [ "obj-20101", 13 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21087", 0 ],
                    "source": [ "obj-20101", 14 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23024", 0 ],
                    "source": [ "obj-20101", 15 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23025", 0 ],
                    "source": [ "obj-20101", 16 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23026", 0 ],
                    "source": [ "obj-20101", 17 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23027", 0 ],
                    "source": [ "obj-20101", 18 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23028", 0 ],
                    "source": [ "obj-20101", 19 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-232", 0 ],
                    "order": 1,
                    "source": [ "obj-202", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4017", 0 ],
                    "order": 0,
                    "source": [ "obj-202", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-198", 0 ],
                    "source": [ "obj-208", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21001", 0 ],
                    "source": [ "obj-21000", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21002", 0 ],
                    "source": [ "obj-21001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21070", 0 ],
                    "order": 1,
                    "source": [ "obj-21002", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21080", 0 ],
                    "order": 0,
                    "source": [ "obj-21002", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21004", 0 ],
                    "source": [ "obj-21003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21005", 0 ],
                    "source": [ "obj-21004", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21071", 0 ],
                    "order": 0,
                    "source": [ "obj-21005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21081", 0 ],
                    "order": 1,
                    "source": [ "obj-21005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21032", 0 ],
                    "order": 0,
                    "source": [ "obj-21030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22064", 1 ],
                    "order": 1,
                    "source": [ "obj-21030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21032", 1 ],
                    "source": [ "obj-21031", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21082", 1 ],
                    "order": 1,
                    "source": [ "obj-21053", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21083", 1 ],
                    "order": 0,
                    "source": [ "obj-21053", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21053", 1 ],
                    "order": 0,
                    "source": [ "obj-21054", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21072", 0 ],
                    "order": 1,
                    "source": [ "obj-21054", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21080", 1 ],
                    "order": 3,
                    "source": [ "obj-21054", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21081", 1 ],
                    "order": 2,
                    "source": [ "obj-21054", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21061", 0 ],
                    "source": [ "obj-21060", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21030", 1 ],
                    "order": 1,
                    "source": [ "obj-21061", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21092", 1 ],
                    "order": 0,
                    "source": [ "obj-21061", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21061", 1 ],
                    "order": 1,
                    "source": [ "obj-21062", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21091", 1 ],
                    "order": 0,
                    "source": [ "obj-21062", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21030", 0 ],
                    "source": [ "obj-21070", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21031", 0 ],
                    "source": [ "obj-21071", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21070", 1 ],
                    "order": 1,
                    "source": [ "obj-21072", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21071", 1 ],
                    "order": 0,
                    "source": [ "obj-21072", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21082", 2 ],
                    "source": [ "obj-21080", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21083", 2 ],
                    "source": [ "obj-21081", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21055", 0 ],
                    "source": [ "obj-21082", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21055", 1 ],
                    "source": [ "obj-21083", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21086", 0 ],
                    "source": [ "obj-21085", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21082", 0 ],
                    "order": 2,
                    "source": [ "obj-21086", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21083", 0 ],
                    "order": 0,
                    "source": [ "obj-21086", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21092", 0 ],
                    "order": 1,
                    "source": [ "obj-21086", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21091", 0 ],
                    "source": [ "obj-21090", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21092", 2 ],
                    "source": [ "obj-21091", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21031", 1 ],
                    "source": [ "obj-21092", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-213", 0 ],
                    "source": [ "obj-212", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-213", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-198", 0 ],
                    "source": [ "obj-216", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-208", 0 ],
                    "source": [ "obj-217", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-216", 0 ],
                    "source": [ "obj-217", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-222", 0 ],
                    "source": [ "obj-220", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-223", 0 ],
                    "source": [ "obj-220", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22001", 0 ],
                    "source": [ "obj-22000", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22002", 0 ],
                    "source": [ "obj-22001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22003", 0 ],
                    "source": [ "obj-22001", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22004", 0 ],
                    "source": [ "obj-22001", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22005", 0 ],
                    "source": [ "obj-22001", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22006", 0 ],
                    "source": [ "obj-22001", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22007", 0 ],
                    "source": [ "obj-22001", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22008", 0 ],
                    "source": [ "obj-22001", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22009", 0 ],
                    "source": [ "obj-22001", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22010", 0 ],
                    "source": [ "obj-22001", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22011", 0 ],
                    "source": [ "obj-22001", 9 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22012", 0 ],
                    "source": [ "obj-22001", 10 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22013", 0 ],
                    "source": [ "obj-22001", 11 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22014", 0 ],
                    "source": [ "obj-22001", 12 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22015", 0 ],
                    "source": [ "obj-22001", 13 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22016", 0 ],
                    "source": [ "obj-22001", 14 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22017", 0 ],
                    "source": [ "obj-22001", 15 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23020", 0 ],
                    "source": [ "obj-22001", 16 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23021", 0 ],
                    "source": [ "obj-22001", 17 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23022", 0 ],
                    "source": [ "obj-22001", 18 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23023", 0 ],
                    "source": [ "obj-22001", 19 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22020", 0 ],
                    "source": [ "obj-22018", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22018", 1 ],
                    "source": [ "obj-22019", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22023", 0 ],
                    "source": [ "obj-22020", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22022", 0 ],
                    "source": [ "obj-22021", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22020", 5 ],
                    "source": [ "obj-22022", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22020", 4 ],
                    "source": [ "obj-22022", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22020", 3 ],
                    "source": [ "obj-22022", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22020", 2 ],
                    "source": [ "obj-22022", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22020", 1 ],
                    "source": [ "obj-22022", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22026", 0 ],
                    "source": [ "obj-22023", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22025", 0 ],
                    "source": [ "obj-22024", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22023", 5 ],
                    "source": [ "obj-22025", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22023", 4 ],
                    "source": [ "obj-22025", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22023", 3 ],
                    "source": [ "obj-22025", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22023", 2 ],
                    "source": [ "obj-22025", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22023", 1 ],
                    "source": [ "obj-22025", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-711", 0 ],
                    "source": [ "obj-22026", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22028", 0 ],
                    "source": [ "obj-22027", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22026", 5 ],
                    "source": [ "obj-22028", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22026", 4 ],
                    "source": [ "obj-22028", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22026", 3 ],
                    "source": [ "obj-22028", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22026", 2 ],
                    "source": [ "obj-22028", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22026", 1 ],
                    "source": [ "obj-22028", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22031", 0 ],
                    "source": [ "obj-22029", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22029", 1 ],
                    "source": [ "obj-22030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22034", 0 ],
                    "source": [ "obj-22031", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22033", 0 ],
                    "source": [ "obj-22032", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22031", 5 ],
                    "source": [ "obj-22033", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22031", 4 ],
                    "source": [ "obj-22033", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22031", 3 ],
                    "source": [ "obj-22033", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22031", 2 ],
                    "source": [ "obj-22033", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22031", 1 ],
                    "source": [ "obj-22033", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22037", 0 ],
                    "source": [ "obj-22034", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22036", 0 ],
                    "source": [ "obj-22035", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22034", 5 ],
                    "source": [ "obj-22036", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22034", 4 ],
                    "source": [ "obj-22036", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22034", 3 ],
                    "source": [ "obj-22036", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22034", 2 ],
                    "source": [ "obj-22036", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22034", 1 ],
                    "source": [ "obj-22036", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-741", 0 ],
                    "source": [ "obj-22037", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22039", 0 ],
                    "source": [ "obj-22038", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22037", 5 ],
                    "source": [ "obj-22039", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22037", 4 ],
                    "source": [ "obj-22039", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22037", 3 ],
                    "source": [ "obj-22039", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22037", 2 ],
                    "source": [ "obj-22039", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22037", 1 ],
                    "source": [ "obj-22039", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22042", 0 ],
                    "source": [ "obj-22040", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22040", 1 ],
                    "source": [ "obj-22041", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22045", 0 ],
                    "source": [ "obj-22042", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22044", 0 ],
                    "source": [ "obj-22043", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22042", 5 ],
                    "source": [ "obj-22044", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22042", 4 ],
                    "source": [ "obj-22044", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22042", 3 ],
                    "source": [ "obj-22044", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22042", 2 ],
                    "source": [ "obj-22044", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22042", 1 ],
                    "source": [ "obj-22044", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22048", 0 ],
                    "source": [ "obj-22045", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22047", 0 ],
                    "source": [ "obj-22046", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22045", 5 ],
                    "source": [ "obj-22047", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22045", 4 ],
                    "source": [ "obj-22047", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22045", 3 ],
                    "source": [ "obj-22047", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22045", 2 ],
                    "source": [ "obj-22047", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22045", 1 ],
                    "source": [ "obj-22047", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-771", 0 ],
                    "source": [ "obj-22048", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22050", 0 ],
                    "source": [ "obj-22049", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22048", 5 ],
                    "source": [ "obj-22050", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22048", 4 ],
                    "source": [ "obj-22050", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22048", 3 ],
                    "source": [ "obj-22050", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22048", 2 ],
                    "source": [ "obj-22050", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22048", 1 ],
                    "source": [ "obj-22050", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22053", 0 ],
                    "source": [ "obj-22051", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22051", 1 ],
                    "source": [ "obj-22052", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22056", 0 ],
                    "source": [ "obj-22053", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22055", 0 ],
                    "source": [ "obj-22054", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22053", 5 ],
                    "source": [ "obj-22055", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22053", 4 ],
                    "source": [ "obj-22055", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22053", 3 ],
                    "source": [ "obj-22055", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22053", 2 ],
                    "source": [ "obj-22055", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22053", 1 ],
                    "source": [ "obj-22055", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22059", 0 ],
                    "source": [ "obj-22056", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22058", 0 ],
                    "source": [ "obj-22057", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22056", 5 ],
                    "source": [ "obj-22058", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22056", 4 ],
                    "source": [ "obj-22058", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22056", 3 ],
                    "source": [ "obj-22058", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22056", 2 ],
                    "source": [ "obj-22058", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22056", 1 ],
                    "source": [ "obj-22058", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-801", 0 ],
                    "source": [ "obj-22059", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22061", 0 ],
                    "source": [ "obj-22060", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22059", 5 ],
                    "source": [ "obj-22061", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22059", 4 ],
                    "source": [ "obj-22061", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22059", 3 ],
                    "source": [ "obj-22061", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22059", 2 ],
                    "source": [ "obj-22061", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22059", 1 ],
                    "source": [ "obj-22061", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22063", 0 ],
                    "source": [ "obj-22062", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22000", 0 ],
                    "source": [ "obj-22063", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22064", 0 ],
                    "source": [ "obj-22065", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-225", 0 ],
                    "source": [ "obj-222", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-225", 0 ],
                    "source": [ "obj-223", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-332", 0 ],
                    "order": 1,
                    "source": [ "obj-226", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4010", 0 ],
                    "order": 0,
                    "source": [ "obj-226", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-238", 0 ],
                    "source": [ "obj-227", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-23", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-229", 0 ],
                    "source": [ "obj-230", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23001", 1 ],
                    "source": [ "obj-23000", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20008", 0 ],
                    "order": 6,
                    "source": [ "obj-23001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20012", 0 ],
                    "order": 7,
                    "source": [ "obj-23001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20013", 0 ],
                    "order": 5,
                    "source": [ "obj-23001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23009", 0 ],
                    "order": 3,
                    "source": [ "obj-23001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23048", 0 ],
                    "order": 4,
                    "source": [ "obj-23001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23050", 0 ],
                    "order": 2,
                    "source": [ "obj-23001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23052", 0 ],
                    "order": 1,
                    "source": [ "obj-23001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23054", 0 ],
                    "order": 0,
                    "source": [ "obj-23001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6001", 0 ],
                    "order": 8,
                    "source": [ "obj-23001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-230011", 1 ],
                    "source": [ "obj-230010", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23016", 1 ],
                    "source": [ "obj-230011", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-230013", 1 ],
                    "source": [ "obj-230012", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23017", 1 ],
                    "source": [ "obj-230013", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-230015", 1 ],
                    "source": [ "obj-230014", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23018", 1 ],
                    "source": [ "obj-230015", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23003", 1 ],
                    "source": [ "obj-23002", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20018", 0 ],
                    "order": 6,
                    "source": [ "obj-23003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20022", 0 ],
                    "order": 7,
                    "source": [ "obj-23003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20023", 0 ],
                    "order": 4,
                    "source": [ "obj-23003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-230011", 0 ],
                    "order": 5,
                    "source": [ "obj-23003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23056", 0 ],
                    "order": 3,
                    "source": [ "obj-23003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23058", 0 ],
                    "order": 2,
                    "source": [ "obj-23003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23060", 0 ],
                    "order": 1,
                    "source": [ "obj-23003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23062", 0 ],
                    "order": 0,
                    "source": [ "obj-23003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6002", 0 ],
                    "order": 8,
                    "source": [ "obj-23003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23005", 1 ],
                    "source": [ "obj-23004", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20028", 0 ],
                    "order": 5,
                    "source": [ "obj-23005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20032", 0 ],
                    "order": 6,
                    "source": [ "obj-23005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20033", 0 ],
                    "order": 3,
                    "source": [ "obj-23005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-230013", 0 ],
                    "order": 7,
                    "source": [ "obj-23005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23064", 0 ],
                    "order": 4,
                    "source": [ "obj-23005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23066", 0 ],
                    "order": 2,
                    "source": [ "obj-23005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23068", 0 ],
                    "order": 1,
                    "source": [ "obj-23005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23070", 0 ],
                    "order": 0,
                    "source": [ "obj-23005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23007", 1 ],
                    "source": [ "obj-23006", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20038", 0 ],
                    "order": 2,
                    "source": [ "obj-23007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20042", 0 ],
                    "order": 4,
                    "source": [ "obj-23007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20043", 0 ],
                    "order": 0,
                    "source": [ "obj-23007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-230015", 0 ],
                    "order": 7,
                    "source": [ "obj-23007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23072", 0 ],
                    "order": 6,
                    "source": [ "obj-23007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23074", 0 ],
                    "order": 5,
                    "source": [ "obj-23007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23076", 0 ],
                    "order": 3,
                    "source": [ "obj-23007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23078", 0 ],
                    "order": 1,
                    "source": [ "obj-23007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23009", 1 ],
                    "source": [ "obj-23008", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23016", 0 ],
                    "source": [ "obj-23009", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23017", 0 ],
                    "source": [ "obj-23016", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23018", 0 ],
                    "source": [ "obj-23017", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21053", 0 ],
                    "source": [ "obj-23018", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21070", 1 ],
                    "order": 1,
                    "source": [ "obj-23019", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-21071", 1 ],
                    "order": 0,
                    "source": [ "obj-23019", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23030", 0 ],
                    "source": [ "obj-23029", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23031", 0 ],
                    "source": [ "obj-23030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23032", 0 ],
                    "source": [ "obj-23030", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23033", 0 ],
                    "source": [ "obj-23030", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23034", 0 ],
                    "source": [ "obj-23030", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23035", 0 ],
                    "source": [ "obj-23030", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23036", 0 ],
                    "source": [ "obj-23030", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23037", 0 ],
                    "source": [ "obj-23030", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23038", 0 ],
                    "source": [ "obj-23030", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23039", 0 ],
                    "source": [ "obj-23030", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23040", 0 ],
                    "source": [ "obj-23030", 9 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23041", 0 ],
                    "source": [ "obj-23030", 10 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23042", 0 ],
                    "source": [ "obj-23030", 11 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23043", 0 ],
                    "source": [ "obj-23030", 12 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23044", 0 ],
                    "source": [ "obj-23030", 13 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23045", 0 ],
                    "source": [ "obj-23030", 14 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23046", 0 ],
                    "source": [ "obj-23030", 15 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23048", 1 ],
                    "source": [ "obj-23047", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23079", 0 ],
                    "source": [ "obj-23048", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23050", 1 ],
                    "source": [ "obj-23049", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23082", 0 ],
                    "source": [ "obj-23050", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23052", 1 ],
                    "source": [ "obj-23051", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23085", 0 ],
                    "source": [ "obj-23052", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23054", 1 ],
                    "source": [ "obj-23053", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23088", 0 ],
                    "source": [ "obj-23054", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23056", 1 ],
                    "source": [ "obj-23055", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23079", 1 ],
                    "source": [ "obj-23056", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23058", 1 ],
                    "source": [ "obj-23057", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23082", 1 ],
                    "source": [ "obj-23058", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23060", 1 ],
                    "source": [ "obj-23059", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23085", 1 ],
                    "source": [ "obj-23060", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23062", 1 ],
                    "source": [ "obj-23061", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23088", 1 ],
                    "source": [ "obj-23062", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23064", 1 ],
                    "source": [ "obj-23063", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23080", 1 ],
                    "source": [ "obj-23064", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23066", 1 ],
                    "source": [ "obj-23065", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23083", 1 ],
                    "source": [ "obj-23066", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23068", 1 ],
                    "source": [ "obj-23067", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23086", 1 ],
                    "source": [ "obj-23068", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23070", 1 ],
                    "source": [ "obj-23069", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23089", 1 ],
                    "source": [ "obj-23070", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23072", 1 ],
                    "source": [ "obj-23071", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23081", 1 ],
                    "source": [ "obj-23072", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23074", 1 ],
                    "source": [ "obj-23073", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23084", 1 ],
                    "source": [ "obj-23074", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23076", 1 ],
                    "source": [ "obj-23075", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23087", 1 ],
                    "source": [ "obj-23076", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23078", 1 ],
                    "source": [ "obj-23077", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23090", 1 ],
                    "source": [ "obj-23078", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23080", 0 ],
                    "source": [ "obj-23079", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23081", 0 ],
                    "source": [ "obj-23080", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23091", 0 ],
                    "source": [ "obj-23081", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23083", 0 ],
                    "source": [ "obj-23082", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23084", 0 ],
                    "source": [ "obj-23083", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23091", 1 ],
                    "source": [ "obj-23084", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23086", 0 ],
                    "source": [ "obj-23085", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23087", 0 ],
                    "source": [ "obj-23086", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23092", 0 ],
                    "source": [ "obj-23087", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23089", 0 ],
                    "source": [ "obj-23088", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23090", 0 ],
                    "source": [ "obj-23089", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23092", 1 ],
                    "source": [ "obj-23090", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-189", 0 ],
                    "order": 1,
                    "source": [ "obj-232", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-435", 0 ],
                    "order": 0,
                    "source": [ "obj-232", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-232", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-192", 0 ],
                    "order": 1,
                    "source": [ "obj-233", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-321", 0 ],
                    "order": 0,
                    "source": [ "obj-233", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-233", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-181", 0 ],
                    "order": 2,
                    "source": [ "obj-234", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-217", 0 ],
                    "order": 0,
                    "source": [ "obj-234", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-316", 0 ],
                    "order": 1,
                    "source": [ "obj-234", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-234", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-500", 0 ],
                    "source": [ "obj-236", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-230", 0 ],
                    "source": [ "obj-237", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-237", 0 ],
                    "midpoints": [ 3819.5074026584625, 2107.3754988908768, 3819.5074026584625, 2107.3754988908768 ],
                    "source": [ "obj-238", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-334", 0 ],
                    "source": [ "obj-243", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-28", 0 ],
                    "order": 1,
                    "source": [ "obj-25", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-37", 1 ],
                    "source": [ "obj-25", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-37", 0 ],
                    "source": [ "obj-25", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-44", 0 ],
                    "order": 0,
                    "source": [ "obj-25", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-333", 0 ],
                    "source": [ "obj-250", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4003", 0 ],
                    "order": 0,
                    "source": [ "obj-253", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-432", 0 ],
                    "order": 1,
                    "source": [ "obj-253", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-434", 0 ],
                    "source": [ "obj-254", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-263", 0 ],
                    "source": [ "obj-258", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4030", 0 ],
                    "source": [ "obj-26", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-260", 0 ],
                    "source": [ "obj-261", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-261", 0 ],
                    "source": [ "obj-262", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-262", 0 ],
                    "midpoints": [ 3208.2397890090942, 2120.539102613926, 3208.2397890090942, 2120.539102613926 ],
                    "source": [ "obj-263", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-265", 0 ],
                    "source": [ "obj-264", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-266", 0 ],
                    "source": [ "obj-264", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-269", 0 ],
                    "source": [ "obj-265", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-269", 0 ],
                    "source": [ "obj-266", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-30", 0 ],
                    "source": [ "obj-27", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-134", 0 ],
                    "source": [ "obj-270", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-433", 0 ],
                    "source": [ "obj-271", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-280", 0 ],
                    "source": [ "obj-275", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-277", 0 ],
                    "source": [ "obj-278", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-278", 0 ],
                    "source": [ "obj-279", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-709", 0 ],
                    "source": [ "obj-28", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-279", 0 ],
                    "midpoints": [ 2667.394711494446, 2128.960155546665, 2667.394711494446, 2128.960155546665 ],
                    "source": [ "obj-280", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-283", 0 ],
                    "source": [ "obj-281", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-284", 0 ],
                    "source": [ "obj-281", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-286", 0 ],
                    "source": [ "obj-283", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-286", 0 ],
                    "source": [ "obj-284", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-135", 0 ],
                    "source": [ "obj-299", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4002", 0 ],
                    "source": [ "obj-30", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-226", 0 ],
                    "order": 0,
                    "source": [ "obj-300", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-310", 0 ],
                    "order": 1,
                    "source": [ "obj-300", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-297", 0 ],
                    "source": [ "obj-301", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-304", 0 ],
                    "source": [ "obj-302", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-305", 0 ],
                    "source": [ "obj-303", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-339", 0 ],
                    "order": 0,
                    "source": [ "obj-305", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4009", 0 ],
                    "order": 1,
                    "source": [ "obj-305", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-305", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-308", 0 ],
                    "source": [ "obj-306", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-309", 0 ],
                    "source": [ "obj-307", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-335", 0 ],
                    "order": 0,
                    "source": [ "obj-309", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4016", 0 ],
                    "order": 1,
                    "source": [ "obj-309", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-309", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-313", 0 ],
                    "source": [ "obj-312", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-313", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-317", 0 ],
                    "source": [ "obj-315", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-318", 0 ],
                    "source": [ "obj-316", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-330", 0 ],
                    "order": 0,
                    "source": [ "obj-318", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4023", 0 ],
                    "order": 1,
                    "source": [ "obj-318", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-318", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-150", 0 ],
                    "source": [ "obj-321", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-151", 0 ],
                    "source": [ "obj-321", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-144", 0 ],
                    "source": [ "obj-322", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-145", 0 ],
                    "source": [ "obj-322", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-138", 0 ],
                    "source": [ "obj-323", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-139", 0 ],
                    "source": [ "obj-323", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-115", 0 ],
                    "source": [ "obj-325", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-117", 0 ],
                    "source": [ "obj-325", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-133", 0 ],
                    "source": [ "obj-327", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-317", 0 ],
                    "source": [ "obj-329", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-16", 3 ],
                    "source": [ "obj-33", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-315", 0 ],
                    "source": [ "obj-330", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-329", 0 ],
                    "source": [ "obj-330", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-250", 0 ],
                    "order": 1,
                    "source": [ "obj-332", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-430", 0 ],
                    "order": 0,
                    "source": [ "obj-332", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-332", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-243", 0 ],
                    "order": 1,
                    "source": [ "obj-333", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-322", 0 ],
                    "order": 0,
                    "source": [ "obj-333", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-333", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-220", 0 ],
                    "order": 0,
                    "source": [ "obj-334", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-227", 0 ],
                    "order": 2,
                    "source": [ "obj-334", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-307", 0 ],
                    "order": 1,
                    "source": [ "obj-334", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-334", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-306", 0 ],
                    "source": [ "obj-335", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-337", 0 ],
                    "source": [ "obj-335", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-500", 0 ],
                    "source": [ "obj-336", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-308", 0 ],
                    "source": [ "obj-337", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-304", 0 ],
                    "source": [ "obj-338", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-302", 0 ],
                    "source": [ "obj-339", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-338", 0 ],
                    "source": [ "obj-339", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-297", 0 ],
                    "source": [ "obj-340", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-301", 0 ],
                    "source": [ "obj-341", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-340", 0 ],
                    "source": [ "obj-341", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-356", 0 ],
                    "order": 0,
                    "source": [ "obj-346", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-85", 0 ],
                    "order": 1,
                    "source": [ "obj-346", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-346", 0 ],
                    "source": [ "obj-347", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-84", 0 ],
                    "source": [ "obj-350", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-350", 0 ],
                    "source": [ "obj-351", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-352", 0 ],
                    "source": [ "obj-353", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-352", 0 ],
                    "source": [ "obj-355", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-353", 0 ],
                    "source": [ "obj-356", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-355", 0 ],
                    "source": [ "obj-356", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-33", 1 ],
                    "source": [ "obj-36", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-70", 0 ],
                    "source": [ "obj-364", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-71", 0 ],
                    "source": [ "obj-364", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-372", 0 ],
                    "source": [ "obj-369", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-710", 0 ],
                    "source": [ "obj-37", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4007", 0 ],
                    "source": [ "obj-371", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4008", 0 ],
                    "source": [ "obj-371", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-385", 0 ],
                    "source": [ "obj-372", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-36", 0 ],
                    "source": [ "obj-38", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4014", 0 ],
                    "source": [ "obj-386", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4015", 0 ],
                    "source": [ "obj-386", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-389", 0 ],
                    "source": [ "obj-387", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-404", 0 ],
                    "source": [ "obj-389", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-33", 1 ],
                    "source": [ "obj-39", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-41", 1 ],
                    "source": [ "obj-4", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-41", 0 ],
                    "source": [ "obj-4", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-253", 0 ],
                    "order": 1,
                    "source": [ "obj-400", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-410", 0 ],
                    "order": 0,
                    "source": [ "obj-400", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-500", 0 ],
                    "source": [ "obj-4002", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-109", 0 ],
                    "order": 1,
                    "source": [ "obj-4006", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-371", 0 ],
                    "order": 0,
                    "source": [ "obj-4006", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-370", 0 ],
                    "source": [ "obj-4007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-370", 0 ],
                    "source": [ "obj-4008", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4006", 0 ],
                    "source": [ "obj-4009", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-122", 0 ],
                    "order": 1,
                    "source": [ "obj-4013", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-386", 0 ],
                    "order": 0,
                    "source": [ "obj-4013", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-388", 0 ],
                    "source": [ "obj-4014", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-388", 0 ],
                    "source": [ "obj-4015", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4013", 0 ],
                    "source": [ "obj-4016", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-158", 0 ],
                    "order": 1,
                    "source": [ "obj-4020", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-425", 0 ],
                    "order": 0,
                    "source": [ "obj-4020", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-406", 0 ],
                    "source": [ "obj-4021", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-406", 0 ],
                    "source": [ "obj-4022", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4020", 0 ],
                    "source": [ "obj-4023", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-20100", 0 ],
                    "order": 3,
                    "source": [ "obj-4030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22000", 0 ],
                    "order": 2,
                    "source": [ "obj-4030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23029", 0 ],
                    "order": 0,
                    "source": [ "obj-4030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4031", 0 ],
                    "source": [ "obj-4030", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4041", 0 ],
                    "order": 1,
                    "source": [ "obj-4030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5011", 0 ],
                    "order": 5,
                    "source": [ "obj-4030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7014", 0 ],
                    "order": 6,
                    "source": [ "obj-4030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "order": 4,
                    "source": [ "obj-4030", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4030", 0 ],
                    "source": [ "obj-4032", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4030", 0 ],
                    "source": [ "obj-4033", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4039", 0 ],
                    "source": [ "obj-4038", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4030", 0 ],
                    "source": [ "obj-4039", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4042", 0 ],
                    "source": [ "obj-4041", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4043", 0 ],
                    "source": [ "obj-4041", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4044", 0 ],
                    "source": [ "obj-4041", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4045", 0 ],
                    "source": [ "obj-4041", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4046", 0 ],
                    "source": [ "obj-4041", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4047", 0 ],
                    "source": [ "obj-4041", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4048", 0 ],
                    "source": [ "obj-4041", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4049", 0 ],
                    "source": [ "obj-4041", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4050", 0 ],
                    "source": [ "obj-4041", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4051", 0 ],
                    "source": [ "obj-4041", 9 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4052", 0 ],
                    "source": [ "obj-4041", 10 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4053", 0 ],
                    "source": [ "obj-4041", 11 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4054", 0 ],
                    "source": [ "obj-4041", 12 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4055", 0 ],
                    "source": [ "obj-4041", 13 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4056", 0 ],
                    "source": [ "obj-4041", 14 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4057", 0 ],
                    "source": [ "obj-4041", 15 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4058", 0 ],
                    "source": [ "obj-4041", 16 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4059", 0 ],
                    "source": [ "obj-4041", 17 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4060", 0 ],
                    "source": [ "obj-4041", 18 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4061", 0 ],
                    "source": [ "obj-4041", 19 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4066", 0 ],
                    "source": [ "obj-4041", 20 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4067", 0 ],
                    "source": [ "obj-4041", 21 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4068", 0 ],
                    "source": [ "obj-4041", 22 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4069", 0 ],
                    "source": [ "obj-4041", 23 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4041", 24 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4042", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4043", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4044", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4045", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4046", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4047", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4048", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4049", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-424", 0 ],
                    "source": [ "obj-405", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4050", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4051", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4052", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4053", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4054", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4055", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4056", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4057", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4058", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4059", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4060", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4061", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4065", 0 ],
                    "source": [ "obj-4064", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9974", 0 ],
                    "source": [ "obj-4065", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9975", 0 ],
                    "source": [ "obj-4065", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9976", 0 ],
                    "source": [ "obj-4065", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9977", 0 ],
                    "source": [ "obj-4065", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4066", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-500", 0 ],
                    "order": 1,
                    "source": [ "obj-4067", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-501", 0 ],
                    "order": 0,
                    "source": [ "obj-4067", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9982", 0 ],
                    "source": [ "obj-4068", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-4069", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-39", 0 ],
                    "source": [ "obj-41", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-413", 0 ],
                    "source": [ "obj-412", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-413", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-423", 0 ],
                    "source": [ "obj-424", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4021", 0 ],
                    "source": [ "obj-425", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4022", 0 ],
                    "source": [ "obj-425", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-132", 0 ],
                    "order": 1,
                    "source": [ "obj-426", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-357", 0 ],
                    "order": 0,
                    "source": [ "obj-426", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-106", 0 ],
                    "source": [ "obj-429", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-107", 0 ],
                    "source": [ "obj-429", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-710", 0 ],
                    "source": [ "obj-43", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-96", 0 ],
                    "source": [ "obj-430", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-97", 0 ],
                    "source": [ "obj-430", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-271", 0 ],
                    "order": 1,
                    "source": [ "obj-432", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-429", 0 ],
                    "order": 0,
                    "source": [ "obj-432", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-432", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-254", 0 ],
                    "order": 1,
                    "source": [ "obj-433", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-323", 0 ],
                    "order": 0,
                    "source": [ "obj-433", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-433", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-258", 0 ],
                    "order": 2,
                    "source": [ "obj-434", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-264", 0 ],
                    "order": 0,
                    "source": [ "obj-434", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-303", 0 ],
                    "order": 1,
                    "source": [ "obj-434", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-fluerr", 0 ],
                    "source": [ "obj-434", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-89", 0 ],
                    "source": [ "obj-435", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-90", 0 ],
                    "source": [ "obj-435", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-500", 0 ],
                    "source": [ "obj-436", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4038", 0 ],
                    "order": 0,
                    "source": [ "obj-437", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9902", 0 ],
                    "order": 1,
                    "source": [ "obj-437", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-710", 0 ],
                    "source": [ "obj-44", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-15", 0 ],
                    "source": [ "obj-5", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-41", 0 ],
                    "source": [ "obj-50", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-100", 0 ],
                    "order": 1,
                    "source": [ "obj-500", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-16", 0 ],
                    "source": [ "obj-500", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-200", 0 ],
                    "order": 1,
                    "source": [ "obj-500", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-245", 1 ],
                    "order": 0,
                    "source": [ "obj-500", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-247", 1 ],
                    "order": 0,
                    "source": [ "obj-500", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-248", 1 ],
                    "order": 0,
                    "source": [ "obj-500", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-249", 1 ],
                    "order": 0,
                    "source": [ "obj-500", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-300", 0 ],
                    "order": 1,
                    "source": [ "obj-500", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4", 0 ],
                    "source": [ "obj-500", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-400", 0 ],
                    "order": 1,
                    "source": [ "obj-500", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-501", 0 ],
                    "source": [ "obj-500", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6001", 0 ],
                    "source": [ "obj-500", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5001", 0 ],
                    "source": [ "obj-5000", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5002", 0 ],
                    "source": [ "obj-5001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5003", 0 ],
                    "order": 0,
                    "source": [ "obj-5002", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7005", 0 ],
                    "order": 1,
                    "source": [ "obj-5002", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5005", 1 ],
                    "source": [ "obj-5003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5006", 1 ],
                    "source": [ "obj-5003", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5005", 0 ],
                    "order": 1,
                    "source": [ "obj-5004", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5006", 0 ],
                    "order": 0,
                    "source": [ "obj-5004", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5007", 1 ],
                    "source": [ "obj-5005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5007", 0 ],
                    "source": [ "obj-5006", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5008", 0 ],
                    "source": [ "obj-5007", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7013", 1 ],
                    "source": [ "obj-5008", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9903", 0 ],
                    "source": [ "obj-501", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5004", 0 ],
                    "source": [ "obj-5011", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22018", 0 ],
                    "order": 1,
                    "source": [ "obj-5100", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5000", 0 ],
                    "order": 0,
                    "source": [ "obj-5100", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22029", 0 ],
                    "order": 1,
                    "source": [ "obj-5101", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5000", 1 ],
                    "order": 0,
                    "source": [ "obj-5101", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22040", 0 ],
                    "order": 0,
                    "source": [ "obj-5102", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5001", 1 ],
                    "order": 1,
                    "source": [ "obj-5102", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22051", 0 ],
                    "order": 0,
                    "source": [ "obj-5103", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5002", 1 ],
                    "order": 1,
                    "source": [ "obj-5103", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-739", 0 ],
                    "source": [ "obj-53", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-53", 0 ],
                    "order": 1,
                    "source": [ "obj-54", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-55", 0 ],
                    "order": 0,
                    "source": [ "obj-54", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-57", 1 ],
                    "source": [ "obj-54", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-57", 0 ],
                    "source": [ "obj-54", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4032", 0 ],
                    "order": 0,
                    "source": [ "obj-544", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "order": 1,
                    "source": [ "obj-544", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4033", 0 ],
                    "order": 0,
                    "source": [ "obj-546", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "order": 1,
                    "source": [ "obj-546", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-740", 0 ],
                    "source": [ "obj-55", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4030", 0 ],
                    "order": 0,
                    "source": [ "obj-551", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4064", 0 ],
                    "order": 1,
                    "source": [ "obj-551", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "order": 2,
                    "source": [ "obj-551", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-551", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-740", 0 ],
                    "source": [ "obj-56", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-740", 0 ],
                    "source": [ "obj-57", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-800", 0 ],
                    "source": [ "obj-58", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-800", 0 ],
                    "source": [ "obj-59", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-168", 0 ],
                    "source": [ "obj-6", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-800", 0 ],
                    "source": [ "obj-60", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-6002", 0 ],
                    "source": [ "obj-6001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7013", 1 ],
                    "source": [ "obj-6002", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-58", 0 ],
                    "order": 0,
                    "source": [ "obj-61", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-60", 1 ],
                    "source": [ "obj-61", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-60", 0 ],
                    "source": [ "obj-61", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-63", 0 ],
                    "order": 1,
                    "source": [ "obj-61", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-799", 0 ],
                    "source": [ "obj-63", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-128", 0 ],
                    "source": [ "obj-69", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4039", 0 ],
                    "source": [ "obj-7", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22", 0 ],
                    "source": [ "obj-70", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7008", 0 ],
                    "source": [ "obj-7001", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7009", 0 ],
                    "source": [ "obj-7002", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7010", 0 ],
                    "source": [ "obj-7003", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7011", 0 ],
                    "source": [ "obj-7004", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7012", 0 ],
                    "source": [ "obj-7005", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7013", 1 ],
                    "source": [ "obj-7008", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7013", 1 ],
                    "source": [ "obj-7009", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7013", 1 ],
                    "source": [ "obj-7010", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7013", 1 ],
                    "source": [ "obj-7011", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7013", 1 ],
                    "source": [ "obj-7012", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-4030", 0 ],
                    "source": [ "obj-7013", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7015", 0 ],
                    "source": [ "obj-7014", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7013", 0 ],
                    "source": [ "obj-7015", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-709", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-22", 0 ],
                    "source": [ "obj-71", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5100", 0 ],
                    "order": 0,
                    "source": [ "obj-710", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7001", 0 ],
                    "order": 1,
                    "source": [ "obj-710", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23001", 0 ],
                    "source": [ "obj-711", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-739", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5101", 0 ],
                    "order": 0,
                    "source": [ "obj-740", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7002", 0 ],
                    "order": 1,
                    "source": [ "obj-740", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23003", 0 ],
                    "source": [ "obj-741", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-136", 0 ],
                    "order": 0,
                    "source": [ "obj-75", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-86", 0 ],
                    "order": 1,
                    "source": [ "obj-75", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5102", 0 ],
                    "order": 0,
                    "source": [ "obj-770", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7003", 0 ],
                    "order": 1,
                    "source": [ "obj-770", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23005", 0 ],
                    "source": [ "obj-771", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-551", 0 ],
                    "source": [ "obj-799", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-14", 0 ],
                    "order": 1,
                    "source": [ "obj-8", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-16", 0 ],
                    "source": [ "obj-8", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-33", 0 ],
                    "source": [ "obj-8", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-41", 0 ],
                    "source": [ "obj-8", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9921", 0 ],
                    "order": 0,
                    "source": [ "obj-8", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5103", 0 ],
                    "order": 0,
                    "source": [ "obj-800", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7004", 0 ],
                    "order": 1,
                    "source": [ "obj-800", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-23007", 0 ],
                    "source": [ "obj-801", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-75", 0 ],
                    "source": [ "obj-85", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-87", 0 ],
                    "source": [ "obj-86", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-91", 0 ],
                    "source": [ "obj-86", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-93", 0 ],
                    "source": [ "obj-87", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-88", 0 ],
                    "source": [ "obj-89", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-88", 0 ],
                    "source": [ "obj-90", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-93", 0 ],
                    "source": [ "obj-91", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-99", 0 ],
                    "source": [ "obj-96", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-99", 0 ],
                    "source": [ "obj-97", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-101", 0 ],
                    "source": [ "obj-98", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-102", 0 ],
                    "source": [ "obj-98", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9903", 0 ],
                    "source": [ "obj-9902", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9930", 0 ],
                    "source": [ "obj-9903", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9911", 0 ],
                    "source": [ "obj-9910", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9912", 0 ],
                    "source": [ "obj-9911", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9913", 0 ],
                    "source": [ "obj-9911", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9903", 0 ],
                    "source": [ "obj-9912", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9903", 0 ],
                    "source": [ "obj-9913", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-500", 0 ],
                    "source": [ "obj-9920", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-500", 0 ],
                    "source": [ "obj-9921", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-7013", 1 ],
                    "source": [ "obj-9922", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-500", 0 ],
                    "source": [ "obj-9930", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10013", 0 ],
                    "source": [ "obj-9961", 14 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10014", 0 ],
                    "source": [ "obj-9961", 15 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10015", 0 ],
                    "source": [ "obj-9961", 16 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10016", 0 ],
                    "source": [ "obj-9961", 17 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9970", 0 ],
                    "source": [ "obj-9961", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9971", 0 ],
                    "source": [ "obj-9961", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9972", 0 ],
                    "source": [ "obj-9961", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9973", 0 ],
                    "source": [ "obj-9961", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9978", 0 ],
                    "source": [ "obj-9961", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9979", 0 ],
                    "source": [ "obj-9961", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9980", 0 ],
                    "source": [ "obj-9961", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9981", 0 ],
                    "source": [ "obj-9961", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9982", 0 ],
                    "source": [ "obj-9961", 12 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9992", 0 ],
                    "source": [ "obj-9961", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9993", 0 ],
                    "source": [ "obj-9961", 9 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9994", 0 ],
                    "source": [ "obj-9961", 10 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9995", 0 ],
                    "source": [ "obj-9961", 11 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9974", 0 ],
                    "order": 0,
                    "source": [ "obj-9970", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9997", 0 ],
                    "order": 1,
                    "source": [ "obj-9970", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9975", 0 ],
                    "order": 0,
                    "source": [ "obj-9971", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9999", 0 ],
                    "order": 1,
                    "source": [ "obj-9971", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10001", 0 ],
                    "order": 1,
                    "source": [ "obj-9972", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9976", 0 ],
                    "order": 0,
                    "source": [ "obj-9972", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10003", 0 ],
                    "order": 1,
                    "source": [ "obj-9973", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9977", 0 ],
                    "order": 0,
                    "source": [ "obj-9973", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-112", 0 ],
                    "source": [ "obj-9974", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-412", 0 ],
                    "source": [ "obj-9975", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-312", 0 ],
                    "source": [ "obj-9976", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-212", 0 ],
                    "source": [ "obj-9977", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9998", 0 ],
                    "source": [ "obj-9978", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10000", 0 ],
                    "source": [ "obj-9979", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10002", 0 ],
                    "source": [ "obj-9980", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10004", 0 ],
                    "source": [ "obj-9981", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-172", 0 ],
                    "source": [ "obj-9982", 7 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-187", 1 ],
                    "source": [ "obj-9982", 8 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-25", 0 ],
                    "source": [ "obj-9982", 1 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-28", 1 ],
                    "source": [ "obj-9982", 2 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5100", 1 ],
                    "source": [ "obj-9982", 16 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5101", 1 ],
                    "source": [ "obj-9982", 17 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5102", 1 ],
                    "source": [ "obj-9982", 18 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-5103", 1 ],
                    "source": [ "obj-9982", 19 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-53", 1 ],
                    "source": [ "obj-9982", 11 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-54", 0 ],
                    "source": [ "obj-9982", 10 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-61", 0 ],
                    "source": [ "obj-9982", 4 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-63", 1 ],
                    "source": [ "obj-9982", 5 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-710", 1 ],
                    "source": [ "obj-9982", 12 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-710", 0 ],
                    "source": [ "obj-9982", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-740", 1 ],
                    "source": [ "obj-9982", 15 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-740", 0 ],
                    "source": [ "obj-9982", 9 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-770", 1 ],
                    "source": [ "obj-9982", 14 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-770", 0 ],
                    "source": [ "obj-9982", 6 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-800", 1 ],
                    "source": [ "obj-9982", 13 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-800", 0 ],
                    "source": [ "obj-9982", 3 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10005", 0 ],
                    "source": [ "obj-9992", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10006", 0 ],
                    "source": [ "obj-9993", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10007", 0 ],
                    "source": [ "obj-9994", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-10008", 0 ],
                    "source": [ "obj-9995", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-9997", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-9998", 0 ]
                }
            },
            {
                "patchline": {
                    "destination": [ "obj-9961", 0 ],
                    "source": [ "obj-9999", 0 ]
                }
            }
        ],
        "autosave": 0
    }
}