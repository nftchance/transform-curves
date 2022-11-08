import { useMemo } from 'react';

import { AxisOptions, Chart } from 'react-charts';

import Circle from "../types/Circle";

const CircleChart = ({
    N,
    circles
}: {
    N: number,
    circles: Circle[]
}) => {
    const points = useMemo(() => {
        const points: number[][] = [];

        for (let i = 0; i < N; i++) {
            let y = 0;
            let x = i;
            circles.forEach((circle) => {
                y += circle.radius * Math.sin((circle.frequency * i + circle.phase) * Math.PI / 180);
            });

            points.push([x, y]);
        }

        console.log(points)

        return points;
    }, [N, circles]);

    type Points = {
        x: number,
        y: number,
    }

    type Series = {
        label: string,
        data: Points[]
    }

    const data: Series[] = [
        {
            label: 'Pay Curve',
            data: [
                ...points.map((point) => {
                    return {
                        x: point[0],
                        y: point[1]
                    }
                })
            ]
        }
    ]

    const primaryAxis = useMemo(
        (): AxisOptions<Points> => ({
            getValue: datum => datum.x,
        }),
        []
    )

    const secondaryAxes = useMemo(
        (): AxisOptions<Points>[] => [
            {
                getValue: datum => datum.y,
            },
        ],
        []
    )

    return (
        <>
            <Chart
                options={{
                    data,
                    primaryAxis,
                    secondaryAxes,
                }}
            />
        </>
    )
}

export default CircleChart;