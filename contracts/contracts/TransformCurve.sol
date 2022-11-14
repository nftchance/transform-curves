// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import { TransformCurveInterface } from "./interfaces/TransformCurveInterface.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { PRBMathSD59x18 as P } from "@prb/math/contracts/PRBMathSD59x18.sol";

import { Trigonometry as T } from "./Trigonometry.sol";

/**
 * @notice TransformCurve is a contract that implements the ability to define any curve on chain with the usage
 *         of circular transforms. Inputs are specified as circles with a center, radius, and angle. The
 *         transform function takes in a circle and returns a new circle. 
 *
 *         The transform function is applied to the input circle and the result is used as the input for the next 
 *         transform. The output of the last transform is the output of the curve. 
 *
 *         This implementation enables the ability to forget handling the nuances of algebraic trigonometry and
 *         instead focus on the high level concepts of the curve. The creation of a TransformCurve is more akin to
 *         creating a function in a programming language than it is to creating a mathematical equation. Most accurately,
 *         TransformCurve relies heavily on the same methods use for signal decomposition in Fourier analysis.
 * @author nftchance
 */
contract TransformCurve is
      TransformCurveInterface
    , Ownable
{
    using P for uint256;

    /*//////////////////////////////////////////////////////////////
                                  STATE
    //////////////////////////////////////////////////////////////*/

    mapping(bytes32 => Curve) public curves;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {}

    /*//////////////////////////////////////////////////////////////
                                SETTERS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Allows any user to set a curve using a personal nonce as their key.
     * @param _nonce is the nonce used to generate the key.
     * @param _circles is an array of circles that define the curve.
     */
    function setCurve(
          uint256 _nonce
        , uint256 N
        , Circle[] calldata _circles
    ) 
        public 
    {
        bytes32 _curveId = keccak256(abi.encodePacked(
              _msgSender()
            , _nonce
        ));

        curves[_curveId] = Curve({
              N: N
            , circles: _circles
        });
    }

    /*//////////////////////////////////////////////////////////////
                                GETTERS
    //////////////////////////////////////////////////////////////*/

    /**
     * See {TransformCurveInterface:curve}
     */
    function getCurve(
        bytes32 _curveId
    ) 
        override
        public 
        view 
        returns (
              int256[] memory x
            , int256[] memory y
        ) 
    {
        /// @dev Get the curve object.
        Curve storage curve = curves[_curveId];

        /// @dev Create an equidistant x-axis starting at 0 and ending at 2 * PI.
        x = _linearSpace(
              curve.N
            , 0
            , int256(2 * T.PI)
        );

        /// @dev Instantiate empty y-axis.
        y = new int256[](curve.N);

        /// @dev Prepare the stack.
        uint256 i;
        uint256 j;

        /// @dev List of circles to apply to the x-axis.
        Circle[] storage circles = curve.circles;

        /// @dev Loop through all of the circles
        for (
            i; 
            i < circles.length; 
            i++
        ) {
            /// @dev Loop through all the indexes of the curve.
            for (
                j; 
                j < curve.N; 
                j++
            ) {
                /// @dev Add the cumulative sine to the y-axis.
                y[j] += circles[i].radius * T.sin(
                    /// @dev Calculate the sine of the current x value.
                    uint256(circles[i].frequency * x[j] + circles[i].phase)
                );
            }
        }
    }

    /**
     * See {TransformCurveInterface:index}
     */
    function getCurveIndex(
          int256 x
        , bytes32 _curveId
    )
        override
        public
        view
        returns (
              int256 y
        )
    {
        /// @dev Get the list of circles 
        Circle[] storage circles = curves[_curveId].circles;

        /// @dev Prepare the stack.
        uint256 i;

        /// @dev Loop through all of the circles
        for (
            i; 
            i < circles.length; 
            i++
        ) {
            /// @dev Add the cumulative sine to the y-axis.
            y += circles[i].radius * T.sin(
                /// @dev Calculate the sine of the current x value.
                uint256(circles[i].frequency * x + circles[i].phase)
            );
        }
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL GETTERS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice _linearSpace is a private function that returns an array of N equidistant values between a start and end.
     * @dev This function is written to heavily mirror the implementation of numpy.linspace.
     * @param _N is the number of values to return.
     * @param _start The start of the range.
     * @param _end The end of the range.
     * @return space An array of N equidistant values between a start and end.
     */
    function _linearSpace(
          uint256 _N
        , int256 _start
        , int256 _end
    ) 
        internal 
        pure 
        returns (
              int256[] memory space
        ) 
    {
        space = new int256[](_N);

        uint256 i;
        for (
            i; 
            i < _N; 
            i++
        ) {
            space[i] = _start + (_end - _start) * int256(i) / (int256(_N) - 1);
        }
    }
}