// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import "@prb/math/contracts/PRBMathSD59x18.sol";

import { Trigonometry } from "./Trigonometry.sol";

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

import "hardhat/console.sol";

/**
 * @notice TransformCurve is a contract that implements the ability to define any curve on chain with the usage
 *         of circular transforms. Inputs are specified as circles with a center, radius, and angle. The
 *         transform function takes in a circle and returns a new circle. The transform function is applied
 *         to the input circle and the result is used as the input for the next transform. The output of the
 *         last transform is the output of the curve.
 * 
 * @dev This implementation uses a "close-enough" implementation of Trigonometry. The implementation is not
 *      exact, but it is close enough for the purposes of this contract. The implementation is based on the
 */

contract TransformCurve is
    Ownable
{
    using PRBMathSD59x18 for uint256;

    uint256 public N;

    uint256 constant SCALE = 1e18 * 2 * Trigonometry.PI; // scale to add to trig inputs so same output is expected

    struct Circle {
        uint256 radius;
        uint256 frequency;
        uint256 phase;
    }

    constructor(
        uint256 _N
    ) {
        N = _N;
    }

    function getCurve(
          int256[] memory radii
        , int256[] memory frequencies
        , int256[] memory phases
    ) 
        public 
        view 
        returns (
              int256[] memory x
            , int256[] memory y
        ) 
    {
        x = linSpace(0, int256(2 * Trigonometry.PI));

        y = new int256[](N);

        for (uint256 i = 0; i < radii.length; i++) {
            for (uint256 j = 0; j < N; j++) {
                uint256 degrees = uint256(frequencies[i] * x[j] + phases[i]);
                int256 sine = Trigonometry.sin(degrees);

                y[j] += radii[i] * sine;
            }
        }
    }

    function eval(
          uint256 x
        , int256[] memory radii
        , int256[] memory frequencies
        , int256[] memory phases
    )
        public
        view
        returns (
              int256 y
        )
    {
        for (uint256 i = 0; i < radii.length; i++) {
            uint256 degrees = uint256(frequencies[i] * int256(x) + phases[i]);
            int256 sine = Trigonometry.sin(degrees);

            y += radii[i] * sine;
        }
    }

    function linSpace(
          int256 start
        , int256 end
    ) 
        public 
        view 
        returns (
              int256[] memory x
        ) 
    {
        x = new int256[](N);

        for (uint256 i = 0; i < N; i++) {
            x[i] = start + (end - start) * int256(i) / (int256(N) - 1);
        }
    }

    function setN(
        uint256 _N
    ) 
        public 
        onlyOwner 
    {
        N = _N;
    }
}