// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface TransformCurveInterface {
    struct Circle {
        int256 radius;
        int256 frequency;
        int256 phase;
    }

    struct Curve {
        uint256 N;
        Circle[] circles;
    }

    /**
     * @notice curve returns the x and y coordinates of the curve defined by the input circles.
     * @param curveId is the id of the curve.
     * @return x is an array of x coordinates.
     * @return y is an array of y coordinates.
     */
    function getCurve(
        bytes32 curveId
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
     * @param curveId is the id of the curve.
     * @return y is the y coordinate of the point on the curve.
     */
    function getCurveIndex(
          int256 x
        , bytes32 curveId
    )
        external
        view
        returns (
            int256 y
        );
}