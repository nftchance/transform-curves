import { useMemo } from 'react';

import { AxisOptions, Chart } from 'react-charts';

import Circle from "../types/Circle";

const CircleChart = ({
    N,
    start,
    end,
    circles
}: {
    N: number,
    start: number,
    end: number,
    circles: Circle[]
}) => {
    const points = useMemo(() => {
        const points: number[][] = [];

        const step = end / N;

        // create x-axis array with equidistance points between start and end
        const x = Array.from({ length: N }, (_, i) => start + i * step);

        for (let i = 0; i < N; i++) {
            let y = 0;
            circles.forEach((circle) => {
                y += circle.radius * Math.sin((circle.frequency * x[i] + circle.phase) * Math.PI / 180);
            });

            points.push([x[i], y]);
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