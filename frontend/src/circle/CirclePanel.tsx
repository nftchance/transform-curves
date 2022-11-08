import Circle from '../types/Circle';

import CircleInput from './CircleInput'


const CirclePanel = ({ 
    circles,
    setCircles,
}: {
    circles: Circle[],
    setCircles: (circles: Circle[]) => void,
}) => { 
    const handleCircleAddition = () => {
        const newCircle = {
            id: circles.length,
            radius: 1,
            frequency: 1,
            phase: 0
        }
        setCircles([...circles, newCircle]);
    }

    const handleCircleChange = (id: number, key: string, value: string) => {
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