import { useState } from 'react'

import Circle from './types/Circle';

import CirclePanel from './circle/CirclePanel';

import './App.css'

const App = () => {
    const [circles, setCircles] = useState<Circle[]>([{
        id: 0,
        radius: 1,
        frequency: 1,
        phase: 0
    }])

    return (
        <>
            <div className="chart"></div>
            <div className="controls">
                <CirclePanel
                    circles={circles}
                    setCircles={setCircles}
                />
            </div>
        </>
    )
}

export default App
