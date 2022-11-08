import Circle from '../types/Circle';

const CircleInput = ({ 
    circle, 
    handleCircleChange,
    handleCircleRemove 
}: { 
    circle: Circle, 
    handleCircleChange: (id: number, key: string, value: string) => void,
    handleCircleRemove: (id: number) => void 
}) => {
    return (
        <div
            key={circle.id}
            className="form-group"
        >
            <div className="input-group">
                <label htmlFor="radius">Radius</label>
                <input
                    type="number"
                    id="radius"
                    min="1"
                    max="100"
                    value={circle.radius}
                    onChange={(e) => { handleCircleChange(circle.id, 'radius', e.target.value) }}
                />
            </div>

            <div className="input-group">
                <label htmlFor="frequency">Frequency</label>
                <input
                    type="number"
                    id="frequency"
                    min="0"
                    max="10000"
                    value={circle.frequency}
                    onChange={(e) => { handleCircleChange(circle.id, 'frequency', e.target.value) }}
                />
            </div>

            <div className="input-group">
                <label htmlFor="phase">Phase (degrees)</label>
                <input
                    type="number"
                    id="phase"
                    min="0"
                    max="360"
                    value={circle.phase}
                    onChange={(e) => { handleCircleChange(circle.id, 'phase', e.target.value) }}
                />
            </div>

            <div className="input-group-button">
                <button onClick={() => handleCircleRemove(circle.id)}>remove</button>
            </div>
        </div>
    )
}

export default CircleInput;