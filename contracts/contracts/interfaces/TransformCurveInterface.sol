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
        int256 start;
        int256 end;
    }

    /**
     * @notice Allows any user to set a curve using a personal nonce as their key.
     * @param nonce is the nonce used to generate the key.
     * @param N is the number of points to use when evaluating the curve.
     * @param circles is an array of circles that define the curve.
     * @param start is the start x-axis.
     * @param end is the last value of the x-axis.
     */
    function setCurve(
          uint256 nonce
        , uint256 N
        , Circle[] calldata circles
        , int256 start
        , int256 end
    )
        external;

    /**
     * @notice curve returns the x and y coordinates of the curve defined by the input circles.
     * @param curveId is the id of the curve.
     * @param pageLength is the number of points to return.
     * @param page is the page of points to return.
     * @return points is an array of [x,y] coordinates.
     */
    function getCurve(
          bytes32 curveId
        , uint256 pageLength
        , uint256 page
    ) 
        external 
        view 
        returns (
            int256[][] memory points
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