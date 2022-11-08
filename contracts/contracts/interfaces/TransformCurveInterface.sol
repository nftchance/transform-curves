// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface TransformCurveInterface {
    struct Circle {
        uint256 radius;
        uint256 frequency;
        uint256 phase;
    }

    /**
     * @notice curve returns the x and y coordinates of the curve defined by the input circles.
     * @param radii is an array of radii for the circles that define the curve.
     * @param frequencies is an array of frequencies for the circles that define the curve.
     * @param phases is an array of phases for the circles that define the curve.
     * @return x is an array of x coordinates for the curve.
     * @return y is an array of y coordinates for the curve.
     */
    function curve(
          int256[] memory radii
        , int256[] memory frequencies
        , int256[] memory phases
    ) 
        external 
        view 
        returns (
              int256[] memory x
            , int256[] memory y
        );

    /**
     * @notice index returns the y coordinate of the curve defined by the input circles at the input x coordinate.
     * @param x is the x coordinate of the point on the curve.
     * @param radii is an array of radii for the circles that define the curve.
     * @param frequencies is an array of frequencies for the circles that define the curve.
     * @param phases is an array of phases for the circles that define the curve.
     * @return y is the y coordinate of the point on the curve.
     */
    function index(
          uint256 x
        , int256[] memory radii
        , int256[] memory frequencies
        , int256[] memory phases
    )
        external
        view
        returns (
            int256 y
        );
}