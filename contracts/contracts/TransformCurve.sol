// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import { TransformCurveInterface } from "./interfaces/TransformCurveInterface.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

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
    /*//////////////////////////////////////////////////////////////
                                  STATE
    //////////////////////////////////////////////////////////////*/

    mapping(bytes32 => Curve) public curves;

    event CurveSet(
          bytes32 indexed curveId /// @dev encode address and curve nonce
        , uint256 indexed N
        , Circle[] indexed circles
    );

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {}

    /*//////////////////////////////////////////////////////////////
                                SETTERS
    //////////////////////////////////////////////////////////////*/

    /**
     * See {TransformCurveInterface:setCurve}
     */        
    function setCurve(
          uint256 _nonce
        , uint256 N
        , Circle[] memory _circles
    ) 
        override
        public 
    {
        /// @dev Create the caller-specific key.
        bytes32 _curveId = keccak256(abi.encode(
              _msgSender()
            , _nonce
        ));

        /// @dev Get the Curve object out of the contract.
        Curve storage curve = curves[_curveId];

        /// @dev Set the number of points.
        curve.N = N;

        /// @dev Set the circles.
        uint256 i;
        for (
            i; 
            i < _circles.length; 
            i++
        ) {
            curve.circles[i] = _circles[i];
        }

        /// @dev Emit the event.
        emit CurveSet(
              _curveId
            , N
            , _circles
        );
    }

    /*////////////////////////////////////////////////////////////
                                GETTERS
    //////////////////////////////////////////////////////////////*/

    /**
     * See {TransformCurveInterface:getCurve}
     */
    function getCurve(
          bytes32 _curveId
        , uint256 _pageLength
        , uint256 _page
    ) 
        override
        public 
        view 
        returns (
            int256[][2] memory points
        ) 
    {
        /// @dev Get the curve object.
        Curve storage curve = curves[_curveId];
        
        /// @dev Create an equidistant x-axis starting at 0 and ending at 2 * PI.
        points = getLinearSpace(
              curve.N
            , _pageLength
            , _page
            , 0
            , int256(2 * T.PI)
       );

        /// @dev Prepare the stack.
        uint256 i;
        uint256 j;

        /// @dev List of circles to apply to the x-axis.
        Circle[] storage circles = curve.circles;

        /// @dev Loop through all the indexes of the curve.
        /// @dev Is done in this order to prevent opening a huuuuuge loop multiple times.
        for (
            i; 
            i < _pageLength; 
            i++
        ) {
            /// @dev Loop through all of the circles.
            for (
                j; 
                j < circles.length; 
                j++
            ) {
                /// @dev Add the cumulative sine to the y-axis.
                points[i][1] += circles[j].radius * T.sin(
                    /// @dev Calculate the sine of the current x value.
                    uint256(circles[j].frequency * points[i][0] + circles[j].phase)
                );
            }
        }
    }

    /**
     * See {TransformCurveInterface:getCurveIndex}
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

    /**
     * @notice _linearSpace is a private function that returns an array of N equidistant values between a start and end.
     * @dev This function is written to heavily mirror the implementation of numpy.linspace.
     * @param _N is the number of values to return.
     * @param _pageLength The number of values to return per page.
     * @param _page The page to return.
     * @param _start The start of the range.
     * @param _end The end of the range.
    * @return space An array of N equidistant values between a start and end.
     */
    function getLinearSpace(
          uint256 _N
        , uint256 _pageLength
        , uint256 _page
        , int256 _start
        , int256 _end
    ) 
        public 
        pure 
        returns (
            int256[][2] memory space
        ) 
    {
        /// @dev Loop through the indexes and create the proper PI value.
        uint256 i = _page * _pageLength;
        for (
            i; 
            i < _N && i < (_page + 1) * _pageLength; 
            i++
        ) {
            space[i][0] = linearSpaceIndex(
                  int256(_N)
                , _start
                , _end
                , int256(i)
            );
        }
    }

    /**
     * @notice Utility function to calculate the value of a single index in the linear space array.
     * @param _N is the number of values in the array.
     * @param _start The start of the range.
     * @param _end The end of the range.
     * @param _i The index of the value to return.
     */
    function linearSpaceIndex(
          int256 _N
        , int256 _start
        , int256 _end
        , int256 _i
    ) 
        public
        pure
        returns (
            int256 space
        )
    { 
        space = _start + (_end - _start) * _i / (_N - 1);
    }
}