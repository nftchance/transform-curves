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
            name: 'Custom',
            circles: []
        }
    ]

    const [N, setN] = useState(100);
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
                    circles={circles} 
                />
            </div>
            <div className="controls">
                <CirclePanel
                    preset={preset}
                    presets={presets}
                    N={N}
                    circles={circles}
                    handlePresetChange={handlePresetChange}
                    setN={setN}
                    setCircles={setCircles}
                />
            </div>
        </>
    )
}

export default App
