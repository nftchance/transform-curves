# Implement the use of fourier transforms that takes an array of circles and plots a curve

import numpy as np
import matplotlib.pyplot as plt

# Define the number of points to plot

# Generate the dictionary for a flat curve with N participants and a radius of 1
def flat(target_val):
    # This needs to take a target value and return an array of circles
    # that supports a flat curve of N points that evaluates to the target value

    # Define the number of circles
    N = 2

    # Define the circles
    circles = [
        {'radius': 1, 'frequency': 0, 'phase': 1},
        {'radius': 3, 'frequency': 1, 'phase': 0}
    ]

    # Return the circles
    return N, circles

# Generate the dictionary for a flat curve with N participants and a radius of 1
def rising_tide(target_val):
    # This needs to take a target value and return an array of circles
    # that supports a flat curve of N points that evaluates to the target value

    # Define the number of circles
    N = 100

    # Define the circles
    circles = [
        {'radius': 1, 'frequency': 0, 'phase': 1},
        {'radius': 3, 'frequency': .25, 'phase': 0}
    ]

    # Return the circles
    return N, circles

# Generate the dictionary for a flat curve with N participants and a radius of 1
def mountain(target_val):
    # This needs to take a target value and return an array of circles
    # that supports a flat curve of N points that evaluates to the target value

    # Define the number of circles
    N = 4

    # Define the circles
    circles = [
        {'radius': 1, 'frequency': 0, 'phase': 1},
        {'radius': 1, 'frequency': .85, 'phase': 0}
    ]

    # Return the circles
    return N, circles

def eval(N, circles):
    # Define the x values
    x = np.linspace(0, 2 * np.pi, N)

    # Define the y values
    y = np.zeros(N)

    # Add the circles
    for circle in circles:
        y += circle['radius'] * np.sin(circle['frequency'] * x + circle['phase'])

    # zip coords together
    coords = zip(x, y)
    # change tuples to arrays
    coords = [[_coord for _coord in coord] for coord in coords]
    # convert coords to a list
    coords = list(coords)

    print(coords)

    # Plot the curve
    plt.plot(x, y)
    plt.show()

if __name__ == '__main__':
    N, circles = flat(15)

    eval(N, circles)