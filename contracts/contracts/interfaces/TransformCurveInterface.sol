// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

interface TransformCurveInterface {
    struct Circle {
        uint256 radius;
        uint256 frequency;
        uint256 phase;
    }

    struct Curve {
        address owner;
        uint256 N;
        Circle[] circles;
    }

    /**
     * @notice curve returns the x and y coordinates of the curve defined by the input circles.
     * @param curveId is the id of the curve.
     * @return x is an array of x coordinates.
     * @return y is an array of y coordinates.
     */
    function curve(
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
    function curveIndex(
          uint256 x
        , bytes32 curveId
    )
        external
        view
        returns (
            int256 y
        );
}