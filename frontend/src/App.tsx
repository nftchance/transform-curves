import { useMemo, useState } from 'react'

import Circle from './types/Circle';
import Preset from './types/Preset';

import CircleChart from './circle/CircleChart';
import CirclePanel from './circle/CirclePanel';

import './App.css'

const App = () => {
    const presets = [
        {
            name: 'Egocentric',
            circles: [
                { id: 0, radius: 1, frequency: 0, phase: 1 },
                { id: 1, radius: 1, frequency: 0.85, phase: 0 },
            ],
        }, { 
            name: 'Exponential',
            circles: [
                { id: 0, radius: 1, frequency: 0, phase: 0 },
                { id: 1, radius: 1, frequency: 0.25, phase: 270 },
            ],
        }, {
            name: 'Linear',
            circles: [
                { id: 0, radius: 1, frequency: 0, phase: 0 },
                { id: 1, radius: 3.8, frequency: 0.15, phase: 0 },
            ],
        }, {
            name: 'S',
            circles: [
                { id: 0, radius: 1, frequency: 1.8, phase: 270 },
                { id: 1, radius: 1, frequency: 0, phase: 0 },
            ]     
        }, {
            name: 'Two-Tier',
            circles: [
                { id: 0, radius: 1, frequency: 1.8, phase: 270 },
                { id: 1, radius: 5, frequency: 0.5, phase: 11 },
                { id: 2, radius: 1, frequency: 4, phase: 3 },
            ]
        }, {
            name: 'Custom',
            circles: []
        }
    ]

    const [N, setN] = useState(100);
    const [start, setStart] = useState(0);
    const [end, setEnd] = useState(2 * Math.PI);
    const [preset, setPreset] = useState<Preset>(presets[0])
    const [circles, setCircles] = useState<Circle[]>(presets[0].circles);

    presets[presets.length - 1] = useMemo(() => { 
        return {
            name: 'Custom',
            circles: circles
        }
    }, [circles]);

    const handlePresetChange = (preset: string) => {
        const presetObj = presets.find(p => p.name === preset)!;

        setPreset(presetObj)
        setCircles(presetObj.circles)
    }

    return (
        <>
            <div className="chart">
                <CircleChart 
                    N={N}
                    start={start}
                    end={end}
                    circles={circles} 
                />
            </div>
            <div className="controls">
                <CirclePanel
                    preset={preset}
                    presets={presets}
                    N={N}
                    start={start}
                    end={end}
                    circles={circles}
                    handlePresetChange={handlePresetChange}
                    setN={setN}
                    setStart={setStart}
                    setEnd={setEnd}
                    setCircles={setCircles}
                />
            </div>
        </>
    )
}

export default App
