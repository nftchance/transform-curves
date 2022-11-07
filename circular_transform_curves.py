# Implement the use of fourier transforms that takes an array of circles and plots a curve

import numpy as np
import matplotlib.pyplot as plt

# Define the number of points to plot
N = 5

circles = [
    {
        'radius': 1,
        'frequency': 1,
        'phase': 0
    },
    {
        'radius': 1,
        'frequency': 2,
        'phase': 0
    },
    {
        'radius': 1,
        'frequency': 3,
        'phase': 0
    }
]

# Define the x values
x = np.linspace(0, 2 * np.pi, N)

# Define the y values
y = np.zeros(N)

# Add the circles
for circle in circles:
    y += circle['radius'] * circle['frequency'] * x + circle['phase']

# zip coords together
coords = zip(x, y)

for coord in coords:
    print(coord[0], coord[1])

# Plot the curve
plt.plot(x, y)
plt.show()