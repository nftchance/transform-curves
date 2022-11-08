import Circle from '../types/Circle';
import Preset from '../types/Preset';

import CircleInput from './CircleInput'

const CirclePanel = ({
    preset,
    presets,
    N,
    circles,
    handlePresetChange,
    setN,
    setCircles,
}: {
    preset: Preset,
    presets: Preset[],
    N: number,
    circles: Circle[],
    handlePresetChange: (preset: string) => void,
    setN: (N: number) => void,
    setCircles: (circles: Circle[]) => void,
}) => {
    const handleCircleAddition = () => {
        handlePresetChange('Custom');

        const newCircle = {
            id: circles.length,
            radius: 1,
            frequency: 1,
            phase: 0
        }
        setCircles([...circles, newCircle]);
    }

    const handleCircleChange = (id: number, key: string, value: string) => {
        handlePresetChange('Custom');

        const newCircles = circles.map(circle => {
            if (circle.id === id) {
                return {
                    ...circle,
                    [key]: Number(value)
                }
            }
            return circle;
        })
        setCircles(newCircles);
    }

    const handleCircleRemove = (id: number) => {
        setCircles(circles.filter(circle => circle.id !== id));
    }

    return (
        <div className="control-knobs">
            {/* Button to add circle */}
            <button onClick={handleCircleAddition}>Add circle</button>

            <div className="form-group" style={{
                gridTemplateColumns: "1fr"
            }}>
                <div className="input-group">
                    <label htmlFor="Preset">Preset</label>
                    <select 
                        id="Preset"
                        value={preset.name}
                        onChange={(e) => { handlePresetChange(e.target.value) }}
                    >
                        {presets.map(preset => (
                            <option key={preset.name}>{preset.name}</option>
                        ))}
                    </select>
                </div>
            </div>

            <div className="form-group" style={{
                gridTemplateColumns: "1fr"
            }}>
                <div className="input-group">
                    <label htmlFor="N">N</label>
                    <input
                        type="number"
                        id="N"
                        min="2"
                        max="90"
                        value={N}
                        onChange={(e) => { setN(Number(e.target.value)) }}
                    />
                </div>
            </div>

            {/* Loop through all of the circles and create inputs */}
            {circles.map(circle => (
                <CircleInput
                    key={circle.id}
                    circle={circle}
                    handleCircleChange={handleCircleChange}
                    handleCircleRemove={handleCircleRemove}
                />
            ))}
        </div>
    )
}

export default CirclePanel;